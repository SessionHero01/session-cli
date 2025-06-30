use crate::app_setting::AppSettingsID;
use anyhow::{ensure, Context};
use derive_more::{AsRef, Deref};
use rusqlite::ToSql;
use serde::{Deserialize, Serialize};
use std::borrow::Cow;
use std::fmt::{Debug, Display, Formatter};
use url::Url;

#[derive(Deref, AsRef, Clone, PartialEq, Eq, Hash, Ord, PartialOrd, Deserialize, Serialize)]
pub struct HttpBaseUrl(Url);

impl Debug for HttpBaseUrl {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        Display::fmt(&self.0, f)
    }
}

impl Display for HttpBaseUrl {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        Display::fmt(&self.0, f)
    }
}

impl ToSql for HttpBaseUrl {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        self.0.to_sql()
    }
}

impl HttpBaseUrl {
    pub fn new(url: &str) -> anyhow::Result<Self> {
        let mut url: Url = url.parse().context("Malformed URL")?;

        ensure!(
            url.scheme().eq_ignore_ascii_case("http") || url.scheme().eq_ignore_ascii_case("https"),
            "URL scheme must be http or https"
        );

        url.set_fragment(None);
        url.set_query(None);
        Ok(Self(url))
    }

    pub fn build_upon(&self) -> HttpUrlBuilder {
        HttpUrlBuilder(self.0.clone())
    }
}

impl TryFrom<Url> for HttpBaseUrl {
    type Error = anyhow::Error;

    fn try_from(value: Url) -> Result<Self, Self::Error> {
        Self::new(value.as_str())
    }
}

pub struct HttpUrlBuilder(Url);

impl HttpUrlBuilder {
    pub fn append_path(mut self, path_segment: &str) -> Self {
        self.0
            .path_segments_mut()
            .expect("To have path segment")
            .push(path_segment);
        self
    }

    pub fn append_query(mut self, query_name: &str, query_value: &str) -> Self {
        self.0
            .query_pairs_mut()
            .append_pair(query_name, query_value);
        self
    }

    pub fn build(self) -> Url {
        self.0
    }
}

impl AppSettingsID for HttpBaseUrl {
    fn as_str(&self) -> Cow<str> {
        Cow::Borrowed(HttpBaseUrl::as_ref(self).as_str())
    }
}
