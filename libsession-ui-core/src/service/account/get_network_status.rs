use crate::network::{Network, NetworkState};
use crate::protos::{
    get_network_status_response, GetNetworkStatusRequest, GetNetworkStatusResponse, NetworkPath,
};
use crate::utils::sync::watcher::WatcherReceiver;
use futures_core::Stream;
use futures_util::StreamExt;
use std::sync::Arc;

pub struct GetNetworkStateService<N>(pub Arc<N>);

impl<N> Clone for GetNetworkStateService<N> {
    fn clone(&self) -> Self {
        Self(self.0.clone())
    }
}

impl From<&NetworkState> for get_network_status_response::State {
    fn from(value: &NetworkState) -> Self {
        match value {
            NetworkState::Idle => Self::Idle(Default::default()),
            NetworkState::Connecting => Self::Connecting(Default::default()),
            NetworkState::Connected(path) => Self::Connected(NetworkPath {
                ipv4_addresses: path.iter().map(|ip| ip.to_string()).collect(),
            }),
            NetworkState::Error(e) => Self::Error(e.to_string()),
        }
    }
}

impl<N: Network + Send + Sync + 'static> super::super::StreamingService
    for GetNetworkStateService<N>
{
    type Request = GetNetworkStatusRequest;
    type Item = anyhow::Result<GetNetworkStatusResponse>;

    async fn call(
        &self,
        _req: Self::Request,
    ) -> anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static> {
        Ok(self.0.watch_state().into_stream().map(|state| {
            Ok(GetNetworkStatusResponse {
                state: Some(state.as_ref().into()),
            })
        }))
    }
}
