use anyhow::Context;
use axum::body::Body;
use axum::extract::{FromRequest, Request};
use axum::response::{IntoResponse, Response};
use futures_util::FutureExt;
use http::header::{ACCEPT, CONTENT_TYPE, TRANSFER_ENCODING};
use http::{HeaderMap, StatusCode};
use mime::Mime;
use prost::Message;
use serde::{Deserialize, Serialize};
use std::convert::Infallible;
use std::future::Future;
use std::pin::Pin;
use std::str::FromStr;
use std::task::Poll;
use tower::Service as TowerService;

use super::{Service, StreamingService};
use crate::utils::http::axum_extractor::{NegotiatedRequestBody, Query, ResponseContentType};
use crate::utils::http::axum_stream::StreamingBody;

pub trait TowerServiceable: Service {
    fn http_query_rpc(self) -> TowerServiceAdapter<Self, Query<Self::Request>>
    where
        Self: Send + Clone + Sync + Sized + 'static,
        Self::Request: for<'de> Deserialize<'de>,
        Self::Response: Serialize + Message,
    {
        TowerServiceAdapter {
            service: self,
            request_transform: |r| r.0,
            response_transform: make_content,
        }
    }

    fn http_body_rpc(self) -> TowerServiceAdapter<Self, NegotiatedRequestBody<Self::Request>>
    where
        Self: Send + Clone + Sync + Sized + 'static,
        Self::Request: for<'de> Deserialize<'de> + Message + Default,
        Self::Response: Serialize + Message,
    {
        TowerServiceAdapter {
            service: self,
            request_transform: |r| r.0,
            response_transform: make_content,
        }
    }

    fn http_query_raw(self) -> TowerServiceAdapter<Self, Query<Self::Request>>
    where
        Self: Send + Clone + Sync + Sized + 'static,
        Self::Request: for<'de> Deserialize<'de>,
        Self::Response: IntoResponse,
    {
        TowerServiceAdapter {
            service: self,
            request_transform: |r| r.0,
            response_transform: |_, r| r.into_response(),
        }
    }
}

impl<S> TowerServiceable for S where S: Service {}

pub struct TowerServiceAdapter<S, R>
where
    S: Service,
    R: FromRequest<()>,
{
    service: S,
    request_transform: fn(R) -> S::Request,
    response_transform: fn(ResponseContentType, S::Response) -> Response,
}

impl<S, R> Clone for TowerServiceAdapter<S, R>
where
    S: Service + Clone,
    R: FromRequest<()>,
{
    fn clone(&self) -> Self {
        Self {
            service: self.service.clone(),
            request_transform: self.request_transform,
            response_transform: self.response_transform,
        }
    }
}

impl<S, R> TowerService<Request> for TowerServiceAdapter<S, R>
where
    S: Service + Send + Sync + Clone + 'static,
    R: FromRequest<()> + 'static,
{
    type Response = Response;
    type Error = Infallible;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>> + Send>>;

    fn poll_ready(&mut self, _cx: &mut std::task::Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, req: Request) -> Self::Future {
        let service = self.service.clone();
        let request_transform = self.request_transform;
        let response_transform = self.response_transform;
        Box::pin(
            async move {
                let content = get_content_type(req.headers());
                let r = R::from_request(req, &())
                    .await
                    .map_err(|e| e.into_response())?;

                let r = (request_transform)(r);

                let resp = service.call(r).await.map_err(|e| {
                    tracing::error!("Error in service: {e:?}");
                    (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()).into_response()
                })?;

                Ok(response_transform(content, resp))
            }
            .map(|r| Ok(r.unwrap_or_else(|r| r))),
        )
    }
}

pub trait TowerStreamingServiceable<Item>: StreamingService<Item = anyhow::Result<Item>>
where
    Item: 'static,
{
    fn http_query_rpc(self) -> TowerStreamingServiceAdapter<Self, Query<Self::Request>, Item>
    where
        Self: Send + Clone + Sync + Sized + 'static,
        Self::Request: for<'de> Deserialize<'de> + Message + Default,
        Item: Serialize + Message,
    {
        TowerStreamingServiceAdapter {
            service: self,
            transform: |r| r.0,
        }
    }
}

