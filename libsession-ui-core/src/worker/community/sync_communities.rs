pub use super::download_community_messages::DownloadMessageCommand;
use crate::batcher::BatchRPCExecutor;
use crate::clock::ClockSource;
use crate::config::Group;
use crate::config::{ConfigWrapper, UserGroupsConfig};
use crate::db::Repository;
use crate::http_api::executor::{HttpRPCExecutor, HttpRPCRequest, HttpRPCResponse};
use crate::identity::Identity;
use crate::key::curve25519::Curve25519PubKey;
use crate::sogs_api::authenticated_executor::AuthenticatedHttpApiExecutor;
use crate::sogs_api::batch::{BatchRequest, new_batch_request_item};
use crate::sogs_api::community_id::{CommunityId, CommunityPublicKey};
use crate::utils::iter::non_empty::NonEmpty;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::{mpsc, oneshot};
use tokio::try_join;
use tracing::{Instrument, info_span, instrument};

pub enum CommunityCommand {
    ExecuteRPC {
        request: HttpRPCRequest,
        callback: oneshot::Sender<anyhow::Result<HttpRPCResponse>>,
    },

    SyncMessageCommand(DownloadMessageCommand),
}

#[instrument(skip_all, ret)]
pub async fn sync_communities<E>(
    executor: E,
    repo: Arc<Repository>,
    identity: Identity,
    config: ConfigWrapper<UserGroupsConfig>,
    clock_source: ClockSource,
    community_commands_rx: mpsc::Receiver<(CommunityId, CommunityCommand)>,
    config_strategy: impl super::super::strategy::PollStrategy + Send + Sync + Clone + 'static,
    message_strategy: impl super::super::strategy::PollStrategy + Send + Sync + Clone + 'static,
) -> anyhow::Result<()>
where
    E: HttpRPCExecutor<Args = Curve25519PubKey> + Send + Clone + Sync + 'static,
{
    let http_executor = AuthenticatedHttpApiExecutor {
        executor,
        user_identity: Some(identity.clone()),
        clock_source: clock_source.clone(),
    };
    let (http_executor, runner) = BatchRPCExecutor::new(
        |requests| async move {
            let mut items = Vec::new();
            let url = requests.head().base_url.clone();
            for req in requests.into_iter() {
                items.push(new_batch_request_item(req.request).await?);
            }

            Ok((url, BatchRequest(NonEmpty::from_vec(items).unwrap())))
        },
        http_executor,
        Duration::from_millis(100),
    );

    let sync_groups = super::super::sync_generic_groups::sync_generic_groups(
        config,
        |g| match g {
            Group::Community(info) => info.id().map(|id| (id, info)),
            _ => None,
        },
        |community_id, info, command_rx| {
            let executor = http_executor.clone();
            let identity = identity.clone();
            let repo = repo.clone();
            let message_strategy = message_strategy.clone();
            let config_strategy = config_strategy.clone();

            let span = info_span!("sync_community", ?community_id);
            async move {
                super::sync_community::sync_community(
                    executor,
                    CommunityPublicKey::from(info.pubkey),
                    &identity,
                    community_id,
                    &repo,
                    command_rx,
                    config_strategy,
                    message_strategy,
                )
                .await
            }
            .instrument(span)
        },
        community_commands_rx,
    );

    let runner = runner.run();

    try_join!(runner, sync_groups)?;
    Ok(())
}

#[instrument(skip(_repo))]
fn clean_up_community(_repo: &Repository, _id: &CommunityId) -> anyhow::Result<()> {
    todo!()
}
