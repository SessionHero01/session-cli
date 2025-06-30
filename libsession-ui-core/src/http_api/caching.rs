use std::sync::Arc;

use crate::db::Repository;
use crate::db::http_cache::HttpCacheRepository;
use crate::http_api::executor::{HttpRPCRequest, HttpRPCResponse};
use crate::rpc::RPCExecutor;
use anyhow::Context;

pub struct CachingHttpExecutor<E> {
    repo: Arc<Repository>,
    underlying: E,
}

impl<E> CachingHttpExecutor<E> {
    pub fn new(repo: Arc<Repository>, underlying: E) -> Self {
        Self { repo, underlying }
    }
}

impl<E> RPCExecutor<HttpRPCRequest, HttpRPCResponse> for CachingHttpExecutor<E>
where
    E: RPCExecutor<HttpRPCRequest, HttpRPCResponse> + Sync,
    E::Args: Send,
{
    type Args = E::Args;

    async fn execute(
        &self,
        args: Self::Args,
        input: HttpRPCRequest,
    ) -> anyhow::Result<HttpRPCResponse> {
        let Some(url) = input.full_url() else {
            // Early return as we don't even have a URL to deal with
            return self.underlying.execute(args, input).await;
        };

        if let Some(cache) = self.repo.with_connection(|c| c.get_cache(url.as_str()))? {
            return Ok(HttpRPCResponse(cache));
        }

        let resp = self.underlying.execute(args, input).await?;

        if resp.0.status().is_success() || !resp.0.status().is_server_error() {
            self.repo
                .with_connection(|c| c.save_cache(url.as_str(), &resp.0))
                .context("Failed to save cache")?;
        }

        Ok(resp)
    }
}