impl<S, Item> TowerStreamingServiceable<Item> for S
where
    S: StreamingService<Item = anyhow::Result<Item>>,
    Item: 'static,
{
}

pub struct TowerStreamingServiceAdapter<S, R, Item>
where
    S: StreamingService<Item = anyhow::Result<Item>> + Send + Sync + Clone + 'static,
    R: FromRequest<()> + 'static,
    Item: Serialize + Message + Send + Sync + 'static,
{
    service: S,
    transform: fn(R) -> S::Request,
}

impl<S, R, Item> Clone for TowerStreamingServiceAdapter<S, R, Item>
where
    S: StreamingService<Item = anyhow::Result<Item>> + Send + Sync + Clone + 'static,
    R: FromRequest<()> + 'static,
    Item: Serialize + Message + Send + Sync + 'static,
{
    fn clone(&self) -> Self {
        Self {
            service: self.service.clone(),
            transform: self.transform,
        }
    }
}

impl<S, R, Item> TowerService<Request> for TowerStreamingServiceAdapter<S, R, Item>
where
    S: StreamingService<Item = anyhow::Result<Item>> + Send + Sync + Clone + 'static,
    R: FromRequest<()> + 'static,
    Item: Serialize + Message + Send + Sync + 'static,
{
    type Response = Response;
    type Error = Infallible;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>> + Send>>;

    fn poll_ready(&mut self, _cx: &mut std::task::Context<'_>) -> Poll<Result<(), Self::Error>> {
        Poll::Ready(Ok(()))
    }

    fn call(&mut self, req: Request) -> Self::Future {
        let service = self.service.clone();
        let transform = self.transform;
        Box::pin(
            async move {
                let content = get_content_type(req.headers());
                let r = R::from_request(req, &())
                    .await
                    .map_err(|e| e.into_response())?;

                let r = (transform)(r);

                let body = service
                    .call(r)
                    .await
                    .map(|resp| StreamingBody::new(resp, content));

                let mut resp = match body {
                    Ok(body) => Response::new(Body::new(body)),
                    Err(e) => {
                        tracing::error!("Error in service: {e:?}");
                        return Ok(
                            (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()).into_response()
                        );
                    }
                };

                resp.headers_mut()
                    .insert(CONTENT_TYPE, content.header_value());

                resp.headers_mut()
                    .insert(TRANSFER_ENCODING, "chunked".parse().unwrap());

                Ok(resp)
            }
            .map(|r| Ok(r.unwrap_or_else(|r| r))),
        )
    }
}

fn get_content_type(headers: &HeaderMap) -> ResponseContentType {
    headers
        .get(ACCEPT)
        .and_then(|v| v.to_str().ok())
        .and_then(|v| Mime::from_str(v).ok())
        .map(|v| {
            if v.essence_str() == "application/protobuf" {
                ResponseContentType::Protobuf
            } else {
                ResponseContentType::Json
            }
        })
        .unwrap_or(ResponseContentType::Json)
}

fn make_content(content_type: ResponseContentType, content: impl Serialize + Message) -> Response {
    (move || {
        let (content, content_type) = match content_type {
            ResponseContentType::Protobuf => (content.encode_to_vec(), "application/protobuf"),

            ResponseContentType::Json => (
                serde_json::to_vec_pretty(&content).context("Encoding JSON")?,
                "application/json",
            ),
        };

        let mut response = Response::new(Body::from(content));
        response
            .headers_mut()
            .insert(CONTENT_TYPE, content_type.parse()?);
        anyhow::Ok(response)
    })()
    .unwrap_or_else(|e| {
        tracing::error!("Error in service: {e:?}");
        (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()).into_response()
    })
}
