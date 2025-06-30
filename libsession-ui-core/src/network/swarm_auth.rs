use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::session_id::SessionID;
use serde::Serialize;
use std::borrow::Cow;

pub trait SwarmAuth {
    type IDType;

    fn sign(&self, payload: &[u8]) -> anyhow::Result<impl Serialize + 'static>;
    fn decrypt(&self, payload: &[u8]) -> anyhow::Result<(SessionID, impl AsRef<[u8]> + 'static)>;
    fn encrypt(
        &self,
        payload: &[u8],
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<impl AsRef<[u8]> + 'static>;
    fn session_id(&self) -> &Self::IDType;
    fn ed25519_pub_key(&self) -> Option<Cow<ED25519PubKey>>;
}
