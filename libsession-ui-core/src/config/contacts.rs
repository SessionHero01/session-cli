use crate::bindings;
use crate::config::user_profile::UserProfilePic;
use crate::session_id::SessionID;
use crate::utils::ffi::cwrapper::CWrapper;
use crate::utils::ffi::string_ext::CArrayExt;
use anyhow::ensure;
use derive_more::{Deref, DerefMut};
use num_traits::FromPrimitive;
use std::fmt::Debug;
use std::mem::MaybeUninit;

#[derive(Deref, DerefMut)]
pub struct Contact(pub(self) bindings::contacts_contact);

pub struct ContactIter(CWrapper<bindings::contacts_iterator>);

impl Iterator for ContactIter {
    type Item = Contact;

    fn next(&mut self) -> Option<Self::Item> {
        unsafe {
            let mut contact = MaybeUninit::zeroed().assume_init();
            if bindings::contacts_iterator_done(self.0.as_mut(), &mut contact) {
                return None;
            }

            bindings::contacts_iterator_advance(self.0.as_mut());
            Some(Contact(contact))
        }
    }
}

impl Contact {
    pub fn session_id(&self) -> Option<SessionID> {
        let id = self.session_id.cstr_to_str()?;
        id.parse().ok()
    }

    pub fn name(&self) -> &str {
        self.name.cstr_to_str().unwrap_or_default()
    }

    pub fn nickname(&self) -> &str {
        self.nickname.cstr_to_str().unwrap_or_default()
    }

    pub fn set_name(&mut self, name: &str) -> anyhow::Result<()> {
        ensure!(self.0.name.write_cstr(name), "Given name is too long");
        Ok(())
    }

    pub fn user_profile_pic(&self) -> Option<UserProfilePic> {
        UserProfilePic::new(self.profile_pic)
    }

    pub fn set_profile_pic(&mut self, pic: UserProfilePic) -> anyhow::Result<()> {
        self.0.profile_pic = pic.try_into()?;
        Ok(())
    }

    pub fn notification_mode(&self) -> Option<super::NotificationMode> {
        super::NotificationMode::from_u32(self.notifications)
    }
}

impl Debug for Contact {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Contact")
            .field("session_id", &self.session_id())
            .field("name", &self.name())
            .field("nickname", &self.nickname())
            .field("profile_pic", &self.user_profile_pic())
            .finish()
    }
}

impl super::ContactsConfig {
    pub fn get_or_construct(&mut self, id: &SessionID) -> Option<Contact> {
        unsafe {
            let mut contacts = MaybeUninit::zeroed().assume_init();
            if bindings::contacts_get_or_construct(
                self.as_mut(),
                &mut contacts,
                id.as_c_str().as_ptr(),
            ) {
                Some(Contact(contacts))
            } else {
                None
            }
        }
    }

    pub fn set(&mut self, contact: &Contact) -> bool {
        unsafe { bindings::contacts_set(self.as_mut(), &contact.0) }
    }

    pub fn all(&self) -> impl Iterator<Item = Contact> + 'static {
        CWrapper::new_with_destroyer(
            unsafe { bindings::contacts_iterator_new(self.as_ref()) },
            bindings::contacts_iterator_free,
        )
        .into_iter()
        .flat_map(ContactIter)
    }
}

impl Debug for super::ContactsConfig {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_list().entries(self.all()).finish()
    }
}
