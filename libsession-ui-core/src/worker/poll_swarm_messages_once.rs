use crate::clock::ClockSource;
use crate::db::Repository;
use crate::db::message_sync_state::{
    MessageSyncStateRepository, SwarmMessageSyncState, get_swarm_message_sync_state_query,
};
use crate::network::NodeAddress;
use crate::network::swarm::SwarmManager;
use crate::network::swarm_auth::SwarmAuth;
use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::retrieve::{
    Message as SwarmMessage, RetrieveMessageRequest, RetrieveMessageResponse,
};
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::IndividualOrGroupID;
use anyhow::Context;

pub async fn poll_swarm_messages_once<SE, Auth>(
    ns: MessageNamespace,
    save_swarm_messages: impl FnOnce(Vec<SwarmMessage>) -> anyhow::Result<()> + Send,
    swarm_manager: &SwarmManager<SE>,
    executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Sync,
    repo: &Repository,
    clock: &ClockSource,
    swarm_auth: &Auth,
) -> anyhow::Result<()>
where
    SE: StorageRPCExecutor + Sync,
    SE::Args: Send + Clone,
    Auth: SwarmAuth,
    Auth::IDType: Into<IndividualOrGroupID> + Clone + AsRef<str>,
{
    let session_id: IndividualOrGroupID = swarm_auth.session_id().clone().into();

    let node = swarm_manager
        .get_random_node()
        .await
        .context("Error getting a random node")?;

    let sync_state = repo
        .query_first_row(&get_swarm_message_sync_state_query(ns, &session_id, &node))
        .context("Querying swarm message sync state")?;

    let RetrieveMessageResponse { messages, .. } = executor
        .execute_rpc(
            Some(node.clone()),
            RetrieveMessageRequest::new(
                ns,
                swarm_auth,
                sync_state.as_ref().map(|s| s.last_synced_hash.as_str()),
                None,
                clock.as_ref().now_or_uncalibrated(),
            )?,
        )
        .await?;

    tracing::info!("Received {} messages from node {node:?}", messages.len());

    let latest_hash = messages
        .iter()
        .max_by_key(|m| m.sent)
        .map(|m| m.hash.clone());

    save_swarm_messages(messages).context("Error saving swarm messages")?;

    if let Some(hash) = latest_hash {
        tracing::debug!("Latest hash for node {node:?} = {hash}");
        repo.with_connection(|c| {
            c.save_swarm_message_sync_state(
                ns,
                &session_id,
                &node,
                &SwarmMessageSyncState {
                    last_synced_hash: hash,
                },
            )
        })
        .context("Error saving sync state")?;
    } else {
        tracing::debug!("No messages found for node {node:?}");
    }

    Ok(())
}
