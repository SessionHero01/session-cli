use super::GroupMemberConfig;
use crate::bindings;
use crate::session_id::IndividualID;
use crate::utils::ffi::cwrapper::CIteratorWrapper;
use crate::utils::ffi::string_ext::CArrayExt;
use anyhow::ensure;
use num_derive::{FromPrimitive, ToPrimitive};
use num_traits::FromPrimitive;
use std::fmt::{Debug, Formatter};
use std::mem::MaybeUninit;
use strum::{Display, EnumString, IntoStaticStr};

pub struct GroupMember {
    member: bindings::config_group_member,
    id: IndividualID,
}

impl GroupMember {
    pub fn new(member: bindings::config_group_member) -> Option<Self> {
        let id = IndividualID::from_c_string_array(&member.session_id)?;
        Some(Self { member, id })
    }

    pub fn name(&self) -> &str {
        self.member.name.cstr_to_str().unwrap_or_default()
    }

    pub fn set_name(&mut self, name: &str) -> anyhow::Result<()> {
        ensure!(self.member.name.write_cstr(name), "Name is too long");
        Ok(())
    }

    pub fn profile_pic(&self) -> Option<super::user_profile::UserProfilePic> {
        super::user_profile::UserProfilePic::new(self.member.profile_pic)
    }

    pub fn set_profile_pic(
        &mut self,
        pic: Option<super::user_profile::UserProfilePic>,
    ) -> anyhow::Result<()> {
        let Some(pic) = pic else {
            self.member.profile_pic.key.fill(0);
            self.member.profile_pic.url.fill(0);
            return Ok(());
        };

        self.member.profile_pic = pic.try_into()?;
        Ok(())
    }

    pub fn session_id(&self) -> &IndividualID {
        &self.id
    }

    pub fn admin(&self) -> bool {
        self.member.admin
    }

    pub fn set_admin(&mut self, admin: bool) {
        self.member.admin = admin;
    }

    pub fn supplement(&self) -> bool {
        self.member.supplement
    }

    pub fn set_supplement(&mut self, supplement: bool) {
        self.member.supplement = supplement;
    }
}

impl Debug for GroupMember {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("GroupMember")
            .field("name", &self.name())
            .field("session_id", &self.session_id())
            .field("admin", &self.admin())
            .field("supplement", &self.supplement())
            .finish()
    }
}

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
#[repr(u32)]
pub enum GroupMemberStatus {
    InviteUnknown = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_UNKNOWN,
    InviteNotSent = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_NOT_SENT,
    InviteSending = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_SENDING,
    InviteFailed = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_FAILED,
    InviteSent = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_SENT,
    InviteAccepted = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_INVITE_ACCEPTED,
    PromotionUnknown = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_UNKNOWN,
    PromotionNotSent = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_NOT_SENT,
    PromotionSending = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_SENDING,
    PromotionFailed = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_FAILED,
    PromotionSent = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_SENT,
    PromotionAccepted = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_PROMOTION_ACCEPTED,
    RemovedUnknown = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_REMOVED_UNKNOWN,
    Removed = bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_REMOVED,
    RemovedMemberAndMessages =
        bindings::GROUP_MEMBER_STATUS_GROUP_MEMBER_STATUS_REMOVED_MEMBER_AND_MESSAGES,
}

impl GroupMemberConfig {
    pub fn members(&self) -> impl Iterator<Item = GroupMember> + 'static {
        CIteratorWrapper::new(
            unsafe { bindings::groups_members_iterator_new(self.as_ref() as *const _) },
            bindings::groups_members_iterator_free,
            bindings::groups_members_iterator_done,
            bindings::groups_members_iterator_advance,
        )
        .filter_map(GroupMember::new)
    }

    pub fn set_member(&mut self, member: &GroupMember) {
        unsafe {
            bindings::groups_members_set(self.as_mut() as *mut _, &member.member);
        }
    }

    pub fn remove_member(&mut self, id: &IndividualID) -> bool {
        unsafe { bindings::groups_members_erase(self.as_mut() as *mut _, id.as_c_str().as_ptr()) }
    }

    pub fn member_status(&self, member: &GroupMember) -> Option<GroupMemberStatus> {
        GroupMemberStatus::from_u32(unsafe {
            bindings::groups_members_get_status(self.as_ref() as *const _, &member.member)
        })
    }

    pub fn get(&mut self, id: &IndividualID) -> Option<GroupMember> {
        unsafe {
            let mut member = MaybeUninit::zeroed().assume_init();
            if bindings::groups_members_get(
                self.as_mut() as *mut _,
                &mut member,
                id.as_c_str().as_ptr(),
            ) {
                GroupMember::new(member)
            } else {
                None
            }
        }
    }

    pub fn get_or_construct_member(&mut self, id: &IndividualID) -> Option<GroupMember> {
        unsafe {
            let mut member = MaybeUninit::zeroed().assume_init();
            if bindings::groups_members_get_or_construct(
                self.as_mut() as *mut _,
                &mut member,
                id.as_c_str().as_ptr(),
            ) {
                GroupMember::new(member)
            } else {
                None
            }
        }
    }
}

impl Debug for GroupMemberConfig {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.debug_list().entries(self.members()).finish()
    }
}
