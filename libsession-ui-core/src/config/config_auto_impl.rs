use super::{Config, ConfigPush, NamedConfig};
use crate::bindings;
use crate::oxenss::retrieve::Message;
use crate::utils::ffi::cwrapper::{CArrayWrapper, CWrapper};
use anyhow::{Context, format_err};
use itertools::Itertools;
use std::ffi::{CStr, CString, c_char};
use std::ptr::null_mut;

pub(super) fn config_string_list_as_slice(list: &bindings::config_string_list) -> &[*mut c_char] {
    unsafe { std::slice::from_raw_parts(list.value, list.len) }
}

impl<T: AsMut<bindings::config_object> + AsRef<bindings::config_object> + NamedConfig> Config
    for T
{
    fn merge<'a>(&mut self, messages: &'a [Message]) -> Vec<anyhow::Result<&'a Message>> {
        let mut error = [0u8; 256];

        messages
            .into_iter()
            .filter_map(|msg| {
                let rc = unsafe {
                    bindings::session_config_merge(
                        self.as_mut(),
                        msg.data.as_ptr(),
                        msg.data.len(),
                        msg.hash.as_ptr() as *const _,
                        msg.hash.len(),
                        error.as_mut_ptr() as *mut _,
                        error.len(),
                    )
                };

                if rc == 0 {
                    None
                } else if rc < 0 {
                    let error = CStr::from_bytes_until_nul(&error)
                        .ok()
                        .and_then(|s| s.to_str().ok())
                        .unwrap_or("Unknown error");
                    Some(Err(format_err!("{error}")))
                } else {
                    Some(Ok(msg))
                }
            })
            .collect()
    }

    fn active_hashes(&self) -> Vec<String> {
        let hashes = unsafe { bindings::config_active_hashes(self.as_ref()) };

        CWrapper::new(hashes)
            .iter()
            .flat_map(|c| {
                config_string_list_as_slice(c.as_ref())
                    .into_iter()
                    .map(|c| unsafe { CStr::from_ptr(*c) })
            })
            .filter_map(|s| s.to_str().ok())
            .map(|s| s.to_string())
            .collect()
    }

    fn push(&mut self) -> anyhow::Result<Option<ConfigPush>> {
        if !self.needs_push() {
            return Ok(None);
        }

        let data =
            CWrapper::new_with_c_free(unsafe { bindings::config_push(self.as_mut() as *mut _) })
                .context("Empty push data")?;

        let config_lengths =
            unsafe { std::slice::from_raw_parts(data.config_lens, data.n_configs) };

        let push_data = unsafe { std::slice::from_raw_parts(data.config, data.n_configs) }
            .into_iter()
            .enumerate()
            .map(|(index, msg)| {
                unsafe { std::slice::from_raw_parts::<u8>(*msg, config_lengths[index]) }.to_vec()
            })
            .collect_vec();

        Ok(Some(ConfigPush {
            seq: data.seqno,
            data: push_data,
            obsolete_hashes: unsafe {
                std::slice::from_raw_parts(data.obsolete, data.obsolete_len)
            }
            .iter()
            .map(|&ptr| unsafe { CStr::from_ptr(ptr) })
            .filter_map(|s| s.to_str().ok())
            .map(|s| s.to_string())
            .collect(),
        }))
    }

    fn confirm_pushed(&mut self, seq: bindings::seqno_t, msg_hashes: &[&str]) {
        let msg_hashes = msg_hashes
            .into_iter()
            .filter_map(|s| CString::new(*s).ok())
            .collect_vec();

        let msg_hash_refs = msg_hashes.iter().map(|s| s.as_ptr()).collect::<Vec<_>>();

        unsafe {
            bindings::config_confirm_pushed(
                self.as_mut() as *mut _,
                seq,
                msg_hash_refs.as_ptr(),
                msg_hashes.len(),
            );
        }
    }

    fn needs_push(&self) -> bool {
        unsafe { bindings::config_needs_push(self.as_ref() as *const _) }
    }

    fn needs_dump(&self) -> bool {
        unsafe { bindings::config_needs_dump(self.as_ref() as *const _) }
    }

    fn dump(&mut self) -> Option<impl AsRef<[u8]> + 'static> {
        let mut out = null_mut();
        let mut len = 0;
        unsafe { bindings::config_dump(self.as_mut() as *mut _, &mut out, &mut len) };
        CArrayWrapper::new(out, len)
    }
}

impl<C: Config + AsRef<bindings::config_object>> super::ConfigExt for C {
    fn last_error(&self) -> Option<&str> {
        if self.as_ref().last_error.is_null() {
            return None;
        }

        unsafe { CStr::from_ptr(self.as_ref().last_error) }
            .to_str()
            .ok()
    }
}

// impl bindings::config_push_data {
//     pub fn config_data(&self) -> &[u8] {
//         unsafe { std::slice::from_raw_parts(self.config, self.config as usize) }
//     }
//
//     pub fn obsolete_message_hashes(&self) -> impl Iterator<Item = &CStr> {
//         unsafe {
//             std::slice::from_raw_parts(self.obsolete, self.obsolete_len)
//                 .iter()
//                 .map(|&ptr| CStr::from_ptr(ptr))
//         }
//     }
// }
