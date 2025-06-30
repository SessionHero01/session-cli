use super::{Network, NetworkState, NodeAddress};
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::oxenss::rpc::{StorageRPCRequest, StorageRPCResponse};
use crate::utils::ffi::cwrapper::CWrapper;
use crate::utils::ffi::string_ext::{CArrayExt, StringExt};
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::http::body::{full_box_body, BoxBody};
use crate::utils::ip::PublicIPv4;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::json::Json;
use crate::utils::sync::watcher::{combine_watcher_receivers, Watcher, WatcherReceiver};
use anyhow::{ensure, format_err, Context};
use axum::response::Response;
use http::{HeaderMap, HeaderName, HeaderValue, Request, StatusCode};
use http_body_util::BodyExt;
use libsession_util_sys as bindings;
use rand::prelude::SliceRandom;
use std::ffi::{CStr, CString};
use std::net::{Ipv4Addr, SocketAddrV4};
use std::os::raw::c_char;
use std::path::Path;
use std::pin::Pin;
use std::ptr::{null, null_mut};
use std::sync::Arc;
use tokio::sync::oneshot;

type StatusWatcherType = Watcher<bindings::CONNECTION_STATUS>;
type PathsWatcherType = Watcher<Vec<Vec<NodeAddress>>>;

pub struct QuicNetwork {
    inner: CWrapper<bindings::network_object>,
    status_watcher: Pin<Box<StatusWatcherType>>,
    paths_watcher: Pin<Box<PathsWatcherType>>,
}

type OnionResponseSender = oneshot::Sender<anyhow::Result<(StatusCode, Vec<u8>, HeaderMap)>>;
type ServiceNodesSender = oneshot::Sender<Vec<bindings::network_service_node>>;

impl QuicNetwork {
    pub fn new(
        cache_path: impl AsRef<Path>,
        use_testnet: bool,
        single_path_mode: bool,
        pre_build_paths: bool,
    ) -> anyhow::Result<Self> {
        let mut ptr = null_mut();
        let mut error = [0u8; 256];
        let cache_path = cache_path.as_ref().to_str().context("Invalid cache path")?;
        let r = unsafe {
            bindings::network_init(
                &mut ptr,
                cache_path.to_cstr().as_ref().as_ptr(),
                use_testnet,
                single_path_mode,
                pre_build_paths,
                error.as_mut_ptr() as *mut _,
            )
        };

        ensure!(
            r,
            "Failed to initialize network: {}",
            error.cstr_to_str().unwrap_or_default()
        );

        let inner = CWrapper::new_with_destroyer(ptr, bindings::network_free)
            .context("nullptr when creating network")?;

        let mut status_watcher = Box::pin(StatusWatcherType::new(
            bindings::CONNECTION_STATUS_CONNECTION_STATUS_DISCONNECTED,
        ));
        let mut paths_watcher = Box::pin(PathsWatcherType::new(Default::default()));

        unsafe {
            bindings::network_set_status_changed_callback(
                inner.as_mut_ptr(),
                Some(Self::status_changed_callback),
                status_watcher.as_mut().get_mut() as *mut _ as *mut std::ffi::c_void,
            );

            bindings::network_set_paths_changed_callback(
                inner.as_mut_ptr(),
                Some(Self::paths_change_callback),
                paths_watcher.as_mut().get_mut() as *mut _ as *mut std::ffi::c_void,
            );
        };

        Ok(Self {
            inner,
            status_watcher,
            paths_watcher,
        })
    }

    unsafe extern "C" fn status_changed_callback(
        status: bindings::CONNECTION_STATUS,
        ctx: *mut std::ffi::c_void,
    ) {
        let watcher: &mut StatusWatcherType = std::mem::transmute(ctx);
        watcher.send_if_modified(|s| {
            let changed = *s != status;
            *s = status;
            changed
        });
    }

    unsafe extern "C" fn paths_change_callback(
        paths: *mut bindings::onion_request_path,
        paths_len: usize,
        ctx: *mut std::ffi::c_void,
    ) {
        let watcher: &mut PathsWatcherType = std::mem::transmute(ctx);
        let paths = std::slice::from_raw_parts(paths, paths_len)
            .into_iter()
            .map(|path| {
                std::slice::from_raw_parts(path.nodes, path.nodes_count)
                    .into_iter()
                    .filter_map(|n| {
                        Some(NodeAddress {
                            addr: SocketAddrV4::new(Ipv4Addr::from(n.ip), n.quic_port),
                            pub_key: ED25519PubKey::from_hex_cstring(CStr::from_ptr(
                                n.ed25519_pubkey_hex.as_ptr(),
                            ))
                            .inspect_err(|e| tracing::error!("Invalid ED25519 pub key: {e:?}"))
                            .ok()?,
                            x25519_pub_key: None,
                        })
                    })
                    .collect()
            })
            .collect();

        watcher.send_replace(paths);
    }

