pub mod caching;
pub mod executor;
pub mod json;
pub mod raw;

use crate::http_api::executor::{HttpRPCRequest, HttpRPCResponse};
use crate::rpc::RPC;
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::urls::UrlExt;
use anyhow::Context;
use http::header::HOST;
use http::{Method, Request, Response};
use std::borrow::Cow;
use std::future::Future;
use url::Url;

pub trait HttpRPC: Sized {
    type Output;

    fn method(&self) -> Method;
    fn path_segments(&self) -> impl Iterator<Item = Cow<str>>;

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        std::iter::empty()
    }
    fn headers(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        std::iter::empty()
    }

    fn request_body(self) -> anyhow::Result<Vec<u8>> {
        Ok(Default::default())
    }

    fn can_batch(&self) -> bool;

    fn full_url(&self, base: &HttpBaseUrl) -> Url {
        let builder = self
            .path_segments()
            .fold(base.build_upon(), |builder, segment| {
                builder.append_path(segment.as_ref())
            });

        self.queries()
            .fold(builder, |builder, (name, value)| {
                builder.append_query(name.as_ref(), value.as_ref())
            })
            .build()
    }

    fn output_from_upstream(
        output: Response<Vec<u8>>,
    ) -> impl Future<Output = anyhow::Result<Self::Output>> + Send;
}

impl<R> RPC<HttpRPCRequest, HttpRPCResponse> for (HttpBaseUrl, R)
where
    R: HttpRPC,
{
    type Output = R::Output;

    fn into_upstream_input(self) -> anyhow::Result<HttpRPCRequest> {
        let (base_url, input) = self;
        let mut req = Request::builder().method(input.method());

        let full_url = input.full_url(&base_url);
        req = req.uri(full_url.path_and_query().as_ref());

        // Host header
        if let Some(host) = full_url.host_str() {
            req = req.header(HOST, host);
        }

        // Extra headers
        for (k, v) in input.headers() {
            req = req.header(k.as_ref(), v.as_ref());
        }

        let can_batch = input.can_batch();

        // Content
        let request = req
            .body(input.request_body()?)
            .context("Failed to build request")?;

        Ok(HttpRPCRequest {
            base_url,
            request,
            can_batch,
        })
    }

    async fn output_from_upstream(output: HttpRPCResponse) -> anyhow::Result<Self::Output> {
        R::output_from_upstream(output.0).await
    }
}
