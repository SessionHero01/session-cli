use crate::crypto::{decrypt_incoming, encrypt_for_recipient};
use crate::key::curve25519::{Curve25519PubKey, Curve25519SecKey};
use crate::key::ed25519::ED25519PubKey;
use crate::key::ed25519::{self, ED25519SecKey};
use crate::mnemonic::ENGLISH;
use crate::network::swarm_auth::SwarmAuth;
use crate::session_id::{IndividualID, SessionID};
use crate::utils::base64::Base64;
use anyhow::Context;
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use std::borrow::Cow;
use std::fmt::{Debug, Formatter};

#[derive(Clone, Eq, PartialEq)]
pub struct Identity {
    sec_key: Curve25519SecKey,
    ed25519_key_pair: (ED25519PubKey, ED25519SecKey),
    session_id: IndividualID,
}

impl Debug for Identity {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "Identity({:?})", self.session_id)
    }
}

#[derive(Serialize, Deserialize)]
struct IdentitySerdeValue<'a> {
    ed25519_pub_key: Cow<'a, ED25519PubKey>,
    ed25519_sec_key: Cow<'a, ED25519SecKey>,
    session_id: Cow<'a, IndividualID>,
}

impl Serialize for Identity {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        IdentitySerdeValue {
            ed25519_pub_key: Cow::Borrowed(&self.ed25519_key_pair.0),
            ed25519_sec_key: Cow::Borrowed(&self.ed25519_key_pair.1),
            session_id: Cow::Borrowed(&self.session_id),
        }
        .serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for Identity {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        let value: IdentitySerdeValue<'static> = Deserialize::deserialize(deserializer)?;
        Ok(Self::new((
            value.ed25519_pub_key.into_owned(),
            value.ed25519_sec_key.into_owned(),
        )))
    }
}

impl Identity {
    pub fn new_unchecked(
        sec_key: Curve25519SecKey,
        ed25519_key_pair: (ED25519PubKey, ED25519SecKey),
        session_id: IndividualID,
    ) -> Self {
        Self {
            sec_key,
            ed25519_key_pair,
            session_id,
        }
    }

    pub fn new(ed25519_key_pair: (ED25519PubKey, ED25519SecKey)) -> Self {
        let sec_key = ed25519_key_pair.1.to_curve25519();
        let session_id = IndividualID::from(ed25519_key_pair.0.to_curve25519());
        Self {
            sec_key,
            session_id,
            ed25519_key_pair,
        }
    }

    pub fn from_mnemonic(mnemonic: &str) -> anyhow::Result<Self> {
        let seed = hex::decode(
            crate::mnemonic::decode(&mnemonic, &ENGLISH).context("Error decode mnemonic")?,
        )
        .context("Error decode mnemonic as hex")?;

        let ed25519_key_pair = ed25519::gen_pair_from_seed(ed25519::pad_ed25519_seed(&seed));

        Ok(Self {
            sec_key: ed25519_key_pair.1.to_curve25519(),
            session_id: IndividualID::from(ed25519_key_pair.0.to_curve25519()),
            ed25519_key_pair,
        })
    }

    pub fn mnemonic(&self) -> String {
        crate::mnemonic::encode(&hex::encode(self.ed25519_sec_key().seed()), &ENGLISH)
    }

    pub fn sec_key(&self) -> &Curve25519SecKey {
        &self.sec_key
    }

    pub fn ed25519_pub_key(&self) -> &ED25519PubKey {
        &self.ed25519_key_pair.0
    }

    pub fn ed25519_sec_key(&self) -> &ED25519SecKey {
        &self.ed25519_key_pair.1
    }

    pub fn individual_id(&self) -> &IndividualID {
        &self.session_id
    }

    pub fn generate() -> Self {
        let ed25519_key_pair = ed25519::gen_pair();
        Self {
            sec_key: ed25519_key_pair.1.to_curve25519(),
            session_id: IndividualID::from(ed25519_key_pair.0.to_curve25519()),
            ed25519_key_pair,
        }
    }
}

#[derive(Serialize)]
struct IdentitySignature {
    signature: Base64<[u8; 64]>,
}

impl SwarmAuth for Identity {
    type IDType = IndividualID;

    fn sign(&self, payload: &[u8]) -> anyhow::Result<impl Serialize + 'static> {
        Ok(IdentitySignature {
            signature: Base64(self.ed25519_sec_key().sign(payload)),
        })
    }

    fn decrypt(&self, payload: &[u8]) -> anyhow::Result<(SessionID, impl AsRef<[u8]> + 'static)> {
        decrypt_incoming(self.ed25519_sec_key(), payload)
    }

    fn encrypt(
        &self,
        payload: &[u8],
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<impl AsRef<[u8]> + 'static> {
        Ok(if let Some(for_other) = for_other {
            encrypt_for_recipient(for_other, self.ed25519_sec_key(), payload)
        } else {
            encrypt_for_recipient(
                &self.ed25519_pub_key().to_curve25519(),
                self.ed25519_sec_key(),
                payload,
            )
        })
    }

    fn session_id(&self) -> &IndividualID {
        self.individual_id()
    }

    fn ed25519_pub_key(&self) -> Option<Cow<ED25519PubKey>> {
        Some(Cow::Borrowed(&self.ed25519_key_pair.0))
    }
}
