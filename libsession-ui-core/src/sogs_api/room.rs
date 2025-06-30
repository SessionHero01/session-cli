use crate::app_setting::{AppSetting, impl_sql_for_serde};
use crate::clock::UnixTimestampFloat;
use crate::session_id::SessionID;
use crate::sogs_api::community_id::CommunityId;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, Eq, PartialEq)]
pub struct RoomInfo {
    pub name: String,
    #[serde(default)]
    pub description: String,
    pub created: UnixTimestampFloat,
    pub active_users: usize,
    pub image_id: Option<usize>,
    pub moderators: Vec<SessionID>,
    pub admins: Vec<SessionID>,
    #[serde(default)]
    pub hidden_moderators: Vec<SessionID>,
    #[serde(default)]
    pub hidden_admins: Vec<SessionID>,
    pub read: bool,
    pub write: bool,
    pub upload: bool,
    #[serde(default)]
    pub moderator: bool,
    #[serde(default)]
    pub admin: bool,
    pub info_updates: i64,
}

impl AppSetting for RoomInfo {
    const NAME: &'static str = "community_room_info";
    type IDType<'a> = CommunityId;
}

impl_sql_for_serde!(RoomInfo);
