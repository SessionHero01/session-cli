use crate::bindings;
use crate::clock::Timestamp;
use crate::utils::base64::Base64;
use crate::utils::ffi::string_ext::CArrayExt;
use crate::utils::http::base_url::HttpBaseUrl;
use anyhow::ensure;
use base64::prelude::BASE64_STANDARD;
use base64::Engine;
use derive_more::Debug;
use libsession_protos::protos::EncryptedFile;
use serde::{Deserialize, Serialize};
use std::ffi::{CStr, CString};
use std::mem::MaybeUninit;
use std::ptr::null;

pub trait UserProfilePicExt {
    fn to_encrypted_file(&self) -> Option<EncryptedFile>;
}

impl UserProfilePicExt for bindings::user_profile_pic {
    fn to_encrypted_file(&self) -> Option<EncryptedFile> {
        let url = self.url.cstr_to_str()?;
        if url.is_empty() {
            return None;
        }
        let key = BASE64_STANDARD.encode(self.key.as_slice());
        Some(EncryptedFile {
            url: url.to_string(),
            key,
        })
    }
}

#[derive(Debug, Clone, Eq, PartialEq, Serialize, Deserialize)]
pub struct UserProfilePic {
    url: HttpBaseUrl,
    #[debug(skip)]
    key: Base64<[u8; 32]>,
}

impl Into<EncryptedFile> for UserProfilePic {
    fn into(self) -> EncryptedFile {
        EncryptedFile {
            url: self.url.to_string(),
            key: self.key.to_string(),
        }
    }
}

impl UserProfilePic {
    pub(super) fn new(pic: bindings::user_profile_pic) -> Option<Self> {
        let url = HttpBaseUrl::new(pic.url.cstr_to_str()?).ok()?;
        Some(Self {
            url,
            key: Base64(pic.key),
        })
    }
}

impl TryInto<bindings::user_profile_pic> for UserProfilePic {
    type Error = anyhow::Error;

    fn try_into(self) -> anyhow::Result<bindings::user_profile_pic> {
        let mut pic = bindings::user_profile_pic {
            url: [0; 224],
            key: *self.key,
        };

        ensure!(pic.url.write_cstr(self.url.as_str()), "Url is too long");
        Ok(pic)
    }
}

impl super::UserProfileConfig {
    pub fn profile_pic(&self) -> Option<UserProfilePic> {
        UserProfilePic::new(unsafe { bindings::user_profile_get_pic(self.as_ref() as *const _) })
    }

    pub fn set_profile_pic(&mut self, pic: Option<UserProfilePic>) -> anyhow::Result<()> {
        let Some(pic) = pic else {
            unsafe {
                bindings::user_profile_set_pic(self.as_mut(), MaybeUninit::zeroed().assume_init())
            };
            return Ok(());
        };

        let pic = pic.try_into()?;
        ensure!(
            unsafe { bindings::user_profile_set_pic(self.as_mut(), pic) } == 0,
            "Failed to set profile pic"
        );

        Ok(())
    }

    pub fn name(&self) -> &str {
        unsafe {
            let ptr = bindings::user_profile_get_name(self.as_ref() as *const _);

            if ptr == null() {
                return "";
            }

            CStr::from_ptr(ptr).to_str().unwrap_or_default()
        }
    }

    pub fn set_name(&mut self, name: &str) -> anyhow::Result<()> {
        ensure!(
            unsafe {
                bindings::user_profile_set_name(self.as_mut(), CString::new(name)?.as_ptr()) == 0
            },
            "Failed to set name"
        );

        Ok(())
    }

    pub fn accepts_blinded_msgreqs(&self) -> Option<bool> {
        match unsafe { bindings::user_profile_get_blinded_msgreqs(self.as_ref() as *const _) } {
            -1 => None,
            0 => Some(false),
            _ => Some(true),
        }
    }

    pub fn nts_expiry(&self) -> Option<Timestamp> {
        Timestamp::from_mills(unsafe {
            bindings::user_profile_get_nts_expiry(self.as_ref() as *const _)
        })
    }

    pub fn nts_priority(&self) -> isize {
        unsafe { bindings::user_profile_get_nts_priority(self.as_ref() as *const _) as isize }
    }
}

impl std::fmt::Debug for super::UserProfileConfig {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("UserProfileConfig")
            .field("name", &self.name())
            .field("profile_pic", &self.profile_pic())
            .field("accepts_blinded_msgreqs", &self.accepts_blinded_msgreqs())
            .field("nts_expiry", &self.nts_expiry())
            .field("nts_priority", &self.nts_priority())
            .finish()
    }
}
