use super::rpc::{StorageRPC, StorageRPCRequest};
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::network::NodeAddress;
use crate::session_id::IndividualOrGroupID;
use crate::utils::ip::PublicIPv4;
use serde::{Deserialize, Serialize};
use std::borrow::Cow;
use std::net::SocketAddrV4;

#[derive(Debug, Serialize)]
pub struct RetrieveSwarmNodesRequest {
    #[serde(rename = "pubKey")]
    pub session_id: IndividualOrGroupID,
}

#[derive(Deserialize, Debug)]
pub struct SwarmNode {
    pub ip: PublicIPv4,
    #[serde(rename = "port_https")]
    pub port: u16,
    pub port_quic: u16,
    pub pubkey_ed25519: ED25519PubKey,
    pub pubkey_x25519: Curve25519PubKey,
}

impl SwarmNode {
    pub fn address(&self) -> NodeAddress {
        NodeAddress {
            addr: SocketAddrV4::new(*self.ip.as_ref(), self.port),
            pub_key: self.pubkey_ed25519.clone(),
            x25519_pub_key: Some(self.pubkey_x25519.clone()),
        }
    }
}

#[derive(Deserialize, Debug)]
pub struct RetrieveSwarmNodeResponse {
    pub snodes: Vec<SwarmNode>,
}

impl StorageRPC for RetrieveSwarmNodesRequest {
    type Output = RetrieveSwarmNodeResponse;
}

impl TryFrom<RetrieveSwarmNodesRequest> for StorageRPCRequest {
    type Error = anyhow::Error;

    fn try_from(value: RetrieveSwarmNodesRequest) -> Result<Self, Self::Error> {
        Ok(Self {
            method: Cow::Borrowed("get_snodes_for_pubkey"),
            params: serde_json::to_value(value)?,
            namespace: None,
        })
    }
}
