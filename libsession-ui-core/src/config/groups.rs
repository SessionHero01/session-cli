use super::Config;
use crate::bindings;
use crate::key::ed25519::ED25519SecKey;
use crate::oxenss::namespace::MessageNamespace;
use crate::session_id::GroupID;
use crate::utils::ffi::cwrapper::CWrapper;
use anyhow::Context;
use std::ffi::{CStr, c_char, c_int, c_uchar};
use std::ptr::{null, null_mut};

pub trait GroupConfig: From<CWrapper<bindings::config_object>> + Config {
    unsafe fn c_new(
        obj: *mut *mut bindings::config_object,
        group_ed25519_pub_key: *const c_uchar,
        group_ed25519_sec_key: *const c_uchar,
        dump: *const c_uchar,
        dump_len: usize,
        error: *mut c_char,
    ) -> c_int;

    fn new(
        group_id: &GroupID,
        sec_key: Option<&ED25519SecKey>,
        dump: &[u8],
    ) -> anyhow::Result<Self> {
        let mut config = null_mut();
        let mut error = [0; 256];
        let res = unsafe {
            Self::c_new(
                &mut config,
                group_id.pub_key().as_ptr(),
                sec_key.map_or(null(), |k| k.as_ptr()),
                if dump.is_empty() {
                    null()
                } else {
                    dump.as_ptr()
                },
                dump.len(),
                error.as_mut_ptr(),
            )
        };

        if res == 0 {
            CWrapper::new_with_destroyer(config, bindings::config_free)
                .map(Into::into)
                .context("Empty config")
        } else {
            let error = unsafe { CStr::from_ptr(error.as_ptr()) }
                .to_str()
                .unwrap_or("Invalid UTF-8");
            Err(anyhow::anyhow!("Failed to create config: {}", error))
        }
    }
}

macro_rules! define_group_config_type {
    ($name:ident, $init_func:ident, $ns:expr) => {
        crate::define_config_type!($name, $ns);

        impl GroupConfig for $name {
            unsafe fn c_new(
                obj: *mut *mut crate::bindings::config_object,
                group_ed25519_pub_key: *const std::ffi::c_uchar,
                group_ed25519_sec_key: *const std::ffi::c_uchar,
                dump: *const std::ffi::c_uchar,
                dump_len: usize,
                error: *mut std::ffi::c_char,
            ) -> std::ffi::c_int {
                unsafe {
                    crate::bindings::$init_func(
                        obj,
                        group_ed25519_pub_key,
                        group_ed25519_sec_key,
                        dump,
                        dump_len,
                        error,
                    )
                }
            }
        }
    };
}

define_group_config_type!(
    GroupInfoConfig,
    groups_info_init,
    MessageNamespace::GroupInfoConfig
);

define_group_config_type!(
    GroupMemberConfig,
    groups_members_init,
    MessageNamespace::GroupMemberConfig
);
