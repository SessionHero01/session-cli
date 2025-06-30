use crate::batcher::Batchable;
use crate::rpc::RPCExecutor;
use crate::utils::http::base_url::HttpBaseUrl;
use derive_more::{Debug, Deref, DerefMut};
use http::{Request, Response};
use url::Url;

#[derive(Debug)]
pub struct HttpRPCRequest {
    pub base_url: HttpBaseUrl,
    pub request: Request<Vec<u8>>,
    pub can_batch: bool,
}

impl HttpRPCRequest {
    pub fn full_url(&self) -> Option<Url> {
        self.base_url.join(&self.request.uri().to_string()).ok()
    }
}

#[derive(Deref, DerefMut, Debug)]
pub struct HttpRPCResponse(pub Response<Vec<u8>>);

pub trait HttpRPCExecutor: RPCExecutor<HttpRPCRequest, HttpRPCResponse> {}

impl<E: RPCExecutor<HttpRPCRequest, HttpRPCResponse>> HttpRPCExecutor for E {}

impl Batchable for HttpRPCRequest {
    fn should_batch_with(&self, other: &Self) -> bool {
        self.base_url == other.base_url
    }

    fn can_batch(&self) -> bool {
        self.can_batch
    }
}
