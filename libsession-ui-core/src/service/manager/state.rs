use super::db::ManagerRepository;
use crate::network::dynamic::DynamicNetwork;
use crate::protos::{ListAccountsResponse, list_accounts_response::Account as ProtoAccount};
use crate::service::Service;
use crate::service::account::Account;
use crate::service::account::get_file::{GetFileRequest, GetFileResponse, GetFileService};
use crate::service::account::state::State as AccountState;
use crate::service::manager::db::accounts::list_accounts_query;
use crate::session_id::IndividualID;
use crate::utils::base64::Base64;
use crate::utils::sync::watcher::Watcher;
use anyhow::Context;
use async_stream::stream;
use axum::Router;
use base64::Engine;
use base64::prelude::BASE64_STANDARD;
use futures_core::Stream;
use indexmap::IndexMap;
use libsession_protos::protos::EncryptedFile;
use parking_lot::Mutex;
use r2d2_sqlite::SqliteConnectionManager;
use std::path::PathBuf;
use std::sync::Arc;
use tokio::sync::watch::Ref;
use tokio::task::JoinSet;

pub(super) struct GlobalState {
    pub repo: Arc<ManagerRepository>,
    pub(super) state: Watcher<IndexMap<IndividualID, AccountInfo>>,
    join_set: Mutex<JoinSet<anyhow::Result<()>>>,
    pub network: Arc<DynamicNetwork>,
    pub data_dir: PathBuf,
    pub ssl_psk: Option<Vec<u8>>,
}

struct AccountInstance {
    account: Account,
    router: Router,
}

pub(super) struct AccountInfo {
    pub account: ProtoAccount,
    account_instance: Option<AccountInstance>,
}

impl GlobalState {
    pub fn new(data_dir: PathBuf) -> anyhow::Result<Self> {
        std::fs::create_dir_all(&data_dir).context("Creating data directory")?;

        let repo =
            ManagerRepository::new(SqliteConnectionManager::file(data_dir.join("global.db")))
                .context("Creating manager repository")?;

        let repo = Arc::new(repo);

        let network = Arc::new(
            DynamicNetwork::new_default(data_dir.join("quic_cache")).context("Creating network")?,
        );

        let accounts = repo
            .query(&list_accounts_query())
            .context("Get initial accounts")?;

        let state = Watcher::<IndexMap<IndividualID, AccountInfo>>::new(
            accounts
                .into_iter()
                .filter_map(|account| {
                    Some((
                        account.session_id.parse().ok()?,
                        AccountInfo {
                            account: account.into(),
                            account_instance: None,
                        },
                    ))
                })
                .collect(),
        );

        let mut join_set = JoinSet::new();

        // Sync the state back into database
        join_set.spawn({
            let mut state = state.subscribe();
            let repo = repo.clone();
            async move {
                loop {
                    while state.changed().await.is_ok() {
                        let accounts = state
                            .borrow()
                            .iter()
                            .map(|(_, info)| info.account.clone())
                            .collect::<Vec<_>>();

                        if let Err(e) = repo.save_accounts(&accounts).context("Saving accounts") {
                            tracing::error!("Failed to save accounts: {e:?}");
                            return Err(e);
                        }

                        tracing::info!("Saved {} accounts into db", accounts.len());
                    }
                }
            }
        });

        Ok(Self {
            repo,
            data_dir,
            network,
            join_set: Mutex::new(join_set),
            state,
            ssl_psk: None,
        })
    }

    pub fn add_account_instance(&self, id: &IndividualID, account: Account) {
        let account_state = account.clone();

        self.state.send_modify(move |m| {
            let session_id = id.to_string();
            let router = account.create_router();
            if m.insert(
                id.clone(),
                AccountInfo {
                    account: ProtoAccount {
                        session_id,
                        name: Default::default(),
                        avatar_image: None,
                    },
                    account_instance: Some(AccountInstance { account, router }),
                },
            )
            .is_some()
            {
                tracing::warn!("Account instance already exists for {id}");
            };
        });

        let task = sync_account_state(id.clone(), account_state, self.state.clone());
        self.join_set.lock().spawn(task);
    }

