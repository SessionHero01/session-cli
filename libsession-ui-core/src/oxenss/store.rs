use super::namespace::MessageNamespace;
use super::rpc::{StorageRPC, StorageRPCRequest};
use crate::clock::Timestamp;
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::network::swarm_auth::SwarmAuth;
use anyhow::Context;
use base64::Engine;
use base64::prelude::BASE64_STANDARD;
use serde::Serialize;
use serde_json::Value;
use std::borrow::Cow;
use std::time::Duration;

#[derive(Debug, Serialize)]
pub struct StoreMessageRequest {
    #[serde(rename = "pubKey")]
    dst_pub_key: String,
    #[serde(rename = "data")]
    data_b64: String,
    #[serde(rename = "ttl")]
    ttl_mills: usize,

    #[serde(rename = "timestamp")]
    timestamp_mills: u64,

    namespace: Option<isize>,

    #[serde(skip_serializing_if = "Option::is_none", rename = "pubkey_ed25519")]
    dst_pub_key_ed25519: Option<String>,

    #[serde(flatten)]
    signature: Value,
}

impl TryInto<StorageRPCRequest> for StoreMessageRequest {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<StorageRPCRequest, Self::Error> {
        Ok(StorageRPCRequest {
            method: Cow::Borrowed("store"),
            params: serde_json::to_value(&self)?,
            namespace: self.namespace,
        })
    }
}

impl StorageRPC for StoreMessageRequest {
    type Output = super::retrieve::Message;
}

impl StoreMessageRequest {
    pub fn new(
        ns: MessageNamespace,
        payload: &[u8],
        now: Timestamp,
        auth: &impl SwarmAuth,
        dst_pub_key: &Curve25519PubKey,
        dst_ed25519_pub_key: Option<&ED25519PubKey>,
        ttl: Duration,
    ) -> anyhow::Result<Self> {
        let (ns, to_sign) = if ns == MessageNamespace::UserMessages {
            (None, format!("store{now}"))
        } else {
            (Some(ns as isize), format!("store{}{now}", ns as isize))
        };

        let signature = serde_json::to_value(
            auth.sign(to_sign.as_bytes())
                .context("Error signing payload")?,
        )
        .context("Error serializing signature")?;

        let dst_pub_key = dst_pub_key.to_string();
        let dst_pub_key_ed25519 = dst_ed25519_pub_key.map(|k| k.to_string());
        let data_b64 = BASE64_STANDARD.encode(payload);

        Ok(Self {
            dst_pub_key,
            data_b64,
            ttl_mills: ttl.as_millis().try_into().context("TTL too large")?,
            timestamp_mills: now.as_millis(),
            namespace: ns,
            dst_pub_key_ed25519,
            signature,
        })
    }
}
