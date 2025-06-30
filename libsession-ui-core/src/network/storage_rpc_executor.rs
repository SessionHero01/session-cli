use crate::network::{Network, NodeAddress};
use crate::oxenss::rpc::{StorageRPCRequest, StorageRPCResponse};
use crate::rpc::RPCExecutor;
use anyhow::Context;

#[derive(Clone)]
pub struct NetworkNodeRpcExecutor<N>(N);

impl<N> NetworkNodeRpcExecutor<N> {
    pub fn new(network: N) -> Self {
        Self(network)
    }
}

impl<N> RPCExecutor<StorageRPCRequest, StorageRPCResponse> for NetworkNodeRpcExecutor<N>
where
    N: Network + Sync,
{
    type Args = Option<NodeAddress>;

    async fn execute(
        &self,
        addr: Self::Args,
        request: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        if let Some(addr) = addr {
            self.0
                .send_onion_request_to_node(addr, request)
                .await
                .context("Error sending onion request to node")
        } else {
            self.0
                .send_onion_request_to_random_node(request)
                .await
                .context("Error sending onion request to random node")
                .map(|r| r.0)
        }
    }
}
