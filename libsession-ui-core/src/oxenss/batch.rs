use super::rpc::{StorageRPC, StorageRPCRequest, StorageRPCResponse};
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::json::Json;
use http::StatusCode;
use serde::Deserialize;
use serde_json::{json, Value};
use std::borrow::Cow;

#[derive(Debug)]
pub struct BatchRequest {
    requests: NonEmpty<StorageRPCRequest>,
}

impl TryFrom<NonEmpty<StorageRPCRequest>> for BatchRequest {
    type Error = anyhow::Error;

    fn try_from(value: NonEmpty<StorageRPCRequest>) -> Result<Self, Self::Error> {
        Ok(Self { requests: value })
    }
}

#[derive(Deserialize, Debug)]
struct BatchResponseItem {
    #[serde(with = "crate::utils::http::serde::status_code")]
    pub code: StatusCode,
    pub body: Value,
}

#[derive(Deserialize, Debug)]
pub struct BatchResponse {
    results: NonEmpty<BatchResponseItem>,
}

impl TryFrom<BatchResponse> for NonEmpty<StorageRPCResponse> {
    type Error = anyhow::Error;

    fn try_from(value: BatchResponse) -> Result<Self, Self::Error> {
        value
            .results
            .into_iter()
            .map(|BatchResponseItem { code, body }| StorageRPCResponse {
                status: code,
                body: Json(body),
            })
            .collect::<Vec<_>>()
            .try_into()
            .map_err(|_| unreachable!())
    }
}

impl StorageRPC for BatchRequest {
    type Output = BatchResponse;
}

impl TryFrom<BatchRequest> for StorageRPCRequest {
    type Error = anyhow::Error;

    fn try_from(BatchRequest { requests }: BatchRequest) -> Result<Self, Self::Error> {
        Ok(Self {
            method: Cow::Borrowed("batch"),
            params: json!({
                "requests": requests,
            }),
            namespace: None,
        })
    }
}
