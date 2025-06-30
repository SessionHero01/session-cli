use crate::app_setting::impl_sql_from_str_display;
use crate::bindings;
use crate::clock::Timestamp;
use crate::sogs_api::community_id::CommunityId;
use crate::utils::ffi::cwrapper::CWrapper;
use crate::utils::ffi::string_ext::CArrayExt;
use serde_with::{DeserializeFromStr, SerializeDisplay};
use std::borrow::Cow;
use std::fmt::Debug;
use std::mem::MaybeUninit;
use strum::{Display, EnumString};

#[derive(
    EnumString,
    Display,
    Hash,
    Eq,
    PartialEq,
    Debug,
    Clone,
    Copy,
    SerializeDisplay,
    DeserializeFromStr,
)]
#[strum(serialize_all = "snake_case")]
pub enum ConvoInfoType {
    OneToOne,
    Group,
    Community,
    Legacy,
}

impl_sql_from_str_display!(ConvoInfoType);

pub enum ConvoInfoItem {
    OneToOne(bindings::convo_info_volatile_1to1),
    Group(bindings::convo_info_volatile_group),
    Community(bindings::convo_info_volatile_community),
    Legacy(bindings::convo_info_volatile_legacy_group),
}

union ConvoInfoUnion {
    one_to_one: bindings::convo_info_volatile_1to1,
    group: bindings::convo_info_volatile_group,
    community: bindings::convo_info_volatile_community,
    legacy: bindings::convo_info_volatile_legacy_group,
}

impl ConvoInfoItem {
    pub fn id(&self) -> Option<Cow<str>> {
        match self {
            Self::OneToOne(info) => info.session_id.cstr_to_str().map(Cow::Borrowed),
            Self::Group(info) => info.group_id.cstr_to_str().map(Cow::Borrowed),
            Self::Legacy(info) => info.group_id.cstr_to_str().map(Cow::Borrowed),
            Self::Community(info) => Some(Cow::Owned(
                CommunityId::new_from_strings(
                    info.base_url.cstr_to_str()?,
                    info.room.cstr_to_str()?,
                )
                .ok()?
                .to_string(),
            )),
        }
    }

    pub fn last_read(&self) -> Option<Timestamp> {
        Timestamp::from_mills(match self {
            Self::OneToOne(info) => info.last_read,
            Self::Group(info) => info.last_read,
            Self::Legacy(info) => info.last_read,
            Self::Community(info) => info.last_read,
        })
    }

    pub fn unread(&self) -> bool {
        match self {
            Self::OneToOne(info) => info.unread,
            Self::Group(info) => info.unread,
            Self::Legacy(info) => info.unread,
            Self::Community(info) => info.unread,
        }
    }

    pub fn item_type(&self) -> ConvoInfoType {
        match self {
            Self::OneToOne(_) => ConvoInfoType::OneToOne,
            Self::Group(_) => ConvoInfoType::Group,
            Self::Legacy(_) => ConvoInfoType::Legacy,
            Self::Community(_) => ConvoInfoType::Community,
        }
    }
}

impl Debug for ConvoInfoItem {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ConvoInfoItem")
            .field("id", &self.id())
            .field("last_read", &self.last_read())
            .field("unread", &self.unread())
            .field("item_type", &self.item_type())
            .finish()
    }
}

struct ConvoInfoIterator(CWrapper<bindings::convo_info_volatile_iterator>);

impl Iterator for ConvoInfoIterator {
    type Item = ConvoInfoItem;

    fn next(&mut self) -> Option<Self::Item> {
        unsafe {
            if bindings::convo_info_volatile_iterator_done(self.0.as_mut_ptr()) {
                return None;
            }

            let mut item: ConvoInfoUnion = MaybeUninit::uninit().assume_init();
            let result = if bindings::convo_info_volatile_it_is_1to1(
                self.0.as_mut_ptr(),
                &mut item.one_to_one,
            ) {
                ConvoInfoItem::OneToOne(item.one_to_one)
            } else if bindings::convo_info_volatile_it_is_group(
                self.0.as_mut_ptr(),
                &mut item.group,
            ) {
                ConvoInfoItem::Group(item.group)
            } else if bindings::convo_info_volatile_it_is_community(
                self.0.as_mut_ptr(),
                &mut item.community,
            ) {
                ConvoInfoItem::Community(item.community)
            } else if bindings::convo_info_volatile_it_is_legacy_group(
                self.0.as_mut_ptr(),
                &mut item.legacy,
            ) {
                ConvoInfoItem::Legacy(item.legacy)
            } else {
                return None;
            };

            bindings::convo_info_volatile_iterator_advance(self.0.as_mut_ptr());
            Some(result)
        }
    }
}

impl super::ConvoInfoVolatileConfig {
    pub fn all(&self) -> impl Iterator<Item = ConvoInfoItem> + 'static {
        CWrapper::new_with_destroyer(
            unsafe { bindings::convo_info_volatile_iterator_new(self.as_ref() as *const _) },
            bindings::convo_info_volatile_iterator_free,
        )
        .into_iter()
        .flat_map(ConvoInfoIterator)
    }
}

impl Debug for super::ConvoInfoVolatileConfig {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_list().entries(self.all()).finish()
    }
}
