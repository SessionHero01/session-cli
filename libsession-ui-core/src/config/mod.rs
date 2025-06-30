use crate::bindings;

mod config_auto_impl;
pub mod contacts;
pub mod convo_info;
mod group_info;
mod group_keys;
mod group_members;
mod groups;
mod individuals;
mod notification_mode;
mod user_groups;
pub mod user_profile;
mod wrapper;

use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::retrieve::Message;
pub use group_keys::*;
pub use groups::*;
pub use individuals::*;
pub use user_groups::*;
pub use wrapper::*;

pub use notification_mode::NotificationMode;

pub trait NamedConfig {
    const CONFIG_TYPE_NAME: &'static str;
    const NAMESPACE: MessageNamespace;
}

pub struct ConfigPush {
    pub seq: bindings::seqno_t,
    pub data: Vec<Vec<u8>>,
    pub obsolete_hashes: Vec<String>,
}

pub trait Config: NamedConfig {
    fn config_type_name(&self) -> &str {
        <Self as NamedConfig>::CONFIG_TYPE_NAME
    }

    fn merge<'a>(&mut self, messages: &'a [Message]) -> Vec<anyhow::Result<&'a Message>>;

    fn active_hashes(&self) -> Vec<String>;

    fn push(&mut self) -> anyhow::Result<Option<ConfigPush>>;

    fn confirm_pushed(&mut self, seq: bindings::seqno_t, msg_hash: &[&str]);

    fn needs_push(&self) -> bool;

    fn needs_dump(&self) -> bool;

    fn dump(&mut self) -> Option<impl AsRef<[u8]> + 'static>;
}

trait ConfigExt: Config {
    fn last_error(&self) -> Option<&str>;
}

#[macro_export]
macro_rules! define_config_type {
    ($name:ident, $ns:expr) => {
        pub struct $name(crate::utils::ffi::cwrapper::CWrapper<crate::bindings::config_object>);

        impl crate::config::NamedConfig for $name {
            const CONFIG_TYPE_NAME: &'static str = stringify!($name);
            const NAMESPACE: crate::oxenss::namespace::MessageNamespace = $ns;
        }

        impl AsRef<crate::bindings::config_object> for $name {
            fn as_ref(&self) -> &crate::bindings::config_object {
                self.0.as_ref()
            }
        }

        impl AsMut<crate::bindings::config_object> for $name {
            fn as_mut(&mut self) -> &mut crate::bindings::config_object {
                self.0.as_mut()
            }
        }

        impl From<crate::utils::ffi::cwrapper::CWrapper<crate::bindings::config_object>> for $name {
            fn from(
                wrapper: crate::utils::ffi::cwrapper::CWrapper<crate::bindings::config_object>,
            ) -> Self {
                $name(wrapper)
            }
        }
    };
}

use config_auto_impl::config_string_list_as_slice;
