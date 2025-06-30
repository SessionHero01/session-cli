pub mod dynamic;
pub mod embedded;
pub mod http_executor;
mod legacy;
mod onion;
mod onion_proxy_req;
pub mod storage_rpc_executor;

// #[cfg(feature = "quic")]
// mod quic;

pub mod swarm;
pub mod swarm_auth;

use crate::batcher::Batchable;
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::oxenss::rpc::{StorageRPCRequest, StorageRPCResponse};
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::ip::PublicIPv4;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::sync::watcher::WatcherReceiver;
use http::{Request, Response};
use std::fmt::{Debug, Formatter};
use std::future::Future;
use std::net::SocketAddrV4;
use std::sync::Arc;
use tracing::instrument;

#[derive(Clone, PartialEq, Eq)]
pub struct NodeAddress {
    pub addr: SocketAddrV4,
    pub pub_key: ED25519PubKey,
    pub x25519_pub_key: Option<Curve25519PubKey>,
}

impl Debug for NodeAddress {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.write_fmt(format_args!("Node({:?})", self.addr.ip()))
    }
}

#[derive(Debug)]
pub enum NetworkState {
    Idle,
    Connecting,
    Connected(NonEmpty<PublicIPv4>),
    Error(Arc<anyhow::Error>),
}

impl PartialEq for NetworkState {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (NetworkState::Idle, NetworkState::Idle) => true,
            (NetworkState::Connecting, NetworkState::Connecting) => true,
            (NetworkState::Connected(v1), NetworkState::Connected(v2)) => v1 == v2,
            _ => false,
        }
    }
}

impl Eq for NetworkState {}

pub trait Network {
    fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> impl Future<Output = anyhow::Result<StorageRPCResponse>> + Send;

    fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> impl Future<Output = anyhow::Result<(StorageRPCResponse, NodeAddress)>> + Send;

    fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<Vec<u8>>,
        target_host_key: &Curve25519PubKey,
    ) -> impl Future<Output = anyhow::Result<Response<Vec<u8>>>> + Send;

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static;
}

impl<N: Network + Send + Sync> Network for &N {
    async fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        N::send_onion_request_to_node(*self, dest, payload).await
    }

    async fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<(StorageRPCResponse, NodeAddress)> {
        N::send_onion_request_to_random_node(*self, payload).await
    }

    async fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<Vec<u8>>,
        target_host_key: &Curve25519PubKey,
    ) -> anyhow::Result<Response<Vec<u8>>> {
        N::send_onion_proxy_request(*self, target_url, request, target_host_key).await
    }

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static {
        N::watch_state(*self)
    }
}

impl<N: Network + Send + Sync> Network for Arc<N> {
    async fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        N::send_onion_request_to_node(self.as_ref(), dest, payload).await
    }

    async fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<(StorageRPCResponse, NodeAddress)> {
        N::send_onion_request_to_random_node(self.as_ref(), payload).await
    }

    #[instrument(skip(self), ret, level = "debug")]
    async fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<Vec<u8>>,
        target_host_key: &Curve25519PubKey,
    ) -> anyhow::Result<Response<Vec<u8>>> {
        N::send_onion_proxy_request(self.as_ref(), target_url, request, target_host_key).await
    }

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static {
        N::watch_state(self.as_ref())
    }
}

impl Batchable for Option<NodeAddress> {
    fn should_batch_with(&self, other: &Self) -> bool {
        match (self, other) {
            (Some(a), Some(b)) => a.addr == b.addr,
            _ => false,
        }
    }

    fn can_batch(&self) -> bool {
        self.is_some()
    }
}
