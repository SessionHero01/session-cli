use crate::worker::TrimFileCacheCommand;
use anyhow::Context;
use libsession_protos::protos::trim_file_cache_request::Keep;
use libsession_protos::protos::{TrimFileCacheRequest, TrimFileCacheResponse};
use std::time::Duration;
use tokio::sync::{mpsc, oneshot};

#[derive(Clone)]
pub struct TrimFileCacheService(pub mpsc::Sender<TrimFileCacheCommand>);

impl super::super::Service for TrimFileCacheService {
    type Request = TrimFileCacheRequest;
    type Response = TrimFileCacheResponse;

    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        let (callback, callback_rx) = oneshot::channel();
        let keep = match req.keep {
            Some(Keep::KeepDefault(_)) | None => None,
            Some(Keep::KeepDays(days)) => Some(Duration::from_secs((days * 24 * 60 * 60) as u64)),
        };

        self.0
            .send(TrimFileCacheCommand::Trim { keep, callback })
            .await
            .context("Failed to send trim file cache command")?;

        callback_rx
            .await
            .context("Failed to receive trim file cache response")
            .map(|num_deleted| TrimFileCacheResponse {
                num_deleted: num_deleted as u32,
            })
    }
}
