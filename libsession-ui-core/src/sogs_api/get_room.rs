use crate::http_api::json::HttpJsonRPC;
use http::Method;
use non_empty_string::NonEmptyString;
use std::borrow::Cow;

pub struct GetRoom(pub NonEmptyString);

impl HttpJsonRPC for GetRoom {
    type Output = super::room::RoomInfo;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        [Cow::Borrowed("room"), Cow::Borrowed(self.0.as_str())].into_iter()
    }
}
