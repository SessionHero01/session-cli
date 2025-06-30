use super::bindings;
use crate::app_setting::impl_sql_from_str_display;
use num_derive::{FromPrimitive, ToPrimitive};
use strum::{Display, EnumString, IntoStaticStr};

#[derive(
    FromPrimitive,
    ToPrimitive,
    Debug,
    Display,
    PartialEq,
    Eq,
    Copy,
    Clone,
    EnumString,
    IntoStaticStr,
)]
#[repr(usize)]
pub enum NotificationMode {
    Default = bindings::CONVO_NOTIFY_MODE_CONVO_NOTIFY_DEFAULT as usize,
    All = bindings::CONVO_NOTIFY_MODE_CONVO_NOTIFY_ALL as usize,
    Disabled = bindings::CONVO_NOTIFY_MODE_CONVO_NOTIFY_DISABLED as usize,
    MentionsOnly = bindings::CONVO_NOTIFY_MODE_CONVO_NOTIFY_MENTIONS_ONLY as usize,
}

impl_sql_from_str_display!(NotificationMode);
