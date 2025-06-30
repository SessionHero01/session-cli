use crate::clock::ClockSource;
use crate::db::Repository;
use crate::db::messages::{
    MessageId, MessageRepositoryExt, MessageSyncState, PendingMessage, get_pending_message_query,
};
use crate::files::encrypt::encrypt_aes_gcm;
use crate::files_api::save_file::SaveFile;
use crate::http_api::executor::HttpRPCExecutor;
use crate::key::curve25519::Curve25519PubKey;
use crate::network::embedded::FILE_SERVER_PUB_KEYS;
use crate::network::swarm_auth::SwarmAuth;
use crate::oxenss::message::{RegularMessage, RegularMessageEncoder};
use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::oxenss::store::StoreMessageRequest;
use crate::session_id::{IndividualOrGroupID, SessionID};
use crate::utils::errors::ToStdError;
use crate::utils::http::base_url::HttpBaseUrl;
use anyhow::{Context, format_err};
use futures_util::future::{Either, join_all, select};
use futures_util::{FutureExt, StreamExt, join, pin_mut};
use libsession_protos::protos::session::AttachmentPointer;
use std::collections::HashSet;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::mpsc;
use tracing::instrument;

pub async fn send_swarm_messages<Encoder, Auth, E, HE>(
    namespace: MessageNamespace,
    sender_id: IndividualOrGroupID,
    auth: &Auth,
    repo: &Repository,
    rpc_executor: E,
    rpc_executor_args: E::Args,
    http_executor: HE,
    clock_source: &ClockSource,
    mut retry_request_rx: mpsc::Receiver<MessageId>,
) -> anyhow::Result<()>
where
    Encoder: RegularMessageEncoder,
    Auth: SwarmAuth,
    Auth::IDType: AsRef<str>,
    E: StorageRPCExecutor + Sync,
    E::Args: Send + Clone,
    HE: HttpRPCExecutor<Args = Curve25519PubKey> + Sync,
{
    let session_id = auth.session_id().as_ref();
    let query = get_pending_message_query(session_id);
    let mut messages = Box::pin(repo.rerun_query_on_changes(Duration::from_secs(1), query)?);
    let sender_id: SessionID = sender_id.into();

    loop {
        let next_retry = retry_request_rx.recv();
        let next_pendings = messages.next();
        pin_mut!(next_retry, next_pendings);

        match select(next_retry, next_pendings).await {
            Either::Left((Some(msg_id), _)) => {
                repo.with_transaction(|t| t.requeue_message(msg_id))
                    .context("Error queuing message for retry")?;
            }

            Either::Right((Some(messages), _)) => {
                let messages = messages.context("Error fetching pending messages")?;

                tracing::debug!("About to send/sync {} messages", messages.len());

                let _ = join_all(messages.into_iter().map(|p| {
                    send_and_sync_message::<Encoder, _, _>(
                        namespace,
                        p,
                        repo,
                        &rpc_executor,
                        rpc_executor_args.clone(),
                        &http_executor,
                        &sender_id,
                        clock_source,
                        auth,
                    )
                }))
                .await;
            }

            Either::Left((None, _)) | Either::Right((None, _)) => return Ok(()),
        }
    }
}

