use axum::extract::{FromRequest, FromRequestParts, Request};
use axum::response::{IntoResponse, Response};
use bytes::Bytes;
use http::header::{ACCEPT, CONTENT_TYPE};
use http::request::Parts;
use http::{HeaderValue, StatusCode};
use mime::{Mime, JSON};
use prost::Message;
use serde::Deserialize;
use std::str::FromStr;

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ResponseContentType {
    Protobuf,
    Json,
}

impl ResponseContentType {
    pub fn header_value(&self) -> HeaderValue {
        match self {
            Self::Protobuf => HeaderValue::from_static("application/protobuf"),
            Self::Json => HeaderValue::from_static(JSON.as_str()),
        }
    }
}

impl<S: Send + Sync> FromRequestParts<S> for ResponseContentType {
    type Rejection = (StatusCode, String);

    async fn from_request_parts(parts: &mut Parts, _state: &S) -> Result<Self, Self::Rejection> {
        match parts
            .headers
            .get(ACCEPT)
            .and_then(|v| v.to_str().ok())
            .and_then(|s| Mime::from_str(s).ok())
        {
            Some(accept)
                if accept
                    .essence_str()
                    .eq_ignore_ascii_case("application/protobuf") =>
            {
                Ok(Self::Protobuf)
            }
            Some(v) if v == mime::APPLICATION_JSON || v == mime::STAR_STAR => Ok(Self::Json),
            Some(a) => Err((
                StatusCode::BAD_REQUEST,
                format!("Unsupported content type: {a}"),
            )),
            None => Err((
                StatusCode::BAD_REQUEST,
                "Invalid content type for accept".to_string(),
            )),
        }
    }
}

pub struct NegotiatedRequestBody<T>(pub T);

impl<S, T> FromRequest<S> for NegotiatedRequestBody<T>
where
    T: for<'de> Deserialize<'de> + Message + Default,
    S: Send + Sync,
{
    type Rejection = Response;

    async fn from_request(req: Request, state: &S) -> Result<Self, Self::Rejection> {
        match req
            .headers()
            .get(CONTENT_TYPE)
            .and_then(|v| v.to_str().ok())
        {
            Some(content_type) if content_type.starts_with("application/protobuf") => {
                let bytes = Bytes::from_request(req, state)
                    .await
                    .map_err(|e| e.into_response())?;

                T::decode(bytes)
                    .map(NegotiatedRequestBody)
                    .map_err(|e| (StatusCode::BAD_REQUEST, e.to_string()).into_response())
            }

            _ => {
                let body = axum::extract::Json::<T>::from_request(req, state)
                    .await
                    .map_err(|e| e.into_response())?;
                Ok(NegotiatedRequestBody(body.0))
            }
        }
    }
}

pub struct Query<T>(pub T);

impl<S, T> FromRequest<S> for Query<T>
where
    S: Send + Sync,
    T: for<'de> Deserialize<'de>,
{
    type Rejection = <axum::extract::Query<T> as FromRequestParts<S>>::Rejection;

    async fn from_request(req: Request, state: &S) -> Result<Self, Self::Rejection> {
        axum::extract::Query::<T>::from_request(req, state)
            .await
            .map(|q| Query(q.0))
    }
}