    unsafe extern "C" fn service_nodes_callback(
        nodes: *mut bindings::network_service_node,
        nodes_len: usize,
        ctx: *mut std::ffi::c_void,
    ) {
        let tx: Box<ServiceNodesSender> = Box::from_raw(ctx as *mut _);

        let nodes = std::slice::from_raw_parts(nodes, nodes_len).to_vec();
        if tx.send(nodes).is_err() {
            tracing::error!("Failed to send back service nodes");
        }
    }

    unsafe extern "C" fn onion_response_callback(
        _success: bool,
        timeout: bool,
        status_code: i16,
        headers: *mut *const c_char,
        header_values: *mut *const c_char,
        headers_len: usize,
        response: *const c_char,
        response_len: usize,
        ctx: *mut std::ffi::c_void,
    ) {
        let tx: Box<OnionResponseSender> = Box::from_raw(ctx as *mut _);
        let response = std::slice::from_raw_parts(response as *const u8, response_len);

        let r = if !timeout {
            let headers = if headers_len > 0 {
                let header_names = std::slice::from_raw_parts(headers, headers_len);
                let header_values = std::slice::from_raw_parts(header_values, headers_len);
                header_names
                    .into_iter()
                    .zip(header_values.into_iter())
                    .filter_map(|(name, value)| {
                        let name = CStr::from_ptr(*name).to_str().ok()?;
                        let value = CStr::from_ptr(*value).to_str().ok()?;
                        let name: HeaderName = name.parse().ok()?;
                        let value: HeaderValue = value.parse().ok()?;
                        Some((name, value))
                    })
                    .collect()
            } else {
                HeaderMap::default()
            };

            let status_code = u16::try_from(status_code)
                .ok()
                .and_then(|s| StatusCode::from_u16(s).ok())
                .unwrap_or(StatusCode::INTERNAL_SERVER_ERROR);

            tx.send(Ok((status_code, response.to_vec(), headers)))
        } else {
            tx.send(Err(format_err!("Timeout")))
        };

        if r.is_err() {
            tracing::error!("Failed to send back onion response");
        }
    }

    async fn get_random_node(&self) -> anyhow::Result<Vec<bindings::network_service_node>> {
        let (tx, rx): (ServiceNodesSender, _) = oneshot::channel();
        unsafe {
            bindings::network_get_random_nodes(
                self.inner.as_mut_ptr(),
                25,
                Some(Self::service_nodes_callback),
                Box::leak(Box::new(tx)) as *mut _ as *mut std::ffi::c_void,
            );
        }

        rx.await.context("Cancelled")
    }
}

impl Into<bindings::network_service_node> for NodeAddress {
    fn into(self) -> bindings::network_service_node {
        let mut node = bindings::network_service_node {
            ip: self.addr.ip().octets(),
            quic_port: self.addr.port(),
            ed25519_pubkey_hex: [0; 65],
        };

        node.ed25519_pubkey_hex.write_cstr(self.pub_key.hex());
        node
    }
}

impl Network for QuicNetwork {
    async fn send_onion_request_to_node(
        &self,
        dest: NodeAddress,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        let payload = serde_json::to_vec(&payload).context("Error serializing onion request")?;

        let (tx, rx): (OnionResponseSender, _) = oneshot::channel();

        unsafe {
            bindings::network_send_onion_request_to_snode_destination(
                self.inner.as_mut_ptr(),
                dest.into(),
                payload.as_ptr(),
                payload.len(),
                null(),
                20000,
                20000,
                Some(Self::onion_response_callback),
                Box::leak(Box::new(tx)) as *mut _ as *mut std::ffi::c_void,
            );
        }

        let (status, data, _headers) = rx.await.context("Cancelled")??;
        let body =
            Json(serde_json::from_slice(&data).context("Error deserializing onion response")?);

        Ok(StorageRPCResponse { status, body })
    }

