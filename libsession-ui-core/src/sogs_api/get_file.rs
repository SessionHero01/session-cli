use crate::http_api::HttpRPC;
use http::{Method, Response};
use non_empty_string::NonEmptyString;
use std::borrow::Cow;

#[derive(Debug)]
pub struct GetFile {
    pub room: NonEmptyString,
    pub file_id: i64,
}

impl HttpRPC for GetFile {
    type Output = Response<Vec<u8>>;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        [
            Cow::Borrowed("room"),
            Cow::Borrowed(self.room.as_str()),
            Cow::Borrowed("file"),
            Cow::Owned(self.file_id.to_string()),
        ]
        .into_iter()
    }

    fn can_batch(&self) -> bool {
        false
    }

    async fn output_from_upstream(output: Response<Vec<u8>>) -> anyhow::Result<Self::Output> {
        Ok(output)
    }
}
