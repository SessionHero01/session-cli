use std::borrow::Cow;
use std::os::raw::c_void;
use std::slice::from_raw_parts;

use crate::bindings;
use anyhow::{Context, ensure};
use axum::response::Response;
use http::request::Parts;
use http::{HeaderMap, HeaderName, HeaderValue, Request, StatusCode};
use indexmap::IndexMap;
use serde::ser::SerializeMap;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
struct OnionProxyRequestHeader<'a> {
    endpoint: &'a str,
    method: &'a str,
    headers: HeaderMapSerializer<'a>,
}

struct HeaderMapSerializer<'a>(Cow<'a, HeaderMap>);

impl<'a> Serialize for HeaderMapSerializer<'a> {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut map = serializer.serialize_map(Some(self.0.len()))?;
        for (key, value) in self.0.iter() {
            let Ok(value) = value.to_str() else {
                continue;
            };

            map.serialize_key(key.as_str())?;
            map.serialize_value(value)?;
        }

        map.end()
    }
}

impl<'de> Deserialize<'de> for HeaderMapSerializer<'static> {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let map: IndexMap<String, String> = IndexMap::deserialize(deserializer)?;
        let headers = map
            .into_iter()
            .filter_map(|(k, v)| {
                let name = HeaderName::from_bytes(k.as_bytes()).ok()?;
                let value: HeaderValue = v.parse().ok()?;
                Some((name, value))
            })
            .collect();
        Ok(Self(Cow::Owned(headers)))
    }
}

impl<'a> From<&'a Parts> for OnionProxyRequestHeader<'a> {
    fn from(value: &'a Parts) -> Self {
        Self {
            endpoint: value.uri.path_and_query().map_or("/", |x| x.as_str()),
            method: value.method.as_str(),
            headers: HeaderMapSerializer(Cow::Borrowed(&value.headers)),
        }
    }
}

pub async fn generate_onion_proxy_request(request: Request<Vec<u8>>) -> anyhow::Result<Vec<u8>> {
    let (parts, body) = request.into_parts();

    // Serialise header and append to result
    let header = serde_json::to_string(&OnionProxyRequestHeader::from(&parts))
        .context("Serialise header")?;

    let req = bindings::onion_proxy_request {
        header: header.as_ptr(),
        header_len: header.len(),
        body: body.as_ptr(),
        body_len: body.len(),
    };

    let mut result = vec![];

    unsafe extern "C" fn build_proxy_request(data: *mut c_void, buf: *const u8, len: usize) {
        unsafe {
            let data: &mut Vec<u8> = std::mem::transmute(data);
            data.extend_from_slice(from_raw_parts(buf, len));
        }
    }

    unsafe {
        bindings::encode_onion_proxy_request(
            &req,
            Some(build_proxy_request),
            std::mem::transmute(&mut result),
        )
    }

    Ok(result)
}

#[derive(Deserialize)]
struct OnionProxyResponseInfoJson {
    #[serde(with = "crate::utils::http::serde::status_code")]
    code: StatusCode,
    headers: HeaderMapSerializer<'static>,
}

pub fn decode_onion_proxy_response(data: &[u8]) -> anyhow::Result<Response<Vec<u8>>> {
    let mut resp = bindings::onion_proxy_response {
        response_info: std::ptr::null(),
        response_info_len: 0,
        body: std::ptr::null(),
        body_len: 0,
    };

    unsafe {
        ensure!(
            bindings::decode_onion_proxy_response(data.as_ptr(), data.len(), &mut resp),
            "Error decoding onion proxy response"
        );

        let info = from_raw_parts(resp.response_info, resp.response_info_len);
        let OnionProxyResponseInfoJson { code, headers } = serde_json::from_slice(info)
            .context("Error deserialize onion proxy response as JSON")?;

        let mut response = Response::builder()
            .status(code)
            .body(from_raw_parts(resp.body, resp.body_len).to_vec())
            .context("Error building response")?;

        response.headers_mut().clone_from(headers.0.as_ref());
        Ok(response)
    }
}
