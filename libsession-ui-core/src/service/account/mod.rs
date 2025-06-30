mod get_conversation;
pub mod get_file;
mod get_network_status;
mod list_contacts;
mod list_conversations;
mod router;
pub mod state;
mod trim_file_cache;

use crate::clock::ClockSource;
use crate::db::Repository;
use crate::identity::Identity;
use crate::network::dynamic::{DynamicNetwork, NetworkType};
use crate::network::http_executor::NetworkHttpApiExecutor;
use crate::network::storage_rpc_executor::NetworkNodeRpcExecutor;
use crate::non_empty_vec;
use crate::worker::{SyncAccount, trim_file_cache};
use anyhow::{Context, format_err};
use axum::Router;
use axum_server::{Handle, Server};
use derive_more::Deref;
use futures_util::TryFutureExt;
use r2d2_sqlite::SqliteConnectionManager;
use reqwest::{Certificate, Client};
use std::net::SocketAddr;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::{broadcast, mpsc};
use tokio::task::JoinSet;
use tower_http::trace::TraceLayer;
use url::Url;

use crate::db::app_setting::AppSettingRepositoryExt;
use crate::service::account::state::ConfigState;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::reqwest_proxy::ClientBuilderProxyExt;
use crate::worker::strategy::SimplePollStrategy;
use state::State;

const CONFIG_POLL_INTERVAL: Duration = Duration::from_secs(10);

pub fn default_seed_nodes() -> NonEmpty<(Url, &'static [u8])> {
    non_empty_vec![
        (
            "https://seed1.getsession.org:4443/".parse().unwrap(),
            include_bytes!("../../certs/seed1-getsession-org-chain.pem").as_ref()
        ),
        (
            "https://seed2.getsession.org:4443/".parse().unwrap(),
            include_bytes!("../../certs/seed2-getsession-org-chain.pem").as_ref()
        ),
        (
            "https://seed3.getsession.org:4443/".parse().unwrap(),
            include_bytes!("../../certs/seed3-getsession-org-chain.pem").as_ref()
        )
    ]
}

#[derive(Deref)]
pub struct Account {
    #[deref]
    state: Arc<State>,
    join_set: JoinSet<anyhow::Result<()>>,
}

pub async fn create_account_service(
    data_dir: impl AsRef<Path>,
    mnemonic: &str,
    db_password: Option<String>,
    listen: SocketAddr,
) -> anyhow::Result<(JoinSet<anyhow::Result<()>>, SocketAddr)> {
    let identity = Identity::from_mnemonic(&mnemonic).expect("Valid mnenmonic");

    std::fs::create_dir_all(&data_dir).expect("To create data directory");

    let account = Account::new(data_dir, Some(identity.clone()), db_password)
        .expect("Creating account state");

    let router = account.create_router().layer(TraceLayer::new_for_http());

    let handle = Handle::new();
    let serve_router = Server::bind(listen)
        .handle(handle.clone())
        .serve(router.into_make_service())
        .map_err(|e| format_err!("Error serving axum server: {e:?}"));

    let mut join_set = JoinSet::new();

    join_set.spawn(serve_router);
    join_set.spawn(account.wait());

    let listener = handle.listening().await.expect("To get listening address");
    Ok((join_set, listener))
}

impl Account {
    pub fn new(
        data_dir: impl AsRef<Path>,
        identity: Option<Identity>,
        db_password: Option<String>,
    ) -> anyhow::Result<Self> {
        let db_path = data_dir.as_ref().join("account.db");
        tracing::info!("Opening db connection at: {}", db_path.display());
        let connection = SqliteConnectionManager::file(db_path);

        let repository = match db_password {
            Some(db_password) => Repository::new_with_password(connection, db_password)?,
            None => Repository::new(connection)?,
        };

        let identity = match identity {
            Some(identity) => {
                repository
                    .with_connection(|conn| conn.save_settings_without_id(&identity))
                    .context("Saving identity")?;
                identity
            }

            None => repository
                .with_connection(|conn| conn.load_settings_without_id())
                .context("Loading identity")?
                .context("No identity found")?,
        };

        std::fs::create_dir_all(data_dir.as_ref()).with_context(|| {
            format!(
                "Unable to create data directory for account at: {}",
                data_dir.as_ref().display()
            )
        })?;

        let network = Arc::new(
            DynamicNetwork::new_default(data_dir.as_ref().join("quic_cache"))
                .context("Creating network")?,
        );

        let mut join_set = JoinSet::new();

        let clock_source = ClockSource::default();

        let (trim_file_command_tx, trim_file_command_rx) = mpsc::channel(1);

        let repository = Arc::new(repository);
        let sync_account = SyncAccount::new(repository.clone(), identity.clone())?;

        let config_state = ConfigState {
            user_groups: sync_account.user_groups_config.clone(),
            user_profile: sync_account.user_profile_config.clone(),
            convo_info: sync_account.convo_info_config.clone(),
            contacts: sync_account.contacts_config.clone(),
        };

        let state = Arc::new(State {
            identity,
            config_state,
            repository,
            clock_source: clock_source.clone(),
            manual_poll_trigger_tx: broadcast::channel(1).0,
            network,
            file_cache_dir: data_dir.as_ref().join("files"),
            trim_file_command_tx,
            community_commands: sync_account.community_commands_tx.clone(),
        });

        join_set.spawn(sync_account.run(
            NetworkNodeRpcExecutor::new(state.network.clone()),
            NetworkHttpApiExecutor::new(state.network.clone()),
            clock_source,
            SimplePollStrategy::new(Duration::from_secs(5)),
            SimplePollStrategy::new(Duration::from_secs(5)),
        ));

        {
            let repo = state.repository.clone();
            join_set.spawn(async move {
                trim_file_cache(
                    &repo,
                    Duration::from_secs(3600 * 24 * 7),
                    Duration::from_secs(3600),
                    trim_file_command_rx,
                )
                .await
            });
        }

        Ok(Self { state, join_set })
    }

    pub fn create_router(&self) -> Router<()> {
        router::create_router(self.state.clone())
    }

    pub async fn wait(mut self) -> anyhow::Result<()> {
        while !self.join_set.is_empty() {
            let _ = self.join_set.join_next().await.context("Error joining")??;
        }

        Ok(())
    }
}

impl DynamicNetwork {
    pub fn new_default(quic_cache_path: PathBuf) -> anyhow::Result<Self> {
        let (seed_nodes, certificates): (Vec<_>, Vec<_>) = default_seed_nodes().into_iter().unzip();

        DynamicNetwork::new(
            certificates
                .into_iter()
                .fold(
                    Client::builder().danger_accept_invalid_certs(true),
                    |c, cert| {
                        c.add_root_certificate(
                            Certificate::from_pem(cert).expect("A valid certificate"),
                        )
                    },
                )
                .apply_system_proxy()
                .build()
                .context("To building reqwest client")?,
            NonEmpty::from_vec(seed_nodes).unwrap(),
            quic_cache_path,
            NetworkType::Legacy,
        )
    }
}
