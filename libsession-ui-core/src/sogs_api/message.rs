use crate::clock::UnixTimestampFloat;
use crate::session_id::SessionID;
use crate::utils::base64::Base64;
use serde::{Deserialize, Deserializer, Serialize};
use std::collections::HashMap;

pub type MessageSeqNo = i64;
pub type MessageId = u64;

#[derive(Serialize, Deserialize, Debug)]
pub struct Message<Data> {
    pub id: MessageId,
    #[serde(rename = "session_id")]
    pub sender_id: String,
    pub posted: UnixTimestampFloat,
    pub edited: Option<UnixTimestampFloat>,
    pub seqno: MessageSeqNo,
    #[serde(default)]
    pub whisper: bool,
    #[serde(default)]
    pub whisper_mods: bool,
    pub whisper_to: Option<String>,
    pub data: Data,
    pub signature: Option<String>,
    #[serde(rename = "reactions")]
    pub reaction_by_emoji: HashMap<String, MessageReaction>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Delete {
    pub id: u64,
    pub seqno: i64,
}

#[derive(Debug)]
pub enum MessageOrDelete<Data = Base64<Vec<u8>>> {
    Deleted(Delete),
    Message(Message<Data>),
}

impl<'de, Data> Deserialize<'de> for MessageOrDelete<Data>
where
    Data: for<'a> Deserialize<'a>,
{
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        use serde_json::Value;
        let value = Value::deserialize(deserializer)?;

        match value.get("deleted") {
            Some(Value::Bool(true)) => serde_json::from_value(value)
                .map(MessageOrDelete::Deleted)
                .map_err(serde::de::Error::custom),

            _ => serde_json::from_value(value)
                .map(MessageOrDelete::Message)
                .map_err(serde::de::Error::custom),
        }
    }
}

impl<D1> MessageOrDelete<D1> {
    pub fn seqno(&self) -> i64 {
        match self {
            MessageOrDelete::Deleted(Delete { seqno, .. }) => *seqno,
            MessageOrDelete::Message(Message { seqno, .. }) => *seqno,
        }
    }

    pub fn map_data<D2, E>(
        self,
        f: impl FnOnce(D1) -> Result<D2, E>,
    ) -> Result<MessageOrDelete<D2>, E> {
        match self {
            MessageOrDelete::Deleted(msg) => Ok(MessageOrDelete::Deleted(msg)),
            MessageOrDelete::Message(Message {
                id,
                sender_id,
                posted,
                edited,
                seqno,
                whisper,
                whisper_mods,
                whisper_to,
                data,
                signature,
                reaction_by_emoji,
            }) => f(data).map(|data| {
                MessageOrDelete::Message(Message {
                    id,
                    sender_id,
                    posted,
                    edited,
                    seqno,
                    whisper,
                    whisper_mods,
                    whisper_to,
                    data,
                    signature,
                    reaction_by_emoji,
                })
            }),
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MessageReaction {
    pub index: isize,
    pub count: usize,
    pub reactors: Vec<SessionID>,
    #[serde(default)]
    pub you: bool,
}
