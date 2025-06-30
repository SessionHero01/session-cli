use derive_more::Deref;
use non_empty_string::NonEmptyString;
use rusqlite::ToSql;
use serde::Serialize;
use std::fmt::{Debug, Display, Formatter};

#[derive(Clone, Ord, PartialOrd, Eq, PartialEq, Hash, Copy, Deref)]
pub struct NonEmptyStringRef<'a>(&'a str);

impl<'a> Display for NonEmptyStringRef<'a> {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        std::fmt::Display::fmt(self.0, f)
    }
}

impl<'a> Debug for NonEmptyStringRef<'a> {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        std::fmt::Debug::fmt(self.0, f)
    }
}

impl<'a> Serialize for NonEmptyStringRef<'a> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        self.0.serialize(serializer)
    }
}

impl<'a> NonEmptyStringRef<'a> {
    pub fn new(data: &'a str) -> Option<Self> {
        if data.is_empty() {
            return None;
        }

        Some(Self(data))
    }

    pub fn as_str(&self) -> &str {
        self.0
    }

    pub fn to_string(&self) -> NonEmptyString {
        NonEmptyString::new(self.0.to_string()).unwrap()
    }
}

impl<'a> From<&'a NonEmptyString> for NonEmptyStringRef<'a> {
    fn from(value: &'a NonEmptyString) -> Self {
        NonEmptyStringRef(value.as_str())
    }
}

impl<'a> ToSql for NonEmptyStringRef<'a> {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        self.as_str().to_sql()
    }
}
