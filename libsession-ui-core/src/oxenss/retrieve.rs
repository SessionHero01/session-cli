use super::namespace::MessageNamespace;
use super::rpc::{StorageRPC, StorageRPCRequest};
use crate::clock::Timestamp;
use crate::key::ed25519::ED25519PubKey;
use crate::network::swarm_auth::SwarmAuth;
use crate::utils::base64::Base64;
use anyhow::Context;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::borrow::Cow;

#[derive(Debug, Serialize)]
pub struct RetrieveMessageRequest {
    #[serde(rename = "pubkey")]
    session_id: String,
    last_hash: String,
    pubkey_ed25519: Option<ED25519PubKey>,
    #[serde(skip_serializing_if = "Option::is_none")]
    max_size: Option<usize>,
    #[serde(flatten)]
    signature: Value,
    timestamp: Timestamp,
    namespace: isize,
}

impl StorageRPC for RetrieveMessageRequest {
    type Output = RetrieveMessageResponse;
}

impl TryFrom<RetrieveMessageRequest> for StorageRPCRequest {
    type Error = anyhow::Error;
    fn try_from(value: RetrieveMessageRequest) -> Result<Self, Self::Error> {
        let ns = value.namespace;
        Ok(StorageRPCRequest {
            method: Cow::Borrowed("retrieve"),
            params: serde_json::to_value(value).context("Serializing retrieve request")?,
            namespace: if ns == MessageNamespace::UserMessages as isize {
                None
            } else {
                Some(ns)
            },
        })
    }
}

impl RetrieveMessageRequest {
    pub fn new<Auth>(
        namespace: MessageNamespace,
        auth: &Auth,
        last_hash: Option<&str>,
        max_size: Option<usize>,
        timestamp: Timestamp,
    ) -> anyhow::Result<Self>
    where
        Auth: SwarmAuth,
        Auth::IDType: AsRef<str>,
    {
        let sig_payload = if namespace == MessageNamespace::UserMessages {
            format!("retrieve{timestamp}")
        } else {
            format!("retrieve{}{timestamp}", namespace as isize)
        };

        let signature = serde_json::to_value(
            auth.sign(sig_payload.as_bytes())
                .context("Signing is required")?,
        )?;

        let session_id = auth.session_id().as_ref().to_string();

        Ok(Self {
            session_id,
            last_hash: last_hash.map(str::to_owned).unwrap_or_default(),
            pubkey_ed25519: auth.ed25519_pub_key().map(|c| c.into_owned()),
            max_size,
            signature,
            timestamp,
            namespace: namespace as isize,
        })
    }
}

#[derive(Debug, Deserialize)]
pub struct RetrieveMessageResponse {
    pub messages: Vec<Message>,
    pub more: bool,
    #[serde(rename = "t")]
    pub timestamp: Timestamp,
}

impl RetrieveMessageResponse {
    pub fn latest_hash(&self) -> Option<&str> {
        self.messages
            .iter()
            .max_by_key(|item| item.sent)
            .map(|s| s.hash.as_str())
    }
}

#[derive(Debug, Deserialize)]
pub struct Message {
    pub data: Base64<Vec<u8>>,
    pub hash: String,
    pub expiration: Timestamp,
    #[serde(rename = "timestamp")]
    pub sent: Timestamp,
}
