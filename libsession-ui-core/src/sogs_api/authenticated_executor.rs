use crate::batcher::Batchable;
use crate::clock::ClockSource;
use crate::http_api::executor::{HttpRPCExecutor, HttpRPCRequest, HttpRPCResponse};
use crate::identity::Identity;
use crate::key::curve25519::Curve25519PubKey;
use crate::rpc::RPCExecutor;
use crate::session_id::{Blind15ID, Blind25ID};
use anyhow::{bail, ensure};
use base64::Engine;
use base64::prelude::BASE64_STANDARD;
use http::Request;
use http::uri::PathAndQuery;
use libsession_util_sys::{session_blind15_sign, session_blind25_sign, session_ed25519_sign};
use rand::random;
use std::borrow::Cow;
use std::ptr::null;
use tracing::instrument;

#[derive(Debug, Clone, Eq, PartialEq)]
pub enum CommunityIdentityType {
    None,
    Unblinded,
    Blind15(Blind15ID),
    Blind25(Blind25ID),
}

impl Batchable for CommunityIdentityType {
    fn should_batch_with(&self, other: &Self) -> bool {
        self == other
    }
}

#[derive(Clone)]
pub struct AuthenticatedHttpApiExecutor<E, CS> {
    pub executor: E,
    pub user_identity: Option<Identity>,
    pub clock_source: CS,
}

impl<E, CS> RPCExecutor<HttpRPCRequest, HttpRPCResponse> for AuthenticatedHttpApiExecutor<E, CS>
where
    E: HttpRPCExecutor<Args = Curve25519PubKey> + Send + Sync,
    CS: AsRef<ClockSource> + Send + Sync,
{
    type Args = (Curve25519PubKey, CommunityIdentityType);

    #[instrument(skip(self), ret, level = "debug")]
    async fn execute(
        &self,
        (server_key, identity_type): Self::Args,
        req: HttpRPCRequest,
    ) -> anyhow::Result<HttpRPCResponse> {
        let Some(identity) = self.user_identity.as_ref() else {
            return self.executor.execute(server_key, req).await;
        };

        if matches!(identity_type, CommunityIdentityType::None) {
            return self.executor.execute(server_key, req).await;
        }

        let (mut parts, body) = req.request.into_parts();

        // Pubkey + nonce + timestamp in seconds + http verb + endpoint + body hash
        let mut message_to_sign = vec![];

        // Pub key
        message_to_sign.extend_from_slice(server_key.as_ref());

        // Nonce
        let nonce: [u8; 16] = random();
        message_to_sign.extend_from_slice(&nonce);

        // Timestamp
        let timestamp = self.clock_source.as_ref().now_or_uncalibrated().as_secs();
        use std::io::Write;
        let _ = write!(message_to_sign, "{timestamp}");

        // HTTP verb
        message_to_sign.extend_from_slice(parts.method.as_str().as_bytes());

        // Endpoint
        message_to_sign.extend_from_slice(
            parts
                .uri
                .path_and_query()
                .map(PathAndQuery::as_str)
                .unwrap_or("/")
                .as_bytes(),
        );

        // Materialize the request body and compute its hash
        if !body.is_empty() {
            let hash_size = 64usize;
            message_to_sign.resize(message_to_sign.len() + hash_size, 0);

            if !unsafe {
                let message_len = message_to_sign.len();
                libsession_util_sys::session_hash(
                    hash_size,
                    body.as_ptr(),
                    body.len(),
                    null(),
                    0,
                    (&mut message_to_sign[message_len - hash_size..]).as_mut_ptr(),
                )
            } {
                bail!("Failed to hash message");
            }
        };

        // Now generate the signature
        let mut signature = vec![0u8; 64];
        let pub_key: Cow<str>;
        let r = match &identity_type {
            CommunityIdentityType::Blind15(id) => {
                pub_key = Cow::Borrowed(id.as_str());
                unsafe {
                    session_blind15_sign(
                        identity.ed25519_sec_key().as_ptr(),
                        server_key.as_ptr(),
                        message_to_sign.as_ptr(),
                        message_to_sign.len(),
                        signature.as_mut_ptr(),
                    )
                }
            }

            CommunityIdentityType::Blind25(id) => {
                pub_key = Cow::Borrowed(id.as_str());
                unsafe {
                    session_blind25_sign(
                        identity.ed25519_sec_key().as_ptr(),
                        server_key.as_ptr(),
                        message_to_sign.as_ptr(),
                        message_to_sign.len(),
                        signature.as_mut_ptr(),
                    )
                }
            }

            CommunityIdentityType::Unblinded => {
                pub_key = Cow::Owned(format!("00{}", identity.ed25519_pub_key()));
                unsafe {
                    session_ed25519_sign(
                        identity.ed25519_sec_key().as_ptr(),
                        message_to_sign.as_ptr(),
                        message_to_sign.len(),
                        signature.as_mut_ptr(),
                    )
                }
            }

            CommunityIdentityType::None => unreachable!(),
        };

        ensure!(r, "Failed to sign message");

        parts
            .headers
            .insert("X-SOGS-Nonce", BASE64_STANDARD.encode(&nonce).parse()?);
        parts
            .headers
            .insert("X-SOGS-Timestamp", timestamp.to_string().parse()?);
        parts.headers.insert("X-SOGS-Pubkey", pub_key.parse()?);
        parts.headers.insert(
            "X-SOGS-Signature",
            BASE64_STANDARD.encode(&signature).parse()?,
        );

        self.executor
            .execute(
                server_key,
                HttpRPCRequest {
                    base_url: req.base_url,
                    request: Request::from_parts(parts, body),
                    can_batch: req.can_batch,
                },
            )
            .await
    }
}
