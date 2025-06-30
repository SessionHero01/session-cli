use super::state::GlobalState;
use crate::service::Service;
use anyhow::Context;
use libsession_protos::protos::{DeleteAccountRequest, DeleteAccountResponse};
use std::sync::Arc;

#[derive(Clone)]
pub struct DeleteAccountService(pub Arc<GlobalState>);

impl Service for DeleteAccountService {
    type Request = DeleteAccountRequest;
    type Response = DeleteAccountResponse;

    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        self.0
            .delete_account(&req.session_id.parse().context("Invalid session id")?);
        Ok(Default::default())
    }
}
