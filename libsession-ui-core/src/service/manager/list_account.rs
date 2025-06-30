use crate::protos::{ListAccountsRequest, ListAccountsResponse};
use crate::service::StreamingService;
use futures_core::Stream;
use std::sync::Arc;
use tokio_stream::StreamExt;

#[derive(Clone)]
pub struct ListAccountService(pub Arc<super::state::GlobalState>);

impl StreamingService for ListAccountService {
    type Request = ListAccountsRequest;
    type Item = anyhow::Result<ListAccountsResponse>;

    async fn call(
        &self,
        _req: Self::Request,
    ) -> anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static> {
        Ok(self.0.watch_accounts().map(Ok))
    }
}
