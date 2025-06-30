use super::{ConfigExt, notification_mode::NotificationMode};
use crate::app_setting::impl_sql_from_str_display;
use crate::bindings;
use crate::clock::Timestamp;
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519SecKey;
use crate::session_id::GroupID;
use crate::sogs_api::community_id::CommunityId;
use crate::utils::ffi::cwrapper::{CWrapper, OwnedCWrapper};
use crate::utils::ffi::string_ext::{CArrayExt, StringExt};
use anyhow::{Context, bail, ensure};
use derive_more::{Deref, DerefMut};
use num_traits::FromPrimitive;
use serde_with::{DeserializeFromStr, SerializeDisplay};
use std::ffi::{CStr, c_char};
use std::fmt::Debug;
use std::mem::MaybeUninit;
use strum::{Display, EnumString};
use url::Url;

struct GroupIter(CWrapper<bindings::user_groups_iterator>);

pub struct LegacyGroupInfo(OwnedCWrapper<bindings::ugroups_legacy_group_info>);

#[derive(Deref, DerefMut, Eq, PartialEq, Clone)]
pub struct GroupInfo(bindings::ugroups_group_info);

#[derive(Deref, DerefMut, Clone)]
pub struct CommunityInfo(bindings::ugroups_community_info);

#[derive(
    EnumString,
    Display,
    Debug,
    Clone,
    Copy,
    PartialEq,
    Eq,
    Hash,
    SerializeDisplay,
    DeserializeFromStr,
)]
#[strum(serialize_all = "snake_case")]
pub enum GroupType {
    Legacy,
    Group,
    Community,
}

impl_sql_from_str_display!(GroupType);

pub enum Group {
    Legacy(LegacyGroupInfo),
    Group(GroupInfo),
    Community(CommunityInfo),
}

impl Group {
    pub fn id(&self) -> Option<String> {
        match self {
            Self::Legacy(_) => None,
            Self::Group(info) => info.group_id().map(|id| id.to_string()),
            Self::Community(info) => info.id().map(|id| id.to_string()),
        }
    }

    pub fn group_type(&self) -> GroupType {
        match self {
            Self::Legacy(_) => GroupType::Legacy,
            Self::Group(_) => GroupType::Group,
            Self::Community(_) => GroupType::Community,
        }
    }
}

impl Debug for Group {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Legacy(_) => f.write_str("LegacyGroupInfo()"),
            Self::Group(info) => write!(f, "GroupInfo({info:?})"),
            Self::Community(info) => write!(f, "CommunityInfo({info:?})"),
        }
    }
}

pub type GroupAuthData = [u8; 100];

impl GroupInfo {
    pub fn group_id(&self) -> Option<GroupID> {
        let id = unsafe { CStr::from_ptr(self.0.id.as_ptr()) }
            .to_str()
            .ok()?;
        id.parse().ok()
    }

    pub fn set_group_id(&mut self, group_id: &GroupID) {
        self.0.id.as_mut_slice().copy_from_slice(unsafe {
            std::mem::transmute(group_id.as_c_str().to_bytes_with_nul())
        });
    }

    pub fn name(&self) -> &str {
        unsafe { CStr::from_ptr(self.0.name.as_ptr()) }
            .to_str()
            .unwrap()
    }

    pub fn set_name(&mut self, name: &str) -> anyhow::Result<()> {
        ensure!(self.0.name.write_cstr(name), "Name is too long");
        Ok(())
    }

    pub fn sec_key(&self) -> Option<ED25519SecKey> {
        if self.0.have_secretkey {
            Some(self.0.secretkey.into())
        } else {
            None
        }
    }

    pub fn clear_sec_key(&mut self) {
        self.0.secretkey.fill(0);
        self.0.have_secretkey = false;
    }

    pub fn auth_data(&self) -> Option<&GroupAuthData> {
        if self.have_auth_data {
            Some(&self.auth_data)
        } else {
            None
        }
    }

    pub fn clear_auth_data(&mut self) {
        self.auth_data.fill(0);
        self.have_auth_data = false;
    }

    pub fn joined_at(&self) -> Option<Timestamp> {
        Timestamp::from_mills(self.joined_at)
    }

    pub fn mute_until(&self) -> Option<Timestamp> {
        Timestamp::from_mills(self.mute_until)
    }

    pub fn is_kicked(&self) -> bool {
        unsafe { bindings::ugroups_group_is_kicked(&self.0) }
    }

    pub fn set_kicked(&mut self) {
        unsafe { bindings::ugroups_group_set_kicked(&mut self.0) }
    }

    pub fn notification_mode(&self) -> Option<NotificationMode> {
        NotificationMode::from_u32(self.notifications)
    }
}

impl Debug for GroupInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("GroupInfo")
            .field("group_id", &self.group_id())
            .field("name", &self.name())
            .field("sec_key", &self.sec_key())
            .field("auth_data", &self.auth_data())
            .field("joined_at", &self.joined_at())
            .field("mute_until", &self.mute_until())
            .field("is_kicked", &self.is_kicked())
            .field("notifications", &self.notification_mode())
            .finish()
    }
}

impl CommunityInfo {
    pub fn base_url(&self) -> &str {
        self.base_url.cstr_to_str().unwrap_or_default()
    }

    pub fn set_base_url(&mut self, base_url: &str) {
        let len = base_url.len().min(self.0.base_url.len() - 1);
        (&mut self.0.base_url.as_mut_slice()[..len]).copy_from_slice(
            &unsafe { std::mem::transmute::<_, &[c_char]>(base_url.as_bytes()) }[..len],
        );
        self.0.base_url[len] = 0;
    }

