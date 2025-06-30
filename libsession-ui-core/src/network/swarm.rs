use super::NodeAddress;
use crate::oxenss::retrieve_swarm_nodes::RetrieveSwarmNodesRequest;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::IndividualOrGroupID;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::sync::async_retrieve::SharedAsyncRetrieveState;
use anyhow::Context;
use rand::thread_rng;
use std::sync::Arc;
use std::time::Duration;

type SwarmNodes = NonEmpty<NodeAddress>;

pub struct SwarmManager<E: StorageRPCExecutor> {
    id: IndividualOrGroupID,
    executor: E,
    executor_args: E::Args,
    nodes: SharedAsyncRetrieveState<SwarmNodes>,
}

impl<E> SwarmManager<E>
where
    E: StorageRPCExecutor + Sync,
    E::Args: Send + Clone,
{
    pub fn new(id: IndividualOrGroupID, executor: E, executor_args: E::Args) -> Self {
        Self {
            id,
            executor,
            executor_args,
            nodes: SharedAsyncRetrieveState::new(Duration::from_secs(3600), Duration::from_secs(1)),
        }
    }

    pub async fn get_nodes(&self) -> anyhow::Result<Arc<SwarmNodes>> {
        self.nodes
            .get_or_retrieve(move || async move {
                self.executor
                    .execute_rpc(
                        self.executor_args.clone(),
                        RetrieveSwarmNodesRequest {
                            session_id: self.id.clone(),
                        },
                    )
                    .await
                    .and_then(|nodes| {
                        NonEmpty::from_iter(nodes.snodes.into_iter().map(|n| n.address()))
                            .context("No nodes returned")
                    })
            })
            .await
    }

    pub async fn get_random_node(&self) -> anyhow::Result<NodeAddress> {
        Ok(self
            .get_nodes()
            .await?
            .choose_random(&mut thread_rng())
            .clone())
    }
}
