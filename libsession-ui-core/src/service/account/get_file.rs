use crate::config::Group;
use crate::files::decrypt::{Aes256CbcHmacSha256Decryptor, Aes256GcmDecryptor, decrypt_to};
use crate::http_api::HttpRPC;
use crate::http_api::caching::CachingHttpExecutor;
use crate::http_api::executor::HttpRPCExecutor;
use crate::http_api::raw::RawRPC;
use crate::network::embedded::find_file_server_pub_key;
use crate::network::http_executor::NetworkHttpApiExecutor;
use crate::sogs_api;
use crate::sogs_api::community_id::CommunityId;
use crate::utils::base64::Base64;
use crate::utils::http::base_url::HttpBaseUrl;
use anyhow::{Context, bail};
use axum::response::{IntoResponse, Response};
use http::Method;
use http_body_util::BodyExt;
use serde::Deserialize;
use serde_with::{DisplayFromStr, serde_as};
use std::fmt::Debug;
use std::sync::Arc;
use url::Url;

#[serde_as]
#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum GetFileRequest {
    EncryptedFile {
        url: Url,
        key: Option<Base64<Vec<u8>>>,
        #[serde(default)]
        #[serde_as(as = "DisplayFromStr")]
        invalidate_cache: bool,
    },
    CommunityFile {
        community_url: CommunityId,
        #[serde_as(as = "DisplayFromStr")]
        file_id: i64,
        #[serde(default)]
        #[serde_as(as = "DisplayFromStr")]
        invalidate_cache: bool,
    },
}

const HMAC_AND_AES_KEY_LEN: usize = 64;
const AES_GCM_KEY_LEN: usize = 32;

#[derive(Clone)]
pub struct GetFileService {
    pub account_state: Arc<super::state::State>,
}

pub struct GetFileResponse(pub Response<Vec<u8>>);

impl IntoResponse for GetFileResponse {
    fn into_response(self) -> Response {
        let (parts, body) = self.0.into_parts();
        Response::from_parts(parts, body.into())
    }
}

impl super::super::Service for GetFileService {
    type Request = GetFileRequest;
    type Response = GetFileResponse;

    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        match req {
            GetFileRequest::EncryptedFile { url, key, .. } => {
                // Is this URL a pre-defined server?
                if let Some(server_pub_key) =
                    find_file_server_pub_key(url.host_str().unwrap_or_default())
                {
                    return get_encrypted_file(
                        HttpBaseUrl::try_from(url.clone())?,
                        CachingHttpExecutor::new(
                            self.account_state.repository.clone(),
                            NetworkHttpApiExecutor::new(self.account_state.network.as_ref()),
                        ),
                        server_pub_key,
                        RawRPC(Method::GET, url, None),
                        key.as_ref().map(|k| k.as_slice()),
                    )
                    .await;
                }

                // Is this URL a community room file?
                if let Some((community_id, file_id)) = CommunityId::extract_room_file_id(&url) {
                    let room = community_id.room().to_string();
                    return get_encrypted_file(
                        community_id.server_url().clone(),
                        CachingHttpExecutor::new(
                            self.account_state.repository.clone(),
                            self.account_state.community_rpc_executor(),
                        ),
                        community_id,
                        sogs_api::get_file::GetFile { room, file_id },
                        None,
                    )
                    .await;
                }

                // Is this URL a community URL?
                let server_url = url.join("/").context("Invalid URL")?;
                let community_id = self
                    .account_state
                    .config_state
                    .user_groups
                    .borrow()
                    .get_groups()
                    .filter_map(|g| match g {
                        Group::Community(info) => info.id(),
                        _ => None,
                    })
                    .filter(|id| id.server_url().host() == server_url.host())
                    .next()
                    .context("Community not found")?;

                get_encrypted_file(
                    community_id.server_url().clone(),
                    CachingHttpExecutor::new(
                        self.account_state.repository.clone(),
                        self.account_state.community_rpc_executor(),
                    ),
                    community_id,
                    RawRPC(Method::GET, url, None),
                    None,
                )
                .await
            }
            GetFileRequest::CommunityFile {
                community_url,
                file_id,
                ..
            } => {
                let room = community_url.room().to_string();
                get_encrypted_file(
                    community_url.server_url().clone(),
                    CachingHttpExecutor::new(
                        self.account_state.repository.clone(),
                        self.account_state.community_rpc_executor(),
                    ),
                    community_url,
                    sogs_api::get_file::GetFile { room, file_id },
                    None,
                )
                .await
            }
        }
    }
}

async fn get_encrypted_file<E>(
    url: HttpBaseUrl,
    executor: E,
    executor_args: E::Args,
    rpc: impl HttpRPC<Output = Response<Vec<u8>>> + Sized + Send,
    file_key: Option<&[u8]>,
) -> anyhow::Result<GetFileResponse>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Send,
{
    let response = executor.execute_rpc(executor_args, (url, rpc)).await?;

    if !response.status().is_success() {
        return Ok(GetFileResponse(response));
    }

    let (parts, body) = response.into_parts();

    let decrypted = match file_key {
        Some(key) if key.len() == HMAC_AND_AES_KEY_LEN => decrypt_to(
            &Aes256CbcHmacSha256Decryptor {
                aes_key: (&key[..32]).try_into().unwrap(),
                hmac_key: (&key[32..]).try_into().unwrap(),
            },
            &body,
        ),
        Some(key) if key.len() == AES_GCM_KEY_LEN => decrypt_to(
            &Aes256GcmDecryptor {
                key: key.try_into().unwrap(),
            },
            &body,
        ),

        Some(key) => bail!("Invalid key length: {}", key.len()),
        None => return Ok(GetFileResponse(Response::from_parts(parts, body))),
    }?;

    Ok(GetFileResponse(Response::from_parts(parts, decrypted)))
}
