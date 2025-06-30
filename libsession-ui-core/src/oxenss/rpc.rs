use crate::batcher::Batchable;
use crate::rpc::{RPC, RPCExecutor};
use crate::utils::json::Json;
use anyhow::Context;
use derive_more::Debug;
use http::StatusCode;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::any::type_name;
use std::borrow::Cow;

#[derive(Serialize, Debug)]
pub struct StorageRPCRequest {
    pub method: Cow<'static, str>,
    #[debug("{}", params.to_string())]
    pub params: Value,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub namespace: Option<isize>,
}

#[derive(Deserialize, Debug)]
pub struct StorageRPCResponse {
    #[serde(with = "crate::utils::http::serde::status_code")]
    pub status: StatusCode,
    pub body: Json<Value>,
}

pub trait StorageRPC:
    TryInto<StorageRPCRequest, Error = anyhow::Error> + Send + Sync + 'static
{
    type Output: for<'de> Deserialize<'de> + Send + Sync + 'static;
}

impl<R> RPC<StorageRPCRequest, StorageRPCResponse> for R
where
    R: StorageRPC,
{
    type Output = <Self as StorageRPC>::Output;

    fn into_upstream_input(self) -> anyhow::Result<StorageRPCRequest> {
        self.try_into()
    }

    async fn output_from_upstream(
        StorageRPCResponse {
            status,
            body: Json(body),
        }: StorageRPCResponse,
    ) -> anyhow::Result<Self::Output> {
        anyhow::ensure!(
            status.is_success(),
            "Storage RPC request failed with status code: {status}",
        );

        serde_json::from_value(body).with_context(|| {
            format!(
                "Failed to parse Storage RPC response to {}",
                type_name::<Self::Output>()
            )
        })
    }
}

impl Batchable for StorageRPCRequest {
    fn should_batch_with(&self, _other: &Self) -> bool {
        true
    }
}

pub trait StorageRPCExecutor: RPCExecutor<StorageRPCRequest, StorageRPCResponse> {}

impl<E> StorageRPCExecutor for E where E: RPCExecutor<StorageRPCRequest, StorageRPCResponse> {}
