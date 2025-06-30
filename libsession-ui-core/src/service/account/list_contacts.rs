use crate::db::contacts::list_contacts_query;
use crate::db::Repository;
use crate::protos::{ListContactsRequest, ListContactsResponse};
use crate::service::StreamingService;
use futures_core::Stream;
use futures_util::TryStreamExt;
use std::sync::Arc;
use std::time::Duration;

#[derive(Clone)]
pub struct ListContactsService(pub Arc<Repository>);

impl StreamingService for ListContactsService {
    type Request = ListContactsRequest;

    type Item = anyhow::Result<ListContactsResponse>;

    async fn call(
        &self,
        req: Self::Request,
    ) -> anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static> {
        Ok(self
            .0
            .clone()
            .rerun_query_on_changes(
                Duration::from_secs(1),
                list_contacts_query(req.search_query),
            )?
            .map_ok(|contacts| ListContactsResponse {
                contacts: contacts.into_vec(),
            }))
    }
}