    async fn send_onion_request_to_random_node(
        &self,
        payload: StorageRPCRequest,
    ) -> anyhow::Result<StorageRPCResponse> {
        let nodes = self.get_random_node().await?;
        let random_node = nodes
            .choose(&mut rand::thread_rng())
            .context("Unable to choose a random node. Not enough nodes to choose from")?;

        let node = NodeAddress {
            addr: SocketAddrV4::new(random_node.ip.into(), random_node.quic_port),
            pub_key: ED25519PubKey::from_hex_cstring(unsafe {
                CStr::from_ptr(random_node.ed25519_pubkey_hex.as_ptr())
            })
            .context("Invalid ED25519 public key")?,
            x25519_pub_key: None,
        };

        self.send_onion_request_to_node(node, payload).await
    }

    async fn send_onion_proxy_request(
        &self,
        target_url: &HttpBaseUrl,
        request: Request<BoxBody>,
        target_host_key: &Curve25519PubKey,
    ) -> anyhow::Result<Response<BoxBody>> {
        let (parts, body) = request.into_parts();
        let endpoint = parts
            .uri
            .path_and_query()
            .map_or("/", |p| p.as_str())
            .to_cstr();

        let body = body
            .collect()
            .await
            .map_err(|e| format_err!("Failed to collect body: {e:?}"))?
            .to_bytes();

        let mut headers = Vec::<CString>::with_capacity(parts.headers.len());
        let mut header_values = Vec::<CString>::with_capacity(parts.headers.len());

        for (k, v) in parts.headers.iter() {
            let Ok(k) = CString::new(k.as_str()) else {
                continue;
            };

            let Ok(v) = CString::new(v.as_bytes()) else {
                continue;
            };
            headers.push(k);
            header_values.push(v);
        }

        let (tx, rx): (OnionResponseSender, _) = oneshot::channel();

        unsafe {
            let method = parts.method.as_str().to_cstr();
            let protocol = target_url.scheme().to_cstr();
            let host = target_url.host_str().unwrap_or_default().to_cstr();
            let mut headers = headers.iter().map(|s| s.as_ptr()).collect::<Vec<_>>();
            let mut header_values = header_values.iter().map(|s| s.as_ptr()).collect::<Vec<_>>();

            bindings::network_send_onion_request_to_server_destination(
                self.inner.as_mut_ptr(),
                bindings::network_server_destination {
                    method: method.as_ref().as_ptr(),
                    protocol: protocol.as_ref().as_ptr(),
                    host: host.as_ref().as_ptr(),
                    endpoint: endpoint.as_ref().as_ptr(),
                    port: target_url.port_or_known_default().unwrap_or_default(),
                    x25519_pubkey: target_host_key.hex_cstr().as_ref().as_ptr(),
                    headers: headers.as_mut_ptr(),
                    header_values: header_values.as_mut_ptr(),
                    headers_size: headers.len(),
                },
                body.as_ptr(),
                body.len(),
                20000,
                20000,
                Some(Self::onion_response_callback),
                Box::leak(Box::new(tx)) as *mut _ as *mut std::ffi::c_void,
            );
        };

        let (status, data, headers) = rx.await.context("Cancelled")??;

        tracing::info!("Received {} bytes from onion proxy", data.len());

        let mut resp = Response::new(full_box_body(data.into()));

        *resp.status_mut() = status;
        *resp.headers_mut() = headers;
        Ok(resp)
    }

    fn watch_state(&self) -> impl WatcherReceiver<Arc<NetworkState>> + Send + Sync + 'static {
        combine_watcher_receivers(
            self.status_watcher.subscribe(),
            self.paths_watcher.subscribe(),
            move |status, paths| {
                tracing::info!("Status = {:?}, Paths = {:?}", *status, *paths);
                Arc::new(match *status {
                    bindings::CONNECTION_STATUS_CONNECTION_STATUS_CONNECTING => {
                        NetworkState::Connecting
                    }
                    bindings::CONNECTION_STATUS_CONNECTION_STATUS_CONNECTED => {
                        let first_path = paths
                            .iter()
                            .next()
                            .into_iter()
                            .flat_map(|s| s.iter())
                            .filter_map(|s| PublicIPv4::new(*s.addr.ip()))
                            .collect::<Vec<_>>();

                        if first_path.is_empty() {
                            NetworkState::Connecting
                        } else {
                            NetworkState::Connected(NonEmpty::try_from(first_path).unwrap())
                        }
                    }

                    v => {
                        NetworkState::Error(Arc::new(format_err!("Unknown connection status: {v}")))
                    }
                })
            },
        )
    }
}
