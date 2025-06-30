use std::borrow::Cow;

pub mod community_identity;
pub mod identity;

pub trait AppSettingsID {
    fn as_str(&self) -> Cow<str>;
}

pub trait AppSetting {
    const NAME: &'static str;

    type IDType<'a>: AppSettingsID + ?Sized;
}

impl AppSettingsID for () {
    fn as_str(&self) -> Cow<str> {
        Cow::Borrowed("")
    }
}

impl AppSettingsID for str {
    fn as_str(&self) -> Cow<str> {
        Cow::Borrowed(self)
    }
}

macro_rules! impl_sql_for_serde {
    ($type_name:ty) => {
        impl rusqlite::ToSql for $type_name {
            fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
                Ok(rusqlite::types::ToSqlOutput::Owned(
                    serde_json::to_string(self)
                        .map_err(|e| rusqlite::Error::ToSqlConversionFailure(Box::new(e)))?
                        .into(),
                ))
            }
        }

        impl rusqlite::types::FromSql for $type_name {
            fn column_result(
                value: rusqlite::types::ValueRef<'_>,
            ) -> rusqlite::types::FromSqlResult<Self> {
                let s = value.as_str()?;
                serde_json::from_str(s)
                    .map_err(|e| rusqlite::types::FromSqlError::Other(Box::new(e)))
            }
        }
    };
}

macro_rules! impl_sql_from_str_display {
    ($type_name:ty) => {
        impl rusqlite::ToSql for $type_name {
            fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
                Ok(rusqlite::types::ToSqlOutput::Owned(self.to_string().into()))
            }
        }

        impl rusqlite::types::FromSql for $type_name {
            fn column_result(
                value: rusqlite::types::ValueRef<'_>,
            ) -> rusqlite::types::FromSqlResult<Self> {
                let s = value.as_str()?;
                s.parse()
                    .map_err(|e| rusqlite::types::FromSqlError::Other(Box::from(e)))
            }
        }
    };
}

pub(crate) use impl_sql_for_serde;
pub(crate) use impl_sql_from_str_display;