    pub fn get_or_create_account_router(
        &self,
        id: &IndividualID,
        create: impl FnOnce() -> anyhow::Result<Account>,
    ) -> anyhow::Result<Option<Router>> {
        // Quickly borrow if the account instance is already created
        if let Some(AccountInfo {
            account_instance: Some(AccountInstance { router, .. }),
            ..
        }) = self.state.borrow().get(id)
        {
            return Ok(Some(router.clone()));
        }

        // Otherwise, lock the state and create the account instance if it doesn't exist

        let mut router = anyhow::Ok(Option::<Router>::None);
        let mut account_state_to_sync = None;

        self.state.send_if_modified(|map| match map.get_mut(id) {
            Some(AccountInfo {
                account_instance: Some(AccountInstance { router: r, .. }),
                ..
            }) => {
                router = Ok(Some(r.clone()));
                false
            }

            Some(AccountInfo {
                account_instance, ..
            }) => {
                let account = match create() {
                    Err(e) => {
                        router = Err(e);
                        return false;
                    }

                    Ok(v) => v,
                };

                let r = account.create_router();
                router = Ok(Some(r.clone()));
                account_state_to_sync.replace(account.clone());
                account_instance.replace(AccountInstance { account, router: r });

                true
            }

            None => false,
        });

        if let Some(account) = account_state_to_sync {
            let task = sync_account_state(id.clone(), account, self.state.clone());
            self.join_set.lock().spawn(task);
        }

        router
    }

    fn create_response_from_state(
        state: &IndexMap<IndividualID, AccountInfo>,
    ) -> ListAccountsResponse {
        ListAccountsResponse {
            accounts: state
                .iter()
                .map(|(_, account)| account.account.clone())
                .collect(),
        }
    }

    pub(super) fn borrow_account_info(&self) -> Ref<IndexMap<IndividualID, AccountInfo>> {
        self.state.borrow()
    }

    pub fn watch_accounts(&self) -> impl Stream<Item = ListAccountsResponse> + Send + 'static {
        let mut receiver = self.state.subscribe();
        stream! {
            loop {
                let response = Self::create_response_from_state(&*receiver.borrow());
                yield response;
                if receiver.changed().await.is_err() {
                    break;
                }
            }
        }
    }

    pub fn delete_account(&self, id: &IndividualID) {
        self.state
            .send_if_modified(|m| m.shift_remove(id).is_some());

        if let Ok(dir) = self.ensure_account_dir(id) {
            if let Err(e) = std::fs::remove_dir_all(dir) {
                tracing::error!("Failed to remove account directory: {e:?}");
            }
        }
    }

    pub(super) fn ensure_account_dir(&self, session_id: &IndividualID) -> anyhow::Result<PathBuf> {
        let dir = self.data_dir.join("accounts").join(session_id.as_str());
        if dir.exists() && !dir.is_dir() {
            anyhow::bail!(
                "Account directory {} exists but it's not a directory",
                dir.display()
            );
        }

        std::fs::create_dir_all(&dir).context("Creating account directory")?;
        Ok(dir)
    }
}

async fn sync_account_state(
    session_id: IndividualID,
    account_state: Arc<AccountState>,
    state: Watcher<IndexMap<IndividualID, AccountInfo>>,
) -> anyhow::Result<()> {
    let get_file_service = GetFileService {
        account_state: account_state.clone(),
    };

    let user_profile_config = account_state.config_state.user_profile.clone();

    loop {
        let (file, name): (Option<EncryptedFile>, _) = {
            let user_profile_config = user_profile_config.borrow();
            (
                user_profile_config.profile_pic().map(Into::into),
                user_profile_config.name().to_string(),
            )
        };

        let file = if let Some(file) = file {
            match get_file_service
                .call(GetFileRequest::EncryptedFile {
                    url: file.url.parse()?,
                    key: Some(Base64(BASE64_STANDARD.decode(file.key)?)),
                    invalidate_cache: false,
                })
                .await
            {
                Ok(GetFileResponse(resp)) => Some(resp.into_body()),

                Err(e) => {
                    tracing::error!("Failed to get profile pic: {e:?}");
                    None
                }
            }
        } else {
            None
        };

        state.send_if_modified(|m| match m.get_mut(&session_id) {
            Some(info) => {
                info.account.name = name;
                info.account.avatar_image = file.map(|b| b.into());
                true
            }

            None => false,
        });

        if user_profile_config.subscribe().recv().await.is_err() {
            break;
        }
    }

    Ok(())
}
