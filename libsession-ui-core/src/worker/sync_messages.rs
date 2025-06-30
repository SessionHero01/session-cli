use crate::clock::ClockSource;
use crate::db::Repository;
use crate::db::messages::{Message as DbMessage, MessageRepositoryExt};
use crate::network::NodeAddress;
use crate::network::swarm::SwarmManager;
use crate::network::swarm_auth::SwarmAuth;
use crate::oxenss::message::{RegularMessage, RegularMessageDecoder};
use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::retrieve::{Message as SwarmMessage, Message};
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::IndividualOrGroupID;
use crate::utils::json::Json;
use std::borrow::Cow;
use tokio::sync::mpsc;
use tokio::try_join;
use tracing::{Instrument, instrument};

#[instrument(skip_all, fields(?namespace), ret)]
pub async fn sync_regular_messages<Decoder, Auth, SE>(
    namespace: MessageNamespace,
    repo: &Repository,
    executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Sync,
    swarm_auth: &Auth,
    swarm_manager: &SwarmManager<SE>,
    strategy: impl super::strategy::PollStrategy + Sync,
    clock_source: &ClockSource,
    side_channel_messages_rx: Option<mpsc::Receiver<Vec<Message>>>,
) -> anyhow::Result<()>
where
    SE: StorageRPCExecutor + Send + Sync,
    SE::Args: Send + Sync + Clone,
    Auth: SwarmAuth + Send + Sync,
    Auth::IDType: Into<IndividualOrGroupID> + Clone + AsRef<str>,
    Decoder: RegularMessageDecoder,
{
    let save_swarm_messages = |messages: Vec<SwarmMessage>| {
        let db_messages = messages
            .into_iter()
            .filter_map(|m| {
                create_db_message::<Decoder, _>(swarm_auth, m)
                    .inspect_err(|err| {
                        tracing::error!(?err, "Error creating db message");
                    })
                    .ok()
            })
            .collect::<Vec<_>>();

        if db_messages.is_empty() {
            return Ok(());
        }

        repo.with_connection(|c| c.save_messages(db_messages.into_iter()))
    };

    let do_poll = async {
        loop {
            let r = super::poll_swarm_messages_once::poll_swarm_messages_once(
                namespace,
                save_swarm_messages,
                swarm_manager,
                &executor,
                repo,
                clock_source,
                swarm_auth,
            )
            .await;

            if let Err(err) = &r {
                tracing::error!(?err, "Error while polling messages");
                strategy.report_error(err);
            }

            if strategy.next_poll().await.is_none() {
                return anyhow::Ok(());
            }
        }
    }
    .instrument(tracing::info_span!("poll"));

    let save_side_channel_messages = async {
        if let Some(mut side_channel_messages_rx) = side_channel_messages_rx {
            while let Some(messages) = side_channel_messages_rx.recv().await {
                save_swarm_messages(messages)?;
            }
        }
        Ok(())
    }
    .instrument(tracing::info_span!("save_side_channel_messages"));

    try_join!(do_poll, save_side_channel_messages)?;
    Ok(())
}

fn create_db_message<Decoder, Auth>(
    auth: &Auth,
    api_message: SwarmMessage,
) -> anyhow::Result<DbMessage>
where
    Auth: SwarmAuth,
    Auth::IDType: AsRef<str>,
    Decoder: RegularMessageDecoder,
{
    let repository = Cow::Borrowed(auth.session_id().as_ref());
    let SwarmMessage {
        data,
        hash,
        expiration,
        sent,
    } = api_message;

    let RegularMessage {
        sender,
        content,
        timestamp: created_at,
    } = Decoder::decode_and_decrypt(data.as_slice(), auth)?;

    let sender: Cow<str> = if repository.as_ref().eq_ignore_ascii_case(sender.as_str()) {
        Cow::Borrowed("")
    } else {
        Cow::Owned(sender.to_string())
    };

    let receiver: Cow<str> = match content
        .data_message
        .as_ref()
        .and_then(|d| d.sync_target.as_ref())
    {
        Some(c) if !repository.as_ref().eq_ignore_ascii_case(c.as_str()) => {
            Cow::Owned(c.to_string())
        }
        _ => Cow::Borrowed(""),
    };

    Ok(DbMessage {
        repository,
        server_id: Some(Cow::Owned(hash)),
        content: Json(content),
        sender,
        receiver,
        created_at,
        sent_at: Some(sent),
        expiration_at: Some(expiration),
    })
}
