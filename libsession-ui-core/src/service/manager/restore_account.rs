use crate::identity::Identity;
use crate::protos::{LoggedInResponse, RestoreAccountRequest};
use crate::service::account::Account;
use crate::service::Service;
use anyhow::Context;
use std::sync::Arc;
use tracing::instrument;

#[derive(Clone)]
pub struct RestoreAccountService(pub Arc<super::state::GlobalState>);

impl Service for RestoreAccountService {
    type Request = RestoreAccountRequest;
    type Response = LoggedInResponse;

    #[instrument(skip(self, req), ret, name = "restore_account")]
    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        let RestoreAccountRequest {
            db_password,
            mnemonic,
        } = req;
        let identity: Identity = Identity::from_mnemonic(&mnemonic)?;
        let id = identity.individual_id().clone();
        let account = Account::new(self.0.ensure_account_dir(&id)?, Some(identity), db_password)
            .context("Creating account state")?;

        self.0.add_account_instance(&id, account);

        Ok(LoggedInResponse {
            session_id: id.to_string(),
        })
    }
}
