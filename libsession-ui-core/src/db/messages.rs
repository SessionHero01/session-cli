use super::query::{QueryInfo, SQLRunnable};
use crate::clock::Timestamp;
use crate::session_id::{MENTION_ID_PATTERN, extract_mention_id};
use crate::utils::base64::Base64;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::iter::serde_iterator::SerdeIterator;
use crate::utils::json::Json;
use crate::utils::sqlite::statement_ext::StatementExt;
use anyhow::Context;
use bytes::Bytes;
use derive_more::Display;
use libsession_protos::protos::session::DataMessage;
use libsession_protos::protos::{MessageDeleteState, session::Content};
use mime::Mime;
use rusqlite::{Connection, DatabaseName, Row, prepare_and_bind, prepare_cached_and_bind};
use serde::{Deserialize, Serialize};
use serde_rusqlite::from_row;
use serde_with::{DeserializeFromStr, SerializeDisplay};
use std::borrow::Cow;
use std::fs::File;
use std::io::{Read, Write};
use strum::{AsRefStr, EnumString};
use tower::util::Either;

#[derive(
    Copy,
    Clone,
    Eq,
    PartialEq,
    Debug,
    Display,
    SerializeDisplay,
    DeserializeFromStr,
    EnumString,
    AsRefStr,
)]
pub enum MessageSyncState {
    Queued,
    PermanentlyFailed,
    Failed,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Message<'a> {
    pub repository: Cow<'a, str>,
    pub server_id: Option<Cow<'a, str>>,
    pub content: Json<Content>,
    pub sender: Cow<'a, str>,
    pub receiver: Cow<'a, str>,
    pub created_at: Timestamp,
    pub sent_at: Option<Timestamp>,
    pub expiration_at: Option<Timestamp>,
}

impl Message<'static> {
    pub fn borrow(&self) -> Message {
        Message {
            repository: Cow::Borrowed(self.repository.as_ref()),
            server_id: self.server_id.as_ref().map(|x| Cow::Borrowed(x.as_ref())),
            content: self.content.clone(),
            sender: Cow::Borrowed(self.sender.as_ref()),
            receiver: Cow::Borrowed(self.receiver.as_ref()),
            created_at: self.created_at,
            sent_at: self.sent_at,
            expiration_at: self.expiration_at,
        }
    }
}

pub type AttachmentId = u64;

#[derive(Deserialize)]
pub struct PendingMessage {
    #[serde(flatten)]
    pub message: Message<'static>,
    pub pending_attachment_ids: Json<Vec<AttachmentId>>,
    pub id: MessageId,
    pub send_state: Option<MessageSyncState>,
    pub sync_state: Option<MessageSyncState>,
}

pub type MessageId = i64;

#[derive(Serialize, Default)]
pub struct AttachmentMeta {
    pub width: Option<usize>,
    pub height: Option<usize>,
    pub thumbnail: Option<Base64<Bytes>>,
}

pub struct PendingAttachment {
    pub content_type: Mime,
    pub file: Either<File, Bytes>,
    pub file_name: String,
    pub meta: Json<AttachmentMeta>,
}

pub trait MessageRepositoryExt {
    fn save_messages<'a>(&self, messages: impl Iterator<Item = Message<'a>>) -> anyhow::Result<()>;

    fn requeue_message(&self, id: MessageId) -> anyhow::Result<()>;

    fn save_pending_attachments(
        &self,
        message_id: MessageId,
        attachments: impl Iterator<Item = PendingAttachment>,
    ) -> anyhow::Result<()>;

    fn delete_messages_by_server_ids<'a>(
        &self,
        server_ids: impl Iterator<Item = &'a str>,
    ) -> anyhow::Result<usize>;

    fn update_message_delete_state<'a>(
        &self,
        server_ids: impl Iterator<Item = Cow<'a, str>>,
        delete_state: MessageDeleteState,
    ) -> anyhow::Result<usize>;

    fn get_pending_attachment(
        &self,
        attachment_id: AttachmentId,
    ) -> anyhow::Result<Option<(usize, impl Read)>>;

    fn delete_pending_attachments(
        &self,
        ids: impl Iterator<Item = AttachmentId>,
    ) -> anyhow::Result<()>;
}

fn get_content_mentions(content: &Content) -> Option<NonEmpty<&str>> {
    match &content.data_message {
        Some(DataMessage {
            body: Some(body), ..
        }) => NonEmpty::from_iter(
            MENTION_ID_PATTERN
                .captures_iter(body.as_str())
                .map(extract_mention_id),
        ),

        _ => None,
    }
}

