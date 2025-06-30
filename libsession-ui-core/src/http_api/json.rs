use crate::http_api::HttpRPC;
use crate::utils::http::response::ResponseExt;
use anyhow::Context;
use http::{Method, Response};
use serde::{Deserialize, Serialize};
use std::borrow::Cow;

pub trait HttpJsonRPC {
    type Output: for<'de> Deserialize<'de>;

    fn method(&self) -> Method;
    fn path_segments(&self) -> impl Iterator<Item = Cow<str>>;

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        std::iter::empty()
    }
    fn headers(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        [(
            Cow::Borrowed("Content-Type"),
            Cow::Borrowed("application/json"),
        )]
        .into_iter()
    }

    fn body(&self) -> Option<impl Serialize> {
        Option::<()>::None
    }
}

impl<R> HttpRPC for R
where
    R: HttpJsonRPC,
{
    type Output = R::Output;

    fn method(&self) -> Method {
        <R as HttpJsonRPC>::method(self)
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        <R as HttpJsonRPC>::path_segments(self)
    }

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        <R as HttpJsonRPC>::queries(self)
    }

    fn headers(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        <R as HttpJsonRPC>::headers(self)
    }

    fn request_body(self) -> anyhow::Result<Vec<u8>> {
        let Some(body) = self.body() else {
            return Ok(Default::default());
        };

        let body = serde_json::to_value(body).context("Error serializing request body to JSON")?;
        Ok(body.to_string().into_bytes())
    }

    fn can_batch(&self) -> bool {
        true
    }

    async fn output_from_upstream(output: Response<Vec<u8>>) -> anyhow::Result<Self::Output> {
        output.success_json().await
    }
}
