use crate::identity::Identity;
use crate::key::ed25519::gen_pair;
use crate::protos::{CreateAccountRequest, LoggedInResponse};
use crate::service::account::Account;
use crate::service::Service;
use std::sync::Arc;
use tracing::instrument;

#[derive(Clone)]
pub struct CreateAccountService(pub Arc<super::state::GlobalState>);

impl Service for CreateAccountService {
    type Request = CreateAccountRequest;
    type Response = LoggedInResponse;

    #[instrument(skip(self, req), ret, name = "create_account")]
    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        let identity: Identity = Identity::new(gen_pair());
        let session_id = identity.individual_id().to_string();
        let CreateAccountRequest { db_password, .. } = req;
        let id = identity.individual_id().clone();

        let account = Account::new(self.0.ensure_account_dir(&id)?, Some(identity), db_password)?;

        self.0.add_account_instance(&id, account);

        Ok(LoggedInResponse { session_id })
    }
}
