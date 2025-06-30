use crate::clock::Timestamp;
use crate::crypto::{pad_message, strip_message_padding};
use crate::key::curve25519::Curve25519PubKey;
use crate::network::swarm_auth::SwarmAuth;
use crate::protos::session::{Content, Envelope, WebSocketMessage, WebSocketRequestMessage};
use crate::session_id::SessionID;
use anyhow::{Context, bail};
use prost::Message;
use std::borrow::Cow;

#[derive(Clone, Debug)]
pub struct RegularMessage {
    pub sender: SessionID,
    pub timestamp: Timestamp,
    pub content: Content,
}

pub trait RegularMessageDecoder: Sized {
    fn decode_and_decrypt(
        input: &[u8],
        swarm_auth: &impl SwarmAuth,
    ) -> anyhow::Result<RegularMessage>;
}

pub trait RegularMessageEncoder: Sized {
    fn encrypt_and_encode(
        sender: &SessionID,
        timestamp: Timestamp,
        content: &Content,
        auth: &impl SwarmAuth,
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<Vec<u8>>;
}

pub struct GroupMessageCodec;

impl RegularMessageDecoder for GroupMessageCodec {
    fn decode_and_decrypt(
        input: &[u8],
        swarm_auth: &impl SwarmAuth,
    ) -> anyhow::Result<RegularMessage> {
        let (session_id, content) = swarm_auth.decrypt(input)?;

        let Envelope {
            content: Some(content),
            timestamp,
            ..
        } = Envelope::decode(content.as_ref()).context("Decode envelope")?
        else {
            bail!("No content in envelope");
        };

        let content = Content::decode(content.as_slice()).context("Decode content")?;
        Ok(RegularMessage {
            sender: session_id,
            timestamp: Timestamp::from_mills(timestamp).context("Timestamp is zero")?,
            content,
        })
    }
}

impl RegularMessageEncoder for GroupMessageCodec {
    fn encrypt_and_encode(
        sender: &SessionID,
        timestamp: Timestamp,
        content: &Content,
        auth: &impl SwarmAuth,
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<Vec<u8>> {
        todo!()
    }
}

pub struct DefaultMessageCodec;

impl RegularMessageEncoder for DefaultMessageCodec {
    fn encrypt_and_encode(
        sender: &SessionID,
        timestamp: Timestamp,
        content: &Content,
        auth: &impl SwarmAuth,
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<Vec<u8>> {
        let content = content.encode_to_vec();
        let content = pad_message(Cow::Owned(content));

        let envelop = Envelope {
            content: Some(content),
            timestamp: timestamp.as_millis(),
            ..Default::default()
        };

        let msg = WebSocketMessage {
            request: Some(WebSocketRequestMessage {
                body: Some(envelop.encode_to_vec()),
                ..Default::default()
            }),
            ..Default::default()
        };

        let msg = msg.encode_to_vec();
        let msg = auth.encrypt(&msg, for_other)?;
        Ok(msg.as_ref().to_vec())
    }
}

impl RegularMessageDecoder for DefaultMessageCodec {
    fn decode_and_decrypt(
        input: &[u8],
        swarm_auth: &impl SwarmAuth,
    ) -> anyhow::Result<RegularMessage> {
        let WebSocketMessage {
            request:
                Some(WebSocketRequestMessage {
                    body: Some(body), ..
                }),
            ..
        } = WebSocketMessage::decode(input).context("Decode websocket")?
        else {
            bail!("No body in websocket message");
        };

        let Envelope {
            content: Some(content),
            timestamp,
            ..
        } = Envelope::decode(body.as_slice()).context("Decode envelope")?
        else {
            bail!("No content in envelope");
        };

        let (session_id, content) = swarm_auth.decrypt(&content)?;
        let content =
            Content::decode(strip_message_padding(content.as_ref())).context("Decode content")?;

        Ok(RegularMessage {
            sender: session_id,
            timestamp: Timestamp::from_mills(timestamp).context("Timestamp is zero")?,
            content,
        })
    }
}
