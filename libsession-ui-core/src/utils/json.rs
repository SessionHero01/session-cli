use rusqlite::ToSql;
use rusqlite::types::{FromSql, FromSqlError, FromSqlResult, ToSqlOutput, Value, ValueRef};
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use std::fmt::{Debug, Formatter};
use std::sync::OnceLock;

#[derive(Debug, Clone)]
pub struct Json<T>(pub T);

impl<T: Serialize> Serialize for Json<T> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        serde_json::to_string(&self.0)
            .map_err(serde::ser::Error::custom)?
            .serialize(serializer)
    }
}

impl<T: Serialize> ToSql for Json<T> {
    fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
        serde_json::to_string(&self.0)
            .map_err(|e| rusqlite::Error::ToSqlConversionFailure(Box::new(e)))
            .map(|s| ToSqlOutput::Owned(Value::Text(s)))
    }
}

impl<T: for<'de> Deserialize<'de>> FromSql for Json<T> {
    fn column_result(value: ValueRef<'_>) -> FromSqlResult<Self> {
        let value = value.as_str()?;
        let value = serde_json::from_str(value)
            .map(Json)
            .map_err(|e| FromSqlError::Other(Box::new(e)))?;
        Ok(value)
    }
}

impl<'de, T> Deserialize<'de> for Json<T>
where
    T: for<'d> Deserialize<'d>,
{
    fn deserialize<D>(deserializer: D) -> Result<Json<T>, D::Error>
    where
        D: Deserializer<'de>,
    {
        let value = String::deserialize(deserializer)?;
        serde_json::from_str(&value)
            .map(Self)
            .map_err(serde::de::Error::custom)
    }
}

#[derive(Clone)]
pub struct JsonText(serde_json::Value, OnceLock<String>);

impl From<serde_json::Value> for JsonText {
    fn from(value: serde_json::Value) -> Self {
        Self::new(value)
    }
}

impl Debug for JsonText {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

impl JsonText {
    pub fn new(value: serde_json::Value) -> Self {
        Self(value, OnceLock::default())
    }

    pub fn as_str(&self) -> &str {
        self.1.get_or_init(|| self.0.to_string())
    }

    pub fn as_bytes(&self) -> &[u8] {
        self.as_str().as_bytes()
    }

    pub fn into_value(self) -> serde_json::Value {
        self.0
    }

    pub fn into_string(self) -> String {
        self.1.into_inner().unwrap_or_else(|| self.0.to_string())
    }
}

impl Serialize for JsonText {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        self.0.serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for JsonText {
    fn deserialize<D>(deserializer: D) -> Result<JsonText, D::Error>
    where
        D: Deserializer<'de>,
    {
        serde_json::Value::deserialize(deserializer).map(Self::new)
    }
}
