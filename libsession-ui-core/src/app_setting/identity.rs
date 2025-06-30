use crate::identity::Identity;

use super::{impl_sql_for_serde, AppSetting};

impl AppSetting for Identity {
    const NAME: &'static str = "identity";
    type IDType<'a> = ();
}

impl_sql_for_serde!(Identity);
