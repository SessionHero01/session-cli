use crate::http_api::json::HttpJsonRPC;
use http::Method;
use non_empty_string::NonEmptyString;
use serde::Deserialize;
use std::borrow::Cow;
use std::iter::empty;

pub struct PollRoomInfo {
    pub room_id: NonEmptyString,
    pub last_info_updates: i64,
}

#[derive(Deserialize, Debug)]
pub struct PollRoomUpdateResponse {
    pub details: Option<super::room::RoomInfo>,
}

impl HttpJsonRPC for PollRoomInfo {
    type Output = PollRoomUpdateResponse;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        [
            Cow::Borrowed("room"),
            Cow::Borrowed(self.room_id.as_str()),
            Cow::Borrowed("pollInfo"),
            Cow::Owned(self.last_info_updates.to_string()),
        ]
        .into_iter()
    }

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        empty()
    }
}
