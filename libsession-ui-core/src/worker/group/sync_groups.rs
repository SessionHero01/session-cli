use super::sync_group::{GroupCommand, sync_group};
use crate::clock::ClockSource;
use crate::config::{ConfigWrapper, Group, UserGroupsConfig};
use crate::db::Repository;
use crate::identity::Identity;
use crate::network::NodeAddress;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::GroupID;
use std::sync::Arc;
use tokio::sync::mpsc;
use tracing::{Instrument, instrument};

#[instrument(skip_all, ret)]
pub async fn sync_groups(
    executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Clone + Send + Sync + 'static,
    identity: Identity,
    repo: Arc<Repository>,
    config: ConfigWrapper<UserGroupsConfig>,
    clock: ClockSource,
    group_command_rx: mpsc::Receiver<(GroupID, GroupCommand)>,
    config_strategy: impl super::super::strategy::PollStrategy + Send + Sync + Clone + 'static,
    message_strategy: impl super::super::strategy::PollStrategy + Send + Sync + Clone + 'static,
) -> anyhow::Result<()> {
    super::super::sync_generic_groups::sync_generic_groups(
        config.clone(),
        |g| match g {
            Group::Group(info) if !info.is_kicked() && !info.invited => {
                info.group_id().map(|id| (id, info))
            }
            _ => None,
        },
        |group_id, _, command_rx| {
            let executor = executor.clone();
            let identity = identity.clone();
            let config = config.clone();
            let repo = repo.clone();
            let clock = clock.clone();
            let message_strategy = message_strategy.clone();
            let config_strategy = config_strategy.clone();
            let span = tracing::info_span!("sync_group", ?group_id);

            async move {
                let r = sync_group(
                    executor,
                    &identity,
                    &group_id,
                    config,
                    &repo,
                    &clock,
                    command_rx,
                    message_strategy,
                    config_strategy,
                )
                .await;

                if let Err(e) = &r {
                    tracing::error!(?e, "Error syncing group");
                }

                r
            }
            .instrument(span)
        },
        group_command_rx,
    )
    .await
}
