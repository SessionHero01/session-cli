use super::{
    Network, NetworkState, NodeAddress,
    onion::{OnionRequestBuilder, decrypt_onion_response},
};
use crate::key::curve25519::Curve25519PubKey;
use crate::oxenss::retrieve_service_node::{RetrieveServiceNodeRequest, ServiceNode};
use crate::oxenss::rpc::{StorageRPCRequest, StorageRPCResponse};
use crate::rpc::RPCExecutor;
use crate::utils::errors::{AnyhowExt, RetryableError};
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::reqwest_proxy::ClientBuilderProxyExt;
use crate::utils::sync::async_retrieve::SharedAsyncRetrieveState;
use crate::utils::sync::watcher::{Watcher, WatcherReceiver};
use anyhow::{Context, format_err};
use axum::response::Response;
use base64::Engine;
use base64::prelude::BASE64_STANDARD;
use futures_util::try_join;
use http::{Method, Request};
use rand::prelude::SliceRandom;
use rand::thread_rng;
use reqwest::{Client, ClientBuilder};
use std::fmt::Debug;
use std::net::SocketAddrV4;
use std::sync::Arc;
use std::time::Duration;
use tracing::instrument;
use url::Url;

const PATH_EXPIRATION: Duration = Duration::from_secs(3600 * 24);

#[derive(Debug)]
struct AvailableNetwork {
    random_nodes: NonEmpty<ServiceNode>,
    path: NonEmpty<ServiceNode>,
}

pub struct LegacyNetwork {
    network_state: Watcher<Arc<NetworkState>>,
    state: SharedAsyncRetrieveState<AvailableNetwork>,
    seed_nodes: NonEmpty<Url>,
    seed_client: Client,
    service_node_client: Client,
}

impl LegacyNetwork {
    pub fn new(client: Client, seed_nodes: NonEmpty<Url>) -> anyhow::Result<Self> {
        Ok(Self {
            network_state: Watcher::new(Arc::new(NetworkState::Idle)),
            state: SharedAsyncRetrieveState::new(PATH_EXPIRATION, Duration::from_secs(5)),
            seed_nodes,
            seed_client: client,
            service_node_client: ClientBuilder::new()
                .danger_accept_invalid_certs(true)
                .apply_system_proxy()
                .build()
                .context("To build client")?,
        })
    }

    #[instrument(skip(self, builder, payload), fields(payload_len = payload.len()))]
    async fn perform_onion_req(
        &self,
        path_entry: &ServiceNode,
        dest_pub_key: &Curve25519PubKey,
        mut builder: OnionRequestBuilder,
        payload: &[u8],
        response_is_base64: bool,
    ) -> anyhow::Result<impl AsRef<[u8]> + Sized + Send + Sync + use<>> {
        let do_request = async move {
            let (payload, final_pub_key, final_sec_key) = builder
                .build(payload.as_ref())
                .map_err(|e| format_err!("Error building onion request payload: {e}"))?;

            let resp = self
                .service_node_client
                .post(path_entry.onion_req_url())
                .body(payload.as_ref().to_vec())
                .send()
                .await
                .context("Error performing onion request")?;

            tracing::debug!("Received response status={}", resp.status());

            if !resp.status().is_success() {
                return Err(RetryableError {
                    retryable: resp.status().is_server_error(),
                    source: format_err!(
                        "HTTP error status = {}, message = {}",
                        resp.status(),
                        resp.text().await.unwrap_or_default()
                    ),
                }
                .into());
            }

            let body = if response_is_base64 {
                BASE64_STANDARD
                    .decode(
                        resp.text()
                            .await
                            .context("Error reading http response as text")?,
                    )
                    .context("Error decoding onion response as base64")?
                    .into()
            } else {
                resp.bytes()
                    .await
                    .context("Error reading http response as binary")?
            };

            tracing::debug!("Received response body len={}", body.len());

            let resp = decrypt_onion_response(&body, dest_pub_key, &final_pub_key, &final_sec_key)
                .context("Unable to decrypt onion response")?;

            Ok(resp)
        };

        let r = tokio::time::timeout(Duration::from_secs(10), do_request)
            .await
            .context("Timeout performing onion request")
            .and_then(|r| r);

        match r {
            Ok(r) => {
                tracing::debug!("Received {} bytes", r.as_ref().len());
                Ok(r)
            }
            Err(e) => {
                tracing::error!("Error receiving onion http response: {e}");
                if e.can_retry() {
                    // Must retry path building next time
                    self.state.force_retry_next().await;
                    Err(e)
                } else {
                    let (e, shared) = e.share();
                    self.state.set_error(shared).await;
                    Err(e)
                }
            }
        }
    }

