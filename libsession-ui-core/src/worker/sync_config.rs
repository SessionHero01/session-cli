use crate::clock::ClockSource;
use crate::config::{Config, ConfigWrapper, PushRequestCallback};
use crate::db::Repository;
use crate::db::config::{ConfigRepositoryExt, SaveAsRows};
use crate::network::NodeAddress;
use crate::network::swarm::SwarmManager;
use crate::network::swarm_auth::SwarmAuth;
use crate::oxenss::retrieve::Message;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::IndividualOrGroupID;
use crate::utils::errors::{AnyhowExt, ToStdError};
use anyhow::Context;
use tokio::sync::mpsc;
use tokio::try_join;

use super::poll_swarm_messages_once::poll_swarm_messages_once;
use tracing::{Instrument, instrument};

#[instrument(skip_all, fields(
    config_id = config_database_id,
    config_name = C::CONFIG_TYPE_NAME), ret)]
pub async fn sync_config<C, Auth, SE>(
    executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Sync,
    swarm_manager: &SwarmManager<SE>,
    config_database_id: Option<&str>,
    config: ConfigWrapper<C>,
    config_push_request_rx: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,
    repo: &Repository,
    auth: &Auth,
    clock: &ClockSource,
    strategy: impl super::strategy::PollStrategy + Sync,
    poll_results: Option<mpsc::Sender<anyhow::Result<()>>>,
    side_channel_message_rx: Option<mpsc::Receiver<Vec<Message>>>,
) -> anyhow::Result<()>
where
    C: Config + SaveAsRows + Send + Sync,
    SE: StorageRPCExecutor + Sync,
    SE::Args: Send + Sync + Clone,
    Auth: SwarmAuth,
    Auth::IDType: Into<IndividualOrGroupID> + Clone + AsRef<str>,
{
    let poll = async {
        loop {
            let r = poll_swarm_messages_once(
                C::NAMESPACE,
                |messages| {
                    config.merge(&messages);
                    Ok(())
                },
                swarm_manager,
                &executor,
                repo,
                clock,
                auth,
            )
            .await;

            if let Err(err) = &r {
                tracing::error!(?err, "Error while polling config");
                strategy.report_error(err);
            }

            if let Some(poll_results) = &poll_results {
                let _ = poll_results.send(r).await;
            }

            if strategy.next_poll().await.is_none() {
                return Ok(());
            }
        }
    };

    let pipe_side_channel_messages = async {
        if let Some(mut rx) = side_channel_message_rx {
            while let Some(messages) = rx.recv().await {
                tracing::debug!("Received {} side channel messages", messages.len());
                config.merge(&messages);

                if let Some(poll_results) = &poll_results {
                    let _ = poll_results.send(Ok(())).await;
                }
            }
        }

        Ok(())
    }
    .instrument(tracing::debug_span!("pipe_side_channel_messages"));

    let dump = dump_config_if_needed(&config, repo, config_database_id, clock);
    let push = push_config_if_needed(&executor, &config, config_push_request_rx, auth);

    try_join!(poll, pipe_side_channel_messages, dump, push)?;
    Ok(())
}

#[instrument(skip_all, ret)]
async fn dump_config_if_needed<C: Config + SaveAsRows>(
    config_wrapper: &ConfigWrapper<C>,
    repo: &Repository,
    config_id: Option<&str>,
    clock_source: &ClockSource,
) -> anyhow::Result<()> {
    let mut change_notifications = config_wrapper.subscribe();
    while change_notifications.recv().await.is_ok() {
        repo.with_connection(|conn| {
            config_wrapper.mutate(|config| {
                conn.save_config_dump_and_rows(
                    config,
                    config_id,
                    clock_source.now_or_uncalibrated(),
                )
                .context("Saving config to db")
            })
        })?;
    }

    Ok(())
}

#[instrument(skip_all, ret)]
async fn push_config_if_needed<C: Config>(
    _executor: impl StorageRPCExecutor,
    config: &ConfigWrapper<C>,
    mut push_requests_rx: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,
    _swarm_auth: &impl SwarmAuth,
) -> anyhow::Result<()> {
    let mut pending_request_callbacks = vec![];
    while let Some(push_request) = push_requests_rx.recv().await {
        if let Some(push_request) = push_request {
            pending_request_callbacks.push(push_request);
        }

        // Drain all the request callbacks in the channel now
        while !push_requests_rx.is_empty() {
            if let Ok(Some(req)) = push_requests_rx.try_recv() {
                pending_request_callbacks.push(req);
            }
        }

        let push = async {
            let pending = config.mutate(|config| {
                if !config.needs_push() {
                    return Ok(None);
                }

                config.push()
            })?;

            let Some(pending) = pending else {
                // No push needed: it is counted as a success
                return anyhow::Ok(());
            };

            //TODO: Push delete and confirm
            config.confirm_pushed(pending.seq, &["hash_number"]);
            Ok(())
        };

        if let Err(e) = push.await {
            let (e, shared) = e.share();
            for callback in pending_request_callbacks.drain(..) {
                let _ = callback.send(Err(shared.clone().to_std_error().into()));
            }

            tracing::error!("push failed with {:?}", e);
        } else {
            for callback in pending_request_callbacks.drain(..) {
                let _ = callback.send(Ok(()));
            }
        }
    }

    Ok(())
}
