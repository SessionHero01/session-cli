use crate::json_rpc::{JsonRPCRequest, JsonRPCResponse};
use crate::rpc::RPCExecutor;
use anyhow::Context;
use http::Method;
use url::Url;

impl RPCExecutor<JsonRPCRequest, JsonRPCResponse> for reqwest::Client {
    type Args = (Method, Url);

    async fn execute(
        &self,
        (method, url): Self::Args,
        input: JsonRPCRequest,
    ) -> anyhow::Result<JsonRPCResponse> {
        let resp = self
            .request(method, url)
            .json(&input)
            .send()
            .await
            .context("Error sending reqwest request")?;

        resp.json()
            .await
            .context("Error parsing JSON from reqwest response")
    }
}
