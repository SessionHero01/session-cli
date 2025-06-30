use crate::app_setting::{impl_sql_for_serde, AppSetting};
use crate::http_api::json::HttpJsonRPC;
use crate::sogs_api::community_id::CommunityServerName;
use http::Method;
use serde::{Deserialize, Serialize};
use std::borrow::Cow;

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq, Hash, Ord, PartialOrd)]
#[serde(rename_all = "snake_case")]
pub enum Capability {
    Sogs,
    Blind,
    Reactions,
    #[serde(untagged)]
    Other(String),
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ServerCapabilities {
    pub capabilities: Vec<Capability>,
}

impl AppSetting for ServerCapabilities {
    const NAME: &'static str = "community_server_capabilities";
    type IDType<'a> = CommunityServerName<'a>;
}

impl_sql_for_serde!(ServerCapabilities);

#[derive(Default, Debug)]
pub struct GetCapabilitiesRequest;

impl HttpJsonRPC for GetCapabilitiesRequest {
    type Output = ServerCapabilities;

    fn method(&self) -> Method {
        Method::GET
    }

    fn path_segments(&self) -> impl Iterator<Item = Cow<str>> {
        std::iter::once(Cow::Borrowed("capabilities"))
    }
}
