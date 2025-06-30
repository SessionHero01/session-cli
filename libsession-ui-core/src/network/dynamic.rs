use super::{Network, NetworkState, NodeAddress, legacy::LegacyNetwork};

#[cfg(feature = "quic")]
use crate::network::quic::QuicNetwork;

use crate::app_setting::{AppSetting, impl_sql_from_str_display};
use crate::key::curve25519::Curve25519PubKey;
use crate::oxenss::rpc::{StorageRPCRequest, StorageRPCResponse};
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::sync::watcher::{Watcher, WatcherReceiver};
use derive_more::Display;
use http::{Request, Response};
use reqwest::Client;
use std::fmt::Debug;
use std::future::Future;
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::Arc;
use strum::EnumString;
use tokio::task::JoinSet;
use url::Url;

#[derive(Clone)]
enum NetworkInner {
    Legacy(Arc<LegacyNetwork>),
    #[cfg(feature = "quic")]
    Quic(Arc<QuicNetwork>),
}

impl NetworkInner {
    fn network_type(&self) -> NetworkType {
        match self {
            NetworkInner::Legacy(_) => NetworkType::Legacy,
            #[cfg(feature = "quic")]
            NetworkInner::Quic(_) => NetworkType::Quic,
        }
    }
}

#[derive(Debug, Display, Copy, Clone, PartialEq, Eq, EnumString)]
pub enum NetworkType {
    Legacy,
    #[cfg(feature = "quic")]
    Quic,
}

impl AppSetting for NetworkType {
    const NAME: &'static str = "network_type";
    type IDType<'a> = ();
}

impl_sql_from_str_display!(NetworkType);

pub struct DynamicNetwork {
    inner: Watcher<(NetworkInner, JoinSet<()>)>,
    watcher: Watcher<Arc<NetworkState>>,

    network_init_args: NetworkInitArgs,
}

struct NetworkInitArgs {
    client: Client,
    seed_nodes: NonEmpty<Url>,
    quic_cache_path: PathBuf,
}

impl DynamicNetwork {
    pub fn new(
        client: Client,
        seed_nodes: NonEmpty<Url>,
        quic_cache_path: PathBuf,
        initial_network: NetworkType,
    ) -> anyhow::Result<Self> {
        let watcher = Watcher::new(Arc::new(NetworkState::Idle));
        let network_init_args = NetworkInitArgs {
            client,
            seed_nodes,
            quic_cache_path,
        };

        let (runner, network) =
            Self::create_network(initial_network, &network_init_args, &watcher)?;

        let mut network_runner = JoinSet::new();
        network_runner.spawn(runner);

        Ok(Self {
            inner: Watcher::new((network, network_runner)),
            watcher: Watcher::new(Arc::new(NetworkState::Idle)),
            network_init_args,
        })
    }

    fn create_network(
        network: NetworkType,
        init_args: &NetworkInitArgs,
        state_sender: &Watcher<Arc<NetworkState>>,
    ) -> anyhow::Result<(
        Pin<Box<dyn Future<Output = ()> + Send + Sync>>,
        NetworkInner,
    )> {
        match network {
            #[cfg(feature = "quic")]
            NetworkType::Quic => {
                let network = Arc::new(QuicNetwork::new(
                    &init_args.quic_cache_path,
                    false,
                    false,
                    true,
                )?);

                Ok((
                    Box::pin(network.watch_state().connect_to(state_sender.clone())),
                    NetworkInner::Quic(network),
                ))
            }

            NetworkType::Legacy => {
                let network = Arc::new(LegacyNetwork::new(
                    init_args.client.clone(),
                    init_args.seed_nodes.clone(),
                )?);

                Ok((
                    Box::pin(network.watch_state().connect_to(state_sender.clone())),
                    NetworkInner::Legacy(network),
                ))
            }
        }
    }

    pub fn watch_network_type(&self) -> impl WatcherReceiver<NetworkType> + 'static {
        self.inner.subscribe().map(|inner| inner.0.network_type())
    }
}

impl Network for DynamicNetwork {
    async fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        let network = self.inner.borrow().0.clone();
        Ok(match network {
            NetworkInner::Legacy(legacy) => {
                legacy.send_onion_request_to_node(dest, payload).await?
            }
            #[cfg(feature = "quic")]
            NetworkInner::Quic(quic) => quic.send_onion_request_to_node(dest, payload).await?,
        })
    }

    async fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<(StorageRPCResponse, NodeAddress)> {
        let network = self.inner.borrow().0.clone();
        Ok(match network {
            NetworkInner::Legacy(legacy) => {
                legacy.send_onion_request_to_random_node(payload).await?
            }
            #[cfg(feature = "quic")]
            NetworkInner::Quic(quic) => quic.send_onion_request_to_random_node(payload).await?,
        })
    }

    async fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<Vec<u8>>,
        target_host_key: &Curve25519PubKey,
    ) -> anyhow::Result<Response<Vec<u8>>> {
        let network = self.inner.borrow().0.clone();
        Ok(match network {
            NetworkInner::Legacy(legacy) => {
                legacy
                    .send_onion_proxy_request(target_url, request, target_host_key)
                    .await?
            }
            #[cfg(feature = "quic")]
            NetworkInner::Quic(quic) => {
                quic.send_onion_proxy_request(target_url, request, target_host_key)
                    .await?
            }
        })
    }

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static {
        self.watcher.subscribe()
    }
}
