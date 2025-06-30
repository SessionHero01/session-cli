use anyhow::{format_err, Context};
use base64::{prelude::BASE64_STANDARD, Engine};
use derive_more::Deref;
use rusqlite::types::{FromSql, FromSqlError, FromSqlResult, ToSqlOutput, ValueRef};
use rusqlite::ToSql;
use serde_with::{DeserializeFromStr, SerializeDisplay};
use std::fmt::Display;
use std::str::FromStr;

#[derive(Deref, Clone, Debug, Default, DeserializeFromStr, Eq, PartialEq, SerializeDisplay)]
pub struct Base64<T>(pub T);

impl<T> FromStr for Base64<T>
where
    T: TryFrom<Vec<u8>>,
{
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let bytes = BASE64_STANDARD
            .decode(s.as_bytes())
            .context("base64 decode error")?;
        Ok(Self(bytes.try_into().map_err(|_| {
            format_err!("unable to convert to target type")
        })?))
    }
}

impl<T: AsRef<[u8]>> Display for Base64<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&BASE64_STANDARD.encode(self.0.as_ref()))
    }
}

impl FromSql for Base64<Vec<u8>> {
    fn column_result(value: ValueRef<'_>) -> FromSqlResult<Self> {
        let bytes = <String as FromSql>::column_result(value)?;
        BASE64_STANDARD
            .decode(bytes)
            .map_err(|e| FromSqlError::Other(Box::new(e)))
            .map(Self)
    }
}

impl<T: AsRef<[u8]>> ToSql for Base64<T> {
    fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
        let s = BASE64_STANDARD.encode(self.0.as_ref());
        Ok(ToSqlOutput::from(s))
    }
}
