use crate::service::axum_adapter::{TowerServiceable, TowerStreamingServiceable};
use anyhow::Context;
use axum::routing::{any, delete_service, get_service, post_service};
use axum::Router;
use std::net::{SocketAddr, TcpListener, ToSocketAddrs};
use std::path::PathBuf;
use std::sync::Arc;
use tokio::task::JoinSet;
use tower_http::cors::CorsLayer;
use tower_http::trace::TraceLayer;

mod account_dispatch;
mod create_account;
mod db;
mod delete_account;
mod list_account;
mod restore_account;
mod state;

pub fn create_global_service(
    _psk: &[u8],
    listen: impl ToSocketAddrs,
    data_dir: PathBuf,
) -> anyhow::Result<(JoinSet<std::io::Result<()>>, SocketAddr)> {
    let state = Arc::new(state::GlobalState::new(data_dir).context("Creating state")?);

    let listener = TcpListener::bind(listen).context("Bind TCP server")?;
    let local_addr = listener.local_addr().context("Get local address")?;
    let server = axum_server::from_tcp(listener);

    let router = Router::new()
        .route(
            "/accounts",
            post_service(create_account::CreateAccountService(state.clone()).http_body_rpc()),
        )
        .route(
            "/accounts",
            delete_service(delete_account::DeleteAccountService(state.clone()).http_body_rpc()),
        )
        .route(
            "/accounts/restore",
            post_service(restore_account::RestoreAccountService(state.clone()).http_body_rpc()),
        )
        .route(
            "/accounts",
            get_service(list_account::ListAccountService(state.clone()).http_query_rpc()),
        )
        .route(
            "/accounts/{session_id}/{*tree}",
            any(account_dispatch::account_dispatch),
        )
        .layer(TraceLayer::new_for_http())
        .layer(CorsLayer::permissive())
        .with_state(state);

    let mut join_set = JoinSet::new();
    join_set.spawn(server.serve(router.into_make_service()));

    Ok((join_set, local_addr))
}
