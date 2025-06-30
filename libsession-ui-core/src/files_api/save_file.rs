use crate::http_api::HttpRPC;
use crate::utils::http::response::ResponseExt;
use http::{Method, Response};
use serde::Deserialize;
use std::borrow::Cow;
use std::borrow::Cow::Borrowed;

pub struct SaveFile(pub Vec<u8>);

pub type FileID = i64;

#[derive(Deserialize, Copy, Clone)]
pub struct SaveFileResponse {
    pub id: FileID,
}

impl HttpRPC for SaveFile {
    type Output = SaveFileResponse;

    fn method(&self) -> Method {
        Method::POST
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        [Borrowed("file")].into_iter()
    }

    fn headers(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        [
            (Borrowed("Content-Disposition"), Borrowed("attachment")),
            (
                Borrowed("Content-Type"),
                Borrowed("application/octet-stream"),
            ),
        ]
        .into_iter()
    }

    fn request_body(self) -> anyhow::Result<Vec<u8>> {
        Ok(self.0)
    }

    fn can_batch(&self) -> bool {
        false
    }

    async fn output_from_upstream(output: Response<Vec<u8>>) -> anyhow::Result<Self::Output> {
        output.success_json().await
    }
}
