use crate::app_setting::impl_sql_for_serde;
use crate::session_id::IndividualOrBlindedID;
use crate::sogs_api::community_id::CommunityId;
use crate::utils::iter::non_empty::NonEmpty;
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
pub struct CommunityIdentities(pub NonEmpty<IndividualOrBlindedID>);

impl super::AppSetting for CommunityIdentities {
    const NAME: &'static str = "community_identities";
    type IDType<'a> = CommunityId;
}

impl_sql_for_serde!(CommunityIdentities);
