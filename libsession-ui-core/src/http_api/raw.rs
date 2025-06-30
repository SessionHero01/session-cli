use crate::utils::http::base_url::HttpBaseUrl;
use http::{Method, Response};
use std::borrow::Cow;
use std::iter::empty;
use url::Url;

pub struct RawRPC(pub Method, pub Url, pub Option<Vec<u8>>);

impl super::HttpRPC for RawRPC {
    type Output = Response<Vec<u8>>;

    fn method(&self) -> Method {
        self.0.clone()
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        empty()
    }

    fn request_body(self) -> anyhow::Result<Vec<u8>> {
        Ok(self.2.unwrap_or_default())
    }

    fn can_batch(&self) -> bool {
        true
    }

    fn full_url(&self, base: &HttpBaseUrl) -> Url {
        base.join(self.1.as_str()).unwrap()
    }

    async fn output_from_upstream(output: Response<Vec<u8>>) -> anyhow::Result<Self::Output> {
        Ok(output)
    }
}
