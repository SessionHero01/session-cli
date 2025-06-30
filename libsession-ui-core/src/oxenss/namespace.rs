use derive_more::Display;
use num_derive::{FromPrimitive, ToPrimitive};
use serde_repr::{Deserialize_repr, Serialize_repr};
use std::fmt::Debug;
use strum::EnumString;

#[derive(
    Debug,
    Clone,
    Copy,
    PartialEq,
    Eq,
    Display,
    EnumString,
    FromPrimitive,
    ToPrimitive,
    Serialize_repr,
    Deserialize_repr,
)]
#[repr(isize)]
pub enum MessageNamespace {
    UserMessages = 0,
    ContactsConfig = 3,
    UserProfileConfig = 2,
    ConvoInfoVolatileConfig = 4,
    UserGroupsConfig = 5,

    GroupMessages = 11,
    GroupKickedMessages = -11,
    GroupKeysConfig = 12,
    GroupInfoConfig = 13,
    GroupMemberConfig = 14,
}
