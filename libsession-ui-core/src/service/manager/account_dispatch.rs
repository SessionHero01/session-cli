use crate::session_id::IndividualID;
use axum::extract::{Path, Request, State};
use axum::response::{IntoResponse, Response};
use http::header::AUTHORIZATION;
use http::{StatusCode, Uri};
use std::sync::Arc;
use tower::Service;

pub async fn account_dispatch(
    State(state): State<Arc<super::state::GlobalState>>,
    Path((session_id, path)): Path<(IndividualID, String)>,
    mut request: Request,
) -> Response {
    *request.uri_mut() = match request.uri().path_and_query() {
        Some(p) => {
            let mut new_path = format!("/{path}");
            if let Some(query) = p.query() {
                new_path.push_str("?");
                new_path.push_str(query);
            }
            new_path.parse().unwrap()
        }

        None => Uri::from_static("/"),
    };

    let mut password = request
        .headers()
        .get(AUTHORIZATION)
        .and_then(|header| header.to_str().ok())
        .map(|s| s.to_string());

    if matches!(password, Some(ref p) if p.is_empty()) {
        password = None;
    }

    let router = match state.get_or_create_account_router(&session_id, || {
        super::super::account::Account::new(state.ensure_account_dir(&session_id)?, None, password)
    }) {
        Ok(Some(r)) => r,
        Ok(None) => {
            return (StatusCode::UNAUTHORIZED, "Account not logged in").into_response();
        }
        Err(e) => {
            return (StatusCode::INTERNAL_SERVER_ERROR, format!("{e:?}")).into_response();
        }
    };

    router.into_service().call(request).await.into_response()
}
