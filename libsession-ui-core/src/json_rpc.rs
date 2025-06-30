use crate::batcher::Batchable;
use crate::rpc::{RPCExecutor, RPC};
use anyhow::{format_err, Context};
use json_rpc_types::{Request, Response};
use serde::Deserialize;
use serde_json::Value;
use std::any::type_name;

pub type JsonRPCRequest = Request<Value, String>;
pub type JsonRPCResponse = Response<Value, Value>;

pub trait JsonRPC: TryInto<JsonRPCRequest, Error = anyhow::Error> {
    type Output: for<'de> Deserialize<'de>;
}

impl<R> RPC<JsonRPCRequest, JsonRPCResponse> for R
where
    R: JsonRPC,
{
    type Output = <Self as JsonRPC>::Output;

    fn into_upstream_input(self) -> anyhow::Result<JsonRPCRequest> {
        self.try_into()
    }

    async fn output_from_upstream(resp: JsonRPCResponse) -> anyhow::Result<Self::Output> {
        resp.payload
            .map_err(|e| {
                format_err!(
                    "Error in JsonRPC response: code = {}, msg = {}",
                    e.code.message(),
                    e.message.as_str()
                )
            })
            .and_then(|v| {
                serde_json::from_value(v).with_context(|| {
                    format!(
                        "Failed to parse JSONRPC response to {}",
                        type_name::<Self::Output>()
                    )
                })
            })
    }
}

impl Batchable for JsonRPCRequest {
    fn should_batch_with(&self, _other: &Self) -> bool {
        true
    }
}

pub trait JsonRPCExecutor: RPCExecutor<JsonRPCRequest, JsonRPCResponse> {}

impl<E> JsonRPCExecutor for E where E: RPCExecutor<JsonRPCRequest, JsonRPCResponse> {}
