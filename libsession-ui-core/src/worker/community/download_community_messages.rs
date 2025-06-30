use crate::crypto::strip_message_padding;
use crate::db::community_message_reaction::{
    CommunityMessageReaction, CommunityMessageReactionRepository,
};
use crate::db::message_sync_state::{
    CommunityMessageSyncState, MessageSyncStateRepository, get_community_message_sync_state_query,
};
use crate::db::messages::MessageRepositoryExt;
use crate::db::{Repository, messages::Message as DbMessage};
use crate::http_api::executor::HttpRPCExecutor;
use crate::sogs_api::community_id::CommunityId;
use crate::sogs_api::get_messages::{GetMessagesBefore, GetMessagesSince, GetRecentMessages};
use crate::sogs_api::message::{MessageId, MessageOrDelete, MessageReaction, MessageSeqNo};
use crate::utils::json::Json;
use anyhow::Context;
use futures_util::FutureExt;
use futures_util::future::{Either, select};
use libsession_protos::protos::MessageDeleteState;
use libsession_protos::protos::session::Content;
use prost::Message as ProstMessage;
use std::borrow::Cow;
use std::collections::HashMap;
use std::pin::pin;
use tokio::sync::{mpsc, oneshot};
use tracing::instrument;

const LOAD_LIMIT: usize = 256;

pub enum DownloadMessageCommand {
    LoadEarlierMessage {
        callback: oneshot::Sender<anyhow::Result<usize>>,
    },
}

#[instrument(skip(executor, args, repo, commands, strategy), ret)]
pub async fn download_community_messages<E, Strategy>(
    id: &CommunityId,
    repo: &Repository,
    mut commands: mpsc::Receiver<DownloadMessageCommand>,
    executor: E,
    args: E::Args,
    strategy: Strategy,
) -> anyhow::Result<()>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Clone + Send,
    Strategy: super::super::strategy::PollStrategy + Sync,
{
    let sync_state = repo
        .query_first_row(&get_community_message_sync_state_query(id.clone()))
        .context("Error getting community sync state")?;

    // If we don't have a sync state, we must load the first batch of message successfully before we can
    // actually do anything else
    let mut sync_state = match sync_state {
        Some(v) => v,
        None => load_initial_messages(id, repo, &executor, args.clone(), &strategy).await?,
    };

    // Main loop - waiting for either message polling interval or a trigger to load earlier messages
    loop {
        let recv_command = pin!(commands.recv());
        let poll = pin!(strategy.next_poll());

        match select(recv_command.fuse(), poll.fuse()).await {
            Either::Left((Some(DownloadMessageCommand::LoadEarlierMessage { callback }), _))
                if !sync_state.has_earlier_messages =>
            {
                tracing::info!("No earlier messages available");
                let _ = callback.send(Ok(0));
            }

            Either::Left((Some(DownloadMessageCommand::LoadEarlierMessage { callback }), _)) => {
                tracing::info!("Received load earlier message command, loading earlier messages");
                let _ = callback.send(
                    load_earlier_messages(id, repo, &mut sync_state, &executor, args.clone()).await,
                );
            }

            Either::Right(_) => {
                tracing::info!("Polling for new messages");
                if let Err(e) =
                    load_latest_messages(id, repo, &mut sync_state, &executor, args.clone()).await
                {
                    tracing::error!("Error loading latest messages: {e}");
                    strategy.report_error(&e);
                }
            }

            // Command channel closed
            Either::Left((None, _)) => {
                tracing::info!("Command channel closed, exiting");
                return Ok(());
            }
        }
    }
}

async fn load_latest_messages<E>(
    id: &CommunityId,
    repo: &Repository,
    sync_state: &mut CommunityMessageSyncState,
    executor: E,
    executor_args: E::Args,
) -> anyhow::Result<usize>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Send,
{
    let messages = executor
        .execute_rpc(
            executor_args,
            (
                id.server_url().clone(),
                GetMessagesSince {
                    room: id.room().to_string(),
                    since_msg_seq_no: sync_state.latest_seq,
                    limit: Some(LOAD_LIMIT),
                },
            ),
        )
        .await?;

    save_messages_and_sync_state(id, repo, messages, sync_state, false, true)
}

async fn load_earlier_messages<E>(
    id: &CommunityId,
    repo: &Repository,
    sync_state: &mut CommunityMessageSyncState,
    executor: E,
    executor_args: E::Args,
) -> anyhow::Result<usize>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Send,
{
    let messages = executor
        .execute_rpc(
            executor_args,
            (
                id.server_url().clone(),
                GetMessagesBefore {
                    room: id.room().to_string(),
                    before_msg_id: sync_state.earliest_message_id,
                    limit: Some(LOAD_LIMIT),
                },
            ),
        )
        .await?;

    save_messages_and_sync_state(id, repo, messages, sync_state, true, false)
}

