use super::capabilities::{GetCapabilitiesRequest, ServerCapabilities};
use crate::http_api::executor::HttpRPCExecutor;
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::sync::async_retrieve::SharedAsyncRetrieveState;
use parking_lot::Mutex;
use std::collections::HashMap;
use std::ops::Deref;
use std::sync::Arc;
use std::time::Duration;

#[derive(Default)]
pub struct CapabilitiesRepository {
    cap_states: Mutex<HashMap<HttpBaseUrl, Arc<SharedAsyncRetrieveState<ServerCapabilities>>>>,
}

impl CapabilitiesRepository {
    pub async fn get_capabilities<E>(
        &self,
        executor: E,
        executor_args: E::Args,
        server_url: HttpBaseUrl,
    ) -> anyhow::Result<impl Deref<Target = ServerCapabilities> + '_>
    where
        E: HttpRPCExecutor + Sync,
        E::Args: Send,
    {
        let state = self
            .cap_states
            .lock()
            .entry(server_url.clone())
            .or_insert_with(|| {
                Arc::new(SharedAsyncRetrieveState::new(
                    Duration::from_secs(60),
                    Duration::from_secs(5),
                ))
            })
            .clone();

        state
            .get_or_retrieve(|| {
                executor.execute_rpc(executor_args, (server_url, GetCapabilitiesRequest))
            })
            .await
    }
}
