use crate::json_rpc::{JsonRPC, JsonRPCRequest};
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::network::NodeAddress;
use crate::utils::ip::PublicIPv4;
use anyhow::Context;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::net::SocketAddrV4;
use url::Url;

#[derive(Serialize, Debug)]
pub struct RetrieveServiceNodeRequest {
    active_only: bool,
    limit: usize,
    fields: HashMap<&'static str, bool>,
}

#[derive(Deserialize, Eq, PartialEq, Clone, Debug)]
pub struct ServiceNode {
    pub public_ip: PublicIPv4,
    pub storage_port: u16,
    pub pubkey_x25519: Curve25519PubKey,
    pub pubkey_ed25519: ED25519PubKey,
}

impl ServiceNode {
    pub fn onion_req_url(&self) -> Url {
        Url::parse(&format!(
            "https://{}:{}/onion_req/v2",
            self.public_ip, self.storage_port
        ))
        .unwrap()
    }

    pub fn address(&self) -> NodeAddress {
        NodeAddress {
            addr: SocketAddrV4::new(*self.public_ip.as_ref(), self.storage_port),
            pub_key: self.pubkey_ed25519.clone(),
            x25519_pub_key: Some(self.pubkey_x25519.clone()),
        }
    }
}

#[derive(Deserialize)]
pub struct RetrieveServiceNodeResponse {
    pub service_node_states: Vec<ServiceNode>,
}

impl JsonRPC for RetrieveServiceNodeRequest {
    type Output = RetrieveServiceNodeResponse;
}

impl RetrieveServiceNodeRequest {
    pub fn new(limit: usize) -> Self {
        Self {
            active_only: true,
            limit,
            fields: [
                "public_ip",
                "storage_port",
                "pubkey_x25519",
                "pubkey_ed25519",
            ]
            .into_iter()
            .map(|name| (name, true))
            .collect(),
        }
    }
}

impl TryFrom<RetrieveServiceNodeRequest> for JsonRPCRequest {
    type Error = anyhow::Error;

    fn try_from(value: RetrieveServiceNodeRequest) -> Result<Self, Self::Error> {
        Ok(Self {
            jsonrpc: Default::default(),
            method: "get_service_nodes".into(),
            params: Some(
                serde_json::to_value(value).context("Serializing retrieve service node request")?,
            ),
            id: None,
        })
    }
}