async fn load_initial_messages<E>(
    id: &CommunityId,
    repo: &Repository,
    executor: E,
    executor_args: E::Args,
    strategy: impl super::super::strategy::PollStrategy,
) -> anyhow::Result<CommunityMessageSyncState>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Clone + Send,
{
    loop {
        match executor
            .execute_rpc(
                executor_args.clone(),
                (
                    id.server_url().clone(),
                    GetRecentMessages {
                        room: id.room().to_string(),
                        limit: Some(LOAD_LIMIT),
                    },
                ),
            )
            .await
        {
            Ok(v) => {
                let mut state = CommunityMessageSyncState {
                    has_earlier_messages: true,
                    earliest_message_id: 0,
                    latest_seq: 0,
                };

                save_messages_and_sync_state(id, repo, v, &mut state, true, true)?;
                return anyhow::Ok(state);
            }

            Err(e) => {
                tracing::error!("Error getting recent message: {e}, retry in a few seconds");
                strategy.report_error(&e);
                strategy.next_poll().await.context("Cancelled")?;
            }
        }
    }
}

fn save_messages_and_sync_state(
    id: &CommunityId,
    repo: &Repository,
    messages: Vec<MessageOrDelete>,
    sync_state: &mut CommunityMessageSyncState,
    update_earliest: bool,
    update_latest: bool,
) -> anyhow::Result<usize> {
    struct SaveMessage<'a> {
        seq: MessageSeqNo,
        server_id: MessageId,
        message: DbMessage<'a>,
    }

    struct SaveMessageReaction {
        msg_server_id: MessageId,
        reaction_by_emoji: HashMap<String, MessageReaction>,
    }

    let mut save_messages = vec![];
    let mut save_messages_reactions = vec![];
    let mut delete_messages = vec![];

    for message in messages {
        match message.map_data(|c| Content::decode(strip_message_padding(c.as_slice()))) {
            Ok(MessageOrDelete::Message(msg)) => {
                save_messages.push(SaveMessage {
                    seq: msg.seqno,
                    server_id: msg.id,
                    message: DbMessage {
                        repository: Cow::Borrowed(id.as_str()),
                        server_id: Some(Cow::Owned(msg.id.to_string())),
                        content: Json(msg.data),
                        sender: Cow::Owned(msg.sender_id),
                        receiver: Cow::Borrowed(""), // Empty receiver == sent to community
                        created_at: msg.posted.0,
                        sent_at: Some(msg.posted.0),
                        expiration_at: None,
                    },
                });

                save_messages_reactions.push(SaveMessageReaction {
                    msg_server_id: msg.id,
                    reaction_by_emoji: msg.reaction_by_emoji,
                });
            }

            Ok(MessageOrDelete::Deleted(d)) => {
                delete_messages.push(d);
            }

            Err(e) => {
                tracing::error!("Error decoding message: {e:?}");
            }
        }
    }

    if update_earliest && !save_messages.is_empty() {
        sync_state.earliest_message_id = save_messages
            .iter()
            .map(|msg| msg.server_id)
            .min()
            .context("Unable to find earliest message")?;

        sync_state.has_earlier_messages = !save_messages.is_empty();
    }

    if update_latest && !save_messages.is_empty() {
        sync_state.latest_seq = save_messages
            .iter()
            .map(|msg| msg.seq)
            .max()
            .context("Unable to find latest message")?;
    }

    if !save_messages.is_empty() || !delete_messages.is_empty() {
        let num_saved = save_messages.len();
        repo.with_transaction(move |tx| {
            tx.save_messages(save_messages.into_iter().map(|m| m.message))?;

            for SaveMessageReaction {
                msg_server_id,
                reaction_by_emoji: reactions,
            } in save_messages_reactions
            {
                tx.save_community_message_reactions(
                    id,
                    msg_server_id,
                    &reactions
                        .iter()
                        .map(|(emoji, reaction)| {
                            (
                                emoji.as_str(),
                                CommunityMessageReaction {
                                    index: reaction.index,
                                    count: reaction.count,
                                    reactors: reaction.reactors.as_slice(),
                                },
                            )
                        })
                        .collect(),
                )?;
            }

            tx.update_message_delete_state(
                delete_messages
                    .into_iter()
                    .map(|d| Cow::Owned(d.id.to_string())),
                MessageDeleteState::Deleted,
            )?;
            tx.save_community_message_sync_state(id, sync_state)?;

            Ok(())
        })
        .context("Saving messages")?;

        Ok(num_saved)
    } else {
        Ok(0)
    }
}