#[instrument(skip_all, fields(message_id=id), ret)]
async fn send_and_sync_message<Encoder, HE, E>(
    ns: MessageNamespace,
    PendingMessage {
        mut message,
        mut pending_attachment_ids,
        id,
        send_state,
        sync_state,
    }: PendingMessage,
    repo: &Repository,
    executor: E,
    executor_args: E::Args,
    http_executor: HE,
    sender_id: &SessionID,
    clock_source: &ClockSource,
    auth: &impl SwarmAuth,
) -> anyhow::Result<()>
where
    Encoder: RegularMessageEncoder,
    HE: HttpRPCExecutor<Args = Curve25519PubKey> + Sync,
    E: StorageRPCExecutor + Sync,
    E::Args: Send + Clone,
{
    let upload_attachments = async {
        let data_message = match (
            &mut message.content.0.data_message,
            pending_attachment_ids.0.is_empty(),
        ) {
            (Some(data), false) => data,
            _ => return Ok(message),
        };

        let file_server_url = HttpBaseUrl::new(FILE_SERVER_PUB_KEYS[0].host).unwrap();
        let file_server_key =
            Curve25519PubKey::from_hex(FILE_SERVER_PUB_KEYS[0].pub_key_hex).unwrap();

        let upload_tasks = pending_attachment_ids
            .0
            .iter()
            .filter_map(|id| {
                let data = repo.with_connection(|c| {
                    let Some((len, mut data)) = c.get_pending_attachment(*id)? else {
                        return Ok(None);
                    };

                    encrypt_aes_gcm(&mut data, Some(len)).map(Some)
                });

                let data = match data {
                    Ok(Some(data)) => data,
                    Ok(None) => return None,
                    Err(err) => {
                        tracing::error!(?err, "Error reading attachment data");
                        return None;
                    }
                };

                Some((*id, data))
            })
            .map(|(id, data)| {
                http_executor
                    .execute_rpc(
                        file_server_key.clone(),
                        (file_server_url.clone(), SaveFile(data.cipher)),
                    )
                    .map(move |t| t.map(move |r| (id, r.id, data.key)))
            });

        let mut uploaded_attachment_ids = HashSet::new();

        data_message.attachments.extend(
            join_all(upload_tasks)
                .await
                .into_iter()
                .filter_map(|t| match t {
                    Ok((id, file_id, key)) => Some((
                        id,
                        file_server_url
                            .join("file")
                            .ok()?
                            .join(&file_id.to_string())
                            .ok()?,
                        key,
                    )),
                    Err(e) => {
                        tracing::error!("Error uploading attachment: {e:?}");
                        None
                    }
                })
                .map(|(id, url, key)| {
                    uploaded_attachment_ids.insert(id);
                    AttachmentPointer {
                        id,
                        url: Some(url.to_string()),
                        key: Some(key.into()),
                        ..Default::default()
                    }
                }),
        );

        data_message.attachments.sort_by_key(|p| p.id);

        // Save the message back to the database to save our progress of uploaded images
        repo.with_connection(|c| c.save_messages([message.borrow()].into_iter()))?;

        // Remove the uploaded attachments from the pending list
        pending_attachment_ids
            .0
            .retain(|id| !uploaded_attachment_ids.contains(&id));

        if !uploaded_attachment_ids.is_empty() {
            repo.with_connection(|c| {
                c.delete_pending_attachments(uploaded_attachment_ids.iter().copied())
            })
            .map_err(Arc::new)?;
        }

        // If there are still pending attachments, we need to mark the process as error, but we
        // will keep the record in the database (done prior to this).
        if !pending_attachment_ids.0.is_empty() {
            return Err(Arc::new(format_err!(
                "Not all attachments are uploaded successfully"
            )));
        }

        Result::<_, Arc<anyhow::Error>>::Ok(message)
    }
    .shared();

    let send_to_other = {
        let upload_attachments = upload_attachments.clone();
        async move {
            if send_state != Some(MessageSyncState::Queued) {
                // No receiver or not queued, no need to send
                return Ok(());
            }

            let message = upload_attachments.await.map_err(|e| e.to_std_error())?;

            if message.receiver.is_empty() {
                return Ok(());
            }

            let dst_pub_key = Curve25519PubKey::from_hex(message.receiver.as_ref())
                .context("Invalid receiver pub key")?;

            let message = Encoder::encrypt_and_encode(
                sender_id,
                clock_source.now_or_uncalibrated(),
                &message.content.0,
                auth,
                Some(&dst_pub_key),
            )?;

            let resp = executor
                .execute_rpc(
                    executor_args.clone(),
                    StoreMessageRequest::new(
                        ns,
                        &message,
                        clock_source.now_or_uncalibrated(),
                        auth,
                        &dst_pub_key,
                        None,
                        Duration::from_secs(3600 * 24 * 14),
                    )?,
                )
                .await?;

            anyhow::Ok(())
        }
    };

    let sync_to_ours = {
        let upload_attachments = upload_attachments.clone();
        async move {
            if !matches!(send_state, Some(MessageSyncState::Queued)) {
                return anyhow::Ok(());
            }

            Ok(())
        }
    };

    let (upload_attachments, send_result, sync_result) =
        join!(upload_attachments, send_to_other, sync_to_ours);

    upload_attachments
        .map(|_| ())
        .map_err(|e| anyhow::Error::from(e.to_std_error()))
        .or(send_result.context("Error sending message to the other side"))
        .or(sync_result.context("Error syncing message"))
}