    pub fn url_as_key(&self) -> anyhow::Result<Url> {
        let url: Url = self.base_url().parse()?;
        url.join(self.room()).context("Failed to join room name")
    }

    pub fn id(&self) -> Option<CommunityId> {
        CommunityId::new_from_strings(self.base_url(), self.room()).ok()
    }

    pub fn room(&self) -> &str {
        self.room.cstr_to_str().unwrap_or_default()
    }

    pub fn set_room(&mut self, room: &str) -> anyhow::Result<()> {
        if !self.room.write_cstr(room) {
            bail!(
                "Room name is too long, right now only {} is supported",
                self.room.len() - 1
            );
        }

        Ok(())
    }

    pub fn notification_mode(&self) -> Option<NotificationMode> {
        NotificationMode::from_u32(self.notifications)
    }
}

impl Debug for CommunityInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("CommunityInfo")
            .field("base_url", &self.base_url())
            .field("room", &self.room())
            .finish()
    }
}

union GroupUnion {
    legacy: bindings::ugroups_legacy_group_info,
    group: bindings::ugroups_group_info,
    community: bindings::ugroups_community_info,
}

impl Iterator for GroupIter {
    type Item = Group;

    fn next(&mut self) -> Option<Self::Item> {
        let ptr = self.0.as_mut_ptr();
        unsafe {
            if bindings::user_groups_iterator_done(ptr) {
                return None;
            }

            let mut group_info: GroupUnion = MaybeUninit::zeroed().assume_init();

            let ret = if bindings::user_groups_it_is_legacy_group(ptr, &mut group_info.legacy) {
                Some(Group::Legacy(LegacyGroupInfo(OwnedCWrapper::new(
                    group_info.legacy,
                    bindings::ugroups_legacy_group_free,
                ))))
            } else if bindings::user_groups_it_is_group(ptr, &mut group_info.group) {
                Some(Group::Group(GroupInfo(group_info.group)))
            } else if bindings::user_groups_it_is_community(ptr, &mut group_info.community) {
                Some(Group::Community(CommunityInfo(group_info.community)))
            } else {
                None
            };

            bindings::user_groups_iterator_advance(ptr);

            ret
        }
    }
}

impl super::UserGroupsConfig {
    pub fn get_groups(&self) -> impl Iterator<Item = Group> + 'static {
        unsafe {
            let iter = bindings::user_groups_iterator_new(self.as_ref() as *const _);
            CWrapper::new_with_destroyer(iter, bindings::user_groups_iterator_free)
                .into_iter()
                .flat_map(GroupIter)
        }
    }

    pub fn get_group(&self, id: &GroupID) -> Option<GroupInfo> {
        self.get_groups()
            .filter_map(|g| match g {
                Group::Group(info) => {
                    if info.group_id().as_ref() == Some(id) {
                        Some(info)
                    } else {
                        None
                    }
                }
                _ => None,
            })
            .next()
    }

    pub fn create_group(&self) -> anyhow::Result<GroupInfo> {
        unsafe {
            let mut out: bindings::ugroups_group_info = MaybeUninit::zeroed().assume_init();
            if bindings::user_groups_create_group(self.as_ref() as *const _, &mut out) {
                Ok(GroupInfo(out))
            } else {
                bail!("Failed to create group");
            }
        }
    }

    pub fn get_or_construct_group(&mut self, group_id: &str) -> anyhow::Result<GroupInfo> {
        unsafe {
            let group_id = std::ffi::CString::new(group_id)?;
            let mut out: bindings::ugroups_group_info = MaybeUninit::zeroed().assume_init();
            if bindings::user_groups_get_or_construct_group(
                self.as_mut() as *mut _,
                &mut out,
                group_id.as_ptr(),
            ) {
                Ok(GroupInfo(out))
            } else {
                bail!(
                    "Failed to get or create group, last error = {:?}",
                    self.last_error()
                );
            }
        }
    }

    pub fn get_or_construct_community(
        &mut self,
        id: &CommunityId,
        pub_key: &Curve25519PubKey,
    ) -> anyhow::Result<CommunityInfo> {
        unsafe {
            let mut out: bindings::ugroups_community_info = MaybeUninit::zeroed().assume_init();
            if bindings::user_groups_get_or_construct_community(
                self.as_mut() as *mut _,
                &mut out,
                id.server_url().as_str().to_cstr().as_ref().as_ptr(),
                id.room().to_cstr().as_ref().as_ptr(),
                pub_key.as_ptr(),
            ) {
                Ok(CommunityInfo(out))
            } else {
                bail!(
                    "Failed to get or create community, last error = {:?}",
                    self.last_error()
                );
            }
        }
    }

    pub fn set_group(&mut self, g: &Group) -> anyhow::Result<()> {
        let ptr = self.as_mut() as *mut _;
        unsafe {
            match g {
                Group::Group(GroupInfo(info)) => {
                    bindings::user_groups_set_group(ptr, info);
                }

                Group::Legacy(LegacyGroupInfo(info)) => {
                    bindings::user_groups_set_legacy_group(ptr, info.deref());
                }

                Group::Community(CommunityInfo(info)) => {
                    bindings::user_groups_set_community(ptr, info);
                }
            }
        };

        if let Some(err) = self.last_error() {
            bail!("Failed to set group, last error = {:?}", err);
        } else {
            Ok(())
        }
    }

    pub fn remove_group(&mut self, group_id: &GroupID) {
        unsafe {
            bindings::user_groups_erase_group(
                self.as_mut() as *mut _,
                group_id.as_c_str().as_ptr(),
            );
        }
    }
}

impl Debug for super::UserGroupsConfig {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_list().entries(self.get_groups()).finish()
    }
}