impl MessageRepositoryExt for Connection {
    fn save_messages<'a>(&self, messages: impl Iterator<Item = Message<'a>>) -> anyhow::Result<()> {
        let mut stmt = self.prepare_cached(
            //language=sqlite
            "INSERT OR IGNORE INTO
                messages(repository, server_id, content, sender, receiver, created_at, expiration_at, mentions)
            VALUES
                ($repository, $server_id, $content, $sender, $receiver, $created_at, $expiration_at, $mentions)"
        )?;

        for msg in messages {
            stmt.execute((
                msg.repository,
                msg.server_id,
                &msg.content,
                msg.sender,
                msg.receiver,
                msg.created_at,
                msg.expiration_at,
                get_content_mentions(&msg.content.0).map(Json),
            ))?;
        }

        Ok(())
    }

    fn requeue_message(&self, id: MessageId) -> anyhow::Result<()> {
        let _ = prepare_cached_and_bind!(
            self,
            //language=sqlite
            "UPDATE messages SET send_state = 'Queued' WHERE id = $id AND send_state IN ('Failed')"
        )
        .raw_execute()?;

        let _ = prepare_cached_and_bind!(
            self,
            //language=sqlite
            "UPDATE messages SET sync_state = 'Queued' WHERE id = $id AND sync_state IN ('Failed')"
        )
        .raw_execute()?;

        Ok(())
    }

    fn save_pending_attachments(
        &self,
        message_id: MessageId,
        attachments: impl Iterator<Item = PendingAttachment>,
    ) -> anyhow::Result<()> {
        for PendingAttachment {
            content_type,
            file,
            file_name,
            meta,
        } in attachments
        {
            let length = match &file {
                Either::Left(file) => file
                    .metadata()
                    .map(|m| m.len() as usize)
                    .context("Could not read metadata")?,

                Either::Right(b) => b.len(),
            };

            let content_type = content_type.as_ref();

            let attachment_row_id = prepare_cached_and_bind!(
                self,
                //language=sqlite
                r"
                INSERT INTO message_pending_attachments (message_id, file_name, content_type, content, status, meta)
                VALUES ($message_id, $file_name, $content_type, zeroblob($length), 'PENDING', $meta)
                RETURNING rowid
                "
            ).raw_query_single_row_first_column()
                    .context("No attachment is inserted")?.context("Error inserting attachment")?;

            let mut blob = self
                .blob_open(
                    DatabaseName::Main,
                    "message_pending_attachments",
                    "content",
                    attachment_row_id,
                    false,
                )
                .context("Opening attachment blob")?;

            match file {
                Either::Left(mut file) => {
                    std::io::copy(&mut file, &mut blob).context("Error copying attachment blob")?;
                }

                Either::Right(b) => {
                    blob.write_all(&b).context("Error writing blob")?;
                }
            }
        }

        Ok(())
    }

    fn delete_messages_by_server_ids<'a>(
        &self,
        server_ids: impl Iterator<Item = &'a str>,
    ) -> anyhow::Result<usize> {
        self.execute(
            //language=sqlite
            "DELETE FROM messages WHERE server_id IN (SELECT CAST(value AS TEXT) FROM json_each(?))",
            (Json(SerdeIterator::new(server_ids)),)
        ).context("Deleting messages by server IDs")
    }

    fn update_message_delete_state<'a>(
        &self,
        server_ids: impl Iterator<Item = Cow<'a, str>>,
        delete_state: MessageDeleteState,
    ) -> anyhow::Result<usize> {
        self.execute(
            //language=sqlite
            "UPDATE messages SET delete_state = ? WHERE server_id IN (SELECT CAST(value AS TEXT) FROM json_each(?))",
            (delete_state.as_str_name(), Json(SerdeIterator::new(server_ids)))
        ).context("Error update message delete status")
    }

    fn get_pending_attachment(
        &self,
        attachment_id: AttachmentId,
    ) -> anyhow::Result<Option<(usize, impl Read)>> {
        let row = prepare_and_bind!(
            self,
            //language=sqlite
            "SELECT rowid, length(content) FROM message_pending_attachments WHERE attachment_id = $attachment_id"
        )
        .raw_query_single_row(|r| Ok((r.get::<_, i64>(0)?, r.get::<_, usize>(1)?)))
        .context("Error executing query")?;

        let Some((row_id, size)) = row else {
            return Ok(None);
        };

        self.blob_open(
            DatabaseName::Main,
            "message_pending_attachments",
            "content",
            row_id,
            true,
        )
        .context("Opening attachment blob")
        .map(|r| Some((size, r)))
    }

    fn delete_pending_attachments(
        &self,
        ids: impl Iterator<Item = AttachmentId>,
    ) -> anyhow::Result<()> {
        self.execute(
            //language=sqlite
            "DELETE FROM message_pending_attachments WHERE attachment_id IN (SELECT value FROM json_each(?))",
            (Json(SerdeIterator::new(ids)),)
        ).context("Deleting pending attachments")?;

        Ok(())
    }
}

pub fn get_pending_message_query(
    message_repository: &str,
) -> impl SQLRunnable<Item = PendingMessage> {
    QueryInfo {
        name: "get_pending_messages",
        //language=sqlite
        sql: "SELECT m.*,
                 (SELECT json_group_array(a.attachment_id) FROM message_pending_attachments a WHERE a.message_id = m.id) AS pending_attachment_ids
            FROM messages m WHERE m.repository = $message_repository AND m.send_state = 'QUEUED' OR m.sync_state = 'QUEUED'
            ORDER BY m.created_at",
        params: (message_repository,),
        row_mapper: |r: &Row| from_row::<PendingMessage>(r).map_err(|e| rusqlite::Error::ToSqlConversionFailure(e.into())),
    }
}
