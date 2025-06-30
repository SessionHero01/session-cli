use futures_core::Stream;
use std::future::Future;

pub mod account;
pub mod axum_adapter;
pub mod manager;

pub trait Service {
    type Request: Send + 'static;
    type Response: Send + 'static;

    fn call(
        &self,
        req: Self::Request,
    ) -> impl Future<Output = anyhow::Result<Self::Response>> + Send;
}

pub trait StreamingService {
    type Request: Send + 'static;
    type Item: Send + 'static;
    fn call(
        &self,
        req: Self::Request,
    ) -> impl Future<Output = anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static>> + Send;
}
