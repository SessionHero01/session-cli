use crate::http_api::executor::HttpRPCResponse;
use crate::http_api::json::HttpJsonRPC;
use crate::utils::http::mime::ContentTypeExt;
use crate::utils::iter::non_empty::NonEmpty;
use base64::Engine;
use base64::prelude::BASE64_STANDARD;
use http::{Method, Request, Response, StatusCode};
use mime::{APPLICATION_JSON, APPLICATION_OCTET_STREAM, Mime};
use serde::Serialize;
use serde_json::{Value, json};
use serde_with::serde_derive::Deserialize;
use std::borrow::Cow;

pub async fn new_batch_request_item(item: Request<Vec<u8>>) -> anyhow::Result<Value> {
    let (parts, body) = item.into_parts();
    let path = parts
        .uri
        .path_and_query()
        .map(|s| s.as_str())
        .unwrap_or("/");

    let is_json = matches!(parts.headers.get_content_type(), Some(v) if v == APPLICATION_JSON);

    let headers = Value::Object(
        parts
            .headers
            .into_iter()
            .filter_map(|(name, value)| {
                let name = name?;
                let name = name.as_str().to_string();
                let value = value.to_str().ok()?.to_string();
                Some((name, Value::String(value)))
            })
            .collect(),
    );

    let mut value = json!({
        "method" : parts.method.as_str(),
        "path": path,
        "headers": headers,
    });

    if !body.is_empty() {
        if is_json {
            value["json"] = serde_json::from_slice::<Value>(&body)?;
        } else {
            value["b64"] = Value::String(BASE64_STANDARD.encode(&body));
        }
    }

    Ok(value)
}

#[derive(Deserialize)]
pub struct BatchResponseItem {
    #[serde(with = "crate::utils::http::serde::status_code")]
    pub code: StatusCode,
    #[serde(rename = "content-type")]
    pub content_type: Option<String>,
    pub body: Option<Value>,
}

#[derive(Serialize)]
pub struct BatchRequest(pub NonEmpty<Value>);

#[derive(Deserialize)]
pub struct BatchResponse(NonEmpty<BatchResponseItem>);

impl TryInto<NonEmpty<HttpRPCResponse>> for BatchResponse {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<NonEmpty<HttpRPCResponse>, Self::Error> {
        Ok(self.0.map(
            |BatchResponseItem {
                 code,
                 content_type,
                 body,
             }| {
                let mut response = Response::new(vec![]);
                *response.status_mut() = code;

                let content_type = content_type
                    .and_then(|s| s.parse::<Mime>().ok())
                    .unwrap_or(APPLICATION_OCTET_STREAM);

                match (body, &content_type) {
                    (Some(Value::String(body)), t) if t != &APPLICATION_JSON => {
                        match BASE64_STANDARD.decode(body) {
                            Ok(body) => {
                                *response.body_mut() = body;
                            }
                            Err(e) => {
                                tracing::error!("Failed to decode base64: {:?}", e);
                            }
                        };
                    }

                    (Some(body), _) => {
                        *response.body_mut() = body.to_string().into_bytes();
                    }

                    _ => {}
                }

                let _ = response.set_content_type(content_type);
                HttpRPCResponse(response)
            },
        ))
    }
}

impl HttpJsonRPC for BatchRequest {
    type Output = BatchResponse;

    fn method(&self) -> Method {
        Method::POST
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        std::iter::once(Cow::Borrowed("batch"))
    }

    fn body(&self) -> Option<impl Serialize> {
        Some(self)
    }
}