    #[instrument(skip(self), ret, level = "debug")]
    async fn get_available_network_state(&self) -> anyhow::Result<Arc<AvailableNetwork>> {
        self.state
            .get_or_retrieve(|| async {
                let _ = self.network_state.send(Arc::new(NetworkState::Connecting));

                let seed_node = self.seed_nodes.choose_random(thread_rng());
                tracing::info!("Fetching random nodes from: {seed_node}");

                async move {
                    let random_nodes: NonEmpty<ServiceNode> = self
                        .seed_client
                        .execute_rpc(
                            (
                                Method::POST,
                                seed_node.join("json_rpc").expect("To join json_rpc"),
                            ),
                            RetrieveServiceNodeRequest::new(25),
                        )
                        .await
                        .context("Error fetching service nodes")?
                        .service_node_states
                        .try_into()
                        .map_err(|_| format_err!("Service node list is empty"))?;

                    let path = NonEmpty::from_iter(
                        random_nodes.choose_multiple(&mut thread_rng(), 3).cloned(),
                    )
                    .with_context(|| {
                        format!(
                            "Unable to choose 3 random nodes from service node list with size = {}",
                            random_nodes.len()
                        )
                    })?;

                    tracing::info!("Fetched {} random nodes", random_nodes.len());

                    anyhow::Ok(AvailableNetwork { random_nodes, path })
                }
                .await
            })
            .await
    }
}

impl Network for LegacyNetwork {
    #[instrument(skip(self), ret, level = "debug")]
    async fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        let payload =
            serde_json::to_string_pretty(&payload).context("Error serializing payload")?;

        let avail = self.get_available_network_state().await?;
        let AvailableNetwork { path, .. } = avail.as_ref();
        let dest_pub_key = dest
            .x25519_pub_key
            .unwrap_or_else(|| dest.pub_key.to_curve25519());

        let mut builder = OnionRequestBuilder::from_path(path.iter());
        builder.set_snode_destination(
            *dest.addr.ip(),
            dest.addr.port(),
            &dest.pub_key,
            &dest_pub_key,
        );

        let result = self
            .perform_onion_req(
                path.head(),
                &dest_pub_key,
                builder,
                payload.as_bytes(),
                true,
            )
            .await?;

        serde_json::from_slice(result.as_ref()).with_context(|| {
            format!(
                "Error parsing onion response: {}",
                std::str::from_utf8(result.as_ref()).unwrap_or_default()
            )
        })
    }

    #[instrument(skip(self), ret, level = "debug")]
    async fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<(StorageRPCResponse, NodeAddress)> {
        let avail = self.get_available_network_state().await?;
        let AvailableNetwork { random_nodes, .. } = avail.as_ref();
        let node = random_nodes.choose_random(&mut thread_rng());

        let address = NodeAddress {
            addr: SocketAddrV4::new(*node.public_ip.as_ref(), node.storage_port),
            pub_key: node.pubkey_ed25519.clone(),
            x25519_pub_key: Some(node.pubkey_x25519.clone()),
        };

        Ok((
            self.send_onion_request_to_node(address.clone(), payload)
                .await?,
            address,
        ))
    }

    #[instrument(skip(self), ret, level = "debug")]
    async fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<Vec<u8>>,
        target_host_key: &Curve25519PubKey,
    ) -> anyhow::Result<Response<Vec<u8>>> {
        use super::onion_proxy_req::{decode_onion_proxy_response, generate_onion_proxy_request};

        let method = request.method().clone();

        let (payload, avail) = try_join!(
            generate_onion_proxy_request(request),
            self.get_available_network_state()
        )?;

        let path = &avail.path;

        let mut builder = OnionRequestBuilder::from_path(path.iter());
        builder
            .set_server_destination(&target_url, &method, target_host_key)
            .map_err(|e| format_err!("Error setting server destination: {e}"))?;

        let resp = self
            .perform_onion_req(path.head(), target_host_key, builder, &payload, false)
            .await?;

        decode_onion_proxy_response(resp.as_ref())
    }

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static {
        self.network_state.subscribe()
    }
}

impl OnionRequestBuilder {
    pub fn from_path<'a>(path: impl Iterator<Item = &'a ServiceNode>) -> Self {
        let mut builder = Self::new();
        for node in path {
            builder.add_hop((&node.pubkey_x25519, &node.pubkey_ed25519));
        }
        builder
    }
}
