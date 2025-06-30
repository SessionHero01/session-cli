use crate::db::conversations::conversation_list_query;
use crate::db::Repository;
use crate::protos::{ListConversationsRequest, ListConversationsResponse};
use crate::service::StreamingService;
use futures_core::Stream;
use futures_util::TryStreamExt;
use std::sync::Arc;
use std::time::Duration;

#[derive(Clone)]
pub struct ListConversationsService(pub Arc<Repository>);

impl StreamingService for ListConversationsService {
    type Request = ListConversationsRequest;
    type Item = anyhow::Result<ListConversationsResponse>;

    async fn call(
        &self,
        req: Self::Request,
    ) -> anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static> {
        Ok(self
            .0
            .clone()
            .rerun_query_on_changes(
                Duration::from_secs(1),
                conversation_list_query(req.approved),
            )?
            .map_ok(|r| ListConversationsResponse {
                conversations: r.into_vec(),
            }))
    }
}
