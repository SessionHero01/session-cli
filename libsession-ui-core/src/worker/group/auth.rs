use crate::config::{ConfigWrapper, Group, GroupKeys, SubaccountAuth, UserGroupsConfig};
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::network::swarm_auth::SwarmAuth;
use crate::session_id::{GroupID, SessionID};
use crate::utils::base64::Base64;
use anyhow::{Context, bail, ensure};
use serde::Serialize;
use std::borrow::Cow;

#[derive(Serialize)]
#[serde(untagged)]
enum GroupSignature {
    AdminSignature { signature: Base64<[u8; 64]> },
    MemberSignature(SubaccountAuth),
}

pub struct GroupSwarmAuth {
    pub id: GroupID,
    pub group_keys: ConfigWrapper<GroupKeys>,
    pub user_groups_config: ConfigWrapper<UserGroupsConfig>,
}

impl SwarmAuth for GroupSwarmAuth {
    type IDType = GroupID;

    fn sign(&self, payload: &[u8]) -> anyhow::Result<impl Serialize + 'static> {
        let group_info = self
            .user_groups_config
            .borrow()
            .get_groups()
            .filter_map(|g| match g {
                Group::Group(info) if info.group_id().as_ref() == Some(&self.id) => Some(info),
                _ => None,
            })
            .next()
            .context("Given group not found")?;

        if let Some(sec_key) = group_info.sec_key() {
            Ok(GroupSignature::AdminSignature {
                signature: Base64(sec_key.sign(payload)),
            })
        } else if let Some(auth_data) = group_info.auth_data() {
            Ok(GroupSignature::MemberSignature(
                self.group_keys.borrow().sub_key_sign(payload, auth_data)?,
            ))
        } else {
            bail!("No admin key or auth data found for group {:?}", self.id);
        }
    }

    fn decrypt(&self, payload: &[u8]) -> anyhow::Result<(SessionID, impl AsRef<[u8]> + 'static)> {
        self.group_keys
            .borrow()
            .decrypt_message(payload)
            .context("Error decrypting message")
    }

    fn encrypt(
        &self,
        payload: &[u8],
        for_other: Option<&Curve25519PubKey>,
    ) -> anyhow::Result<impl AsRef<[u8]> + 'static> {
        ensure!(
            for_other.is_none(),
            "Group encryption does not encrypt for others"
        );

        self.group_keys
            .borrow()
            .encrypt_message(payload)
            .context("Error encrypting message")
    }

    fn session_id(&self) -> &GroupID {
        &self.id
    }

    fn ed25519_pub_key(&self) -> Option<Cow<ED25519PubKey>> {
        None
    }
}
