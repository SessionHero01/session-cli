use super::super::axum_adapter::{TowerServiceable, TowerStreamingServiceable};
use super::state::State;
use axum::routing::{delete_service, get_service};
use axum::Router;
use std::sync::Arc;

pub fn create_router(state: Arc<State>) -> Router<()> {
    Router::new()
        .route(
            "/conversations",
            get_service(
                super::list_conversations::ListConversationsService(state.repository.clone())
                    .http_query_rpc(),
            ),
        )
        .route(
            "/conversation/messages",
            get_service(
                super::get_conversation::GetConversationMessagesService {
                    repo: state.repository.clone(),
                    clock: state.clock_source.clone(),
                    community_commands: state.community_commands.clone(),
                }
                .http_query_rpc(),
            ),
        )
        .route(
            "/conversation",
            get_service(
                super::get_conversation::GetConversationDetailsService(state.repository.clone())
                    .http_query_rpc(),
            ),
        )
        .route(
            "/network_state",
            get_service(
                super::get_network_status::GetNetworkStateService(state.network.clone())
                    .http_query_rpc(),
            ),
        )
        .route(
            "/contacts",
            get_service(
                super::list_contacts::ListContactsService(state.repository.clone())
                    .http_query_rpc(),
            ),
        )
        .route(
            "/files",
            get_service(
                super::get_file::GetFileService {
                    account_state: state.clone(),
                }
                .http_query_raw(),
            ),
        )
        .route(
            "/files",
            delete_service(
                super::trim_file_cache::TrimFileCacheService(state.trim_file_command_tx.clone())
                    .http_body_rpc(),
            ),
        )
        .with_state(state)
}
