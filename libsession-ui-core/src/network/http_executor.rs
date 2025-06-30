use super::Network;
use crate::http_api::executor::{HttpRPCRequest, HttpRPCResponse};
use crate::key::curve25519::Curve25519PubKey;
use crate::rpc::RPCExecutor;
use tracing::instrument;

#[derive(Clone)]
pub struct NetworkHttpApiExecutor<N>(N);

impl<N> NetworkHttpApiExecutor<N> {
    pub fn new(network: N) -> Self {
        Self(network)
    }
}

impl<N> RPCExecutor<HttpRPCRequest, HttpRPCResponse> for NetworkHttpApiExecutor<N>
where
    N: Network + Sync,
{
    type Args = Curve25519PubKey;

    #[instrument(skip(self), ret, level = "debug")]
    async fn execute(
        &self,
        args: Self::Args,
        request: HttpRPCRequest,
    ) -> anyhow::Result<HttpRPCResponse> {
        let resp = self
            .0
            .send_onion_proxy_request(&request.base_url, request.request, &args)
            .await?;

        Ok(HttpRPCResponse(resp))
    }
}
