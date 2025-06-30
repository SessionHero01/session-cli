use super::{ConfigExt, GroupInfoConfig};
use crate::bindings;
use crate::clock::Timestamp;
use crate::config::user_profile::UserProfilePic;
use crate::utils::ffi::string_ext::StringExt;
use anyhow::bail;
use std::ffi::CStr;
use std::fmt::Debug;

impl GroupInfoConfig {
    pub fn name(&self) -> &str {
        unsafe {
            let name = bindings::groups_info_get_name(self.as_ref() as *const _);
            if name.is_null() {
                return "";
            }

            CStr::from_ptr(name).to_str().unwrap_or_default()
        }
    }

    pub fn set_name(&mut self, name: &str) -> anyhow::Result<()> {
        if unsafe {
            bindings::groups_info_set_name(
                self.as_mut() as *mut _,
                name.to_cstr().as_ref().as_ptr(),
            )
        } != 0
        {
            bail!(
                "Error setting name: {}",
                self.last_error().unwrap_or("Unknown error")
            )
        }

        Ok(())
    }

    pub fn description(&self) -> &str {
        unsafe {
            let desc = bindings::groups_info_get_description(self.as_ref() as *const _);
            if desc.is_null() {
                return "";
            }

            CStr::from_ptr(desc).to_str().unwrap_or_default()
        }
    }

    pub fn delete_attach_before(&self) -> Option<Timestamp> {
        Timestamp::from_mills(unsafe {
            bindings::groups_info_get_attach_delete_before(self.as_ref() as *const _)
        })
    }

    pub fn delete_before(&self) -> Option<Timestamp> {
        Timestamp::from_mills(unsafe {
            bindings::groups_info_get_delete_before(self.as_ref() as *const _)
        })
    }

    pub fn expiry_timer(&self) -> i32 {
        unsafe { bindings::groups_info_get_expiry_timer(self.as_ref() as *const _) as i32 }
    }

    pub fn profile_pic(&self) -> bindings::user_profile_pic {
        unsafe { bindings::groups_info_get_pic(self.as_ref() as *const _) }
    }

    pub fn set_profile_pic(&mut self, pic: UserProfilePic) -> anyhow::Result<()> {
        let pic = pic.try_into()?;

        if unsafe { bindings::groups_info_set_pic(self.as_mut(), pic) } != 0 {
            bail!(
                "Error setting profile pic: {}",
                self.last_error().unwrap_or("Unknown error")
            )
        }

        Ok(())
    }

    pub fn created(&self) -> Option<Timestamp> {
        let created = unsafe { bindings::groups_info_get_created(self.as_ref() as *const _) };
        if created == 0 {
            None
        } else {
            Timestamp::from_mills(created)
        }
    }
}

impl Debug for GroupInfoConfig {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("GroupInfoConfig")
            .field("name", &self.name())
            .field("description", &self.description())
            .field("delete_attach_before", &self.delete_attach_before())
            .field("delete_before", &self.delete_before())
            .field("expiry_timer", &self.expiry_timer())
            .field("profile_pic", &self.profile_pic())
            .field("created", &self.created())
            .finish()
    }
}
