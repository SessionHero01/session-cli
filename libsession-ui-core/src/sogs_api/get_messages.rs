use std::borrow::Cow;

use crate::http_api::json::HttpJsonRPC;
use crate::sogs_api::message::{MessageId, MessageSeqNo};
use http::Method;
use non_empty_string::NonEmptyString;

pub struct GetRecentMessages {
    pub room: NonEmptyString,
    pub limit: Option<usize>,
}

pub struct GetMessagesBefore {
    pub room: NonEmptyString,
    pub before_msg_id: MessageId,
    pub limit: Option<usize>,
}

pub struct GetMessagesSince {
    pub room: NonEmptyString,
    pub since_msg_seq_no: MessageSeqNo,
    pub limit: Option<usize>,
}

fn build_get_message_path_segments<'a>(
    room: &'a str,
    operation: &'a str,
) -> impl Iterator<Item = Cow<'a, str>> {
    ["room", room, "messages", operation]
        .into_iter()
        .map(Cow::Borrowed)
}

fn build_limit_query<'a>(
    limit: Option<usize>,
) -> impl Iterator<Item = (Cow<'a, str>, Cow<'a, str>)> {
    limit
        .into_iter()
        .flat_map(|limit| [(Cow::Borrowed("limit"), Cow::Owned(limit.to_string()))].into_iter())
}

impl HttpJsonRPC for GetRecentMessages {
    type Output = Vec<super::message::MessageOrDelete>;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        build_get_message_path_segments(self.room.as_str(), "recent")
    }

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        build_limit_query(self.limit)
    }
}

impl HttpJsonRPC for GetMessagesBefore {
    type Output = Vec<super::message::MessageOrDelete>;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        build_get_message_path_segments(self.room.as_str(), "before")
            .chain(std::iter::once(Cow::Owned(self.before_msg_id.to_string())))
    }
    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        build_limit_query(self.limit)
    }
}

impl HttpJsonRPC for GetMessagesSince {
    type Output = Vec<super::message::MessageOrDelete>;

    fn method(&self) -> Method {
        Method::GET
    }
    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        build_get_message_path_segments(self.room.as_str(), "since").chain(std::iter::once(
            Cow::Owned(self.since_msg_seq_no.to_string()),
        ))
    }

    fn queries(&self) -> impl Iterator<Item = (Cow<str>, Cow<str>)> {
        build_limit_query(self.limit)
    }
}
