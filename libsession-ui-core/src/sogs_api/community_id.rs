use crate::app_setting::AppSettingsID;
use crate::batcher::Batchable;
use crate::key::curve25519::Curve25519PubKey;
use crate::utils::http::base_url::HttpBaseUrl;
use crate::utils::string::non_empty_string::NonEmptyStringRef;
use anyhow::{ensure, Context};
use non_empty_string::NonEmptyString;
use rusqlite::types::{ToSqlOutput, ValueRef};
use rusqlite::ToSql;
use serde::{Deserialize, Serialize};
use serde_with::{DeserializeFromStr, SerializeDisplay};
use std::borrow::Cow;
use std::fmt::{Debug, Display};
use std::hash::Hash;
use std::str::FromStr;
use std::sync::OnceLock;
use url::Url;

#[derive(Clone, PartialEq, Eq, Hash, Ord, PartialOrd)]
struct CommunityIdInner {
    server_url: HttpBaseUrl,
    room: NonEmptyString,
}

#[derive(Clone, DeserializeFromStr, SerializeDisplay)]
pub struct CommunityId {
    inner: CommunityIdInner,

    full_url: OnceLock<Url>,
}

impl PartialEq for CommunityId {
    fn eq(&self, other: &Self) -> bool {
        self.inner == other.inner
    }
}

impl Eq for CommunityId {}

impl ToSql for CommunityId {
    fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
        Ok(ToSqlOutput::Borrowed(ValueRef::Text(
            self.as_str().as_bytes(),
        )))
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, Ord, PartialOrd, Serialize, Deserialize)]
pub struct CommunityServerName<'a>(Cow<'a, str>);

impl AppSettingsID for CommunityServerName<'_> {
    fn as_str(&self) -> Cow<str> {
        Cow::Borrowed(self.0.as_ref())
    }
}

pub type CommunityPublicKey = Curve25519PubKey;

impl Batchable for CommunityPublicKey {
    fn should_batch_with(&self, other: &Self) -> bool {
        self == other
    }
}

impl Hash for CommunityId {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.inner.hash(state);
    }
}

impl PartialEq<CommunityIdInner> for CommunityId {
    fn eq(&self, other: &CommunityIdInner) -> bool {
        self.inner == *other
    }
}

impl PartialEq<CommunityId> for CommunityIdInner {
    fn eq(&self, other: &CommunityId) -> bool {
        *self == other.inner
    }
}

impl Display for CommunityId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Display::fmt(self.full_url(), f)
    }
}

impl Debug for CommunityId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let url = self.as_str();
        write!(f, "{}**{}", &url[..9], &url[url.len() - 2..])
    }
}

impl FromStr for CommunityId {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut url: Url = s.parse().with_context(|| format!("malformed url: {s}"))?;
        let room_name = url
            .path_segments()
            .context("url has no path")?
            .last()
            .context("url contains no room path")?
            .to_string();

        url.path_segments_mut().unwrap().pop();

        Self::new_from_strings(url.as_str(), &room_name)
    }
}

impl AppSettingsID for CommunityId {
    fn as_str(&self) -> Cow<str> {
        Cow::Borrowed(self.as_str())
    }
}

impl CommunityId {
    pub fn new_from_strings(server_url: &str, room: &str) -> anyhow::Result<Self> {
        let normalised_room: NonEmptyString = room
            .trim_ascii()
            .to_ascii_lowercase()
            .try_into()
            .map_err(|_| anyhow::anyhow!("room is empty"))?;

        ensure!(!normalised_room.as_str().contains('/'), "room contains '/'");

        let normalised_url_string = server_url.trim_ascii().to_ascii_lowercase();
        let normalised_url = HttpBaseUrl::new(&normalised_url_string).with_context(|| {
            format!("server url it not a http based url: {normalised_url_string}")
        })?;

        Ok(Self {
            inner: CommunityIdInner {
                server_url: normalised_url,
                room: normalised_room,
            },
            full_url: OnceLock::new(),
        })
    }

    pub fn extract_room_file_id(url: &Url) -> Option<(Self, i64)> {
        let http_base_url = HttpBaseUrl::new(url.as_str()).ok()?;
        let mut segments = url.path_segments()?;
        match (
            segments.next(),
            segments.next(),
            segments.next(),
            segments.next(),
        ) {
            (Some("room"), Some(room), Some("file"), Some(file_id)) => Some((
                Self::new_from_strings(http_base_url.join("/").ok()?.as_str(), room).ok()?,
                file_id.parse().ok()?,
            )),

            _ => None,
        }
    }

    pub fn server_url(&self) -> &HttpBaseUrl {
        &self.inner.server_url
    }

    pub fn server_name(&self) -> CommunityServerName {
        CommunityServerName(Cow::Borrowed(self.server_url().host_str().unwrap()))
    }

    pub fn room(&self) -> NonEmptyStringRef {
        (&self.inner.room).into()
    }

    pub fn full_url(&self) -> &Url {
        self.full_url.get_or_init(|| {
            self.server_url()
                .join(&self.room())
                .expect("server url and room are valid")
        })
    }

    pub fn as_str(&self) -> &str {
        self.full_url().as_str()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn community_id_should_be_normalised() {
        let community_id = CommunityId::new_from_strings("http://example.com", "Room").unwrap();
        assert_eq!(community_id.server_url().as_str(), "http://example.com/");
        assert_eq!(community_id.room().as_str(), "room");
        assert_eq!(community_id.full_url().as_str(), "http://example.com/room");

        assert!(CommunityId::new_from_strings("http://example.com", "Room/").is_err());
        assert!(CommunityId::new_from_strings("ftp://example.com", "Room").is_err());

        let id1 = CommunityId::new_from_strings("http://EXAMPLE.COM/#fragment", "Room").unwrap();
        let id2 = CommunityId::new_from_strings("HTTP://example.com?a=5", "Room").unwrap();
        assert_eq!(id1, id2);
    }
}
