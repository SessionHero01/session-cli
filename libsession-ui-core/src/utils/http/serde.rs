pub mod status_code {
    use serde::Deserialize;

    pub fn deserialize<'de, D>(deserializer: D) -> Result<http::StatusCode, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let code = u16::deserialize(deserializer)?;
        Ok(http::StatusCode::from_u16(code).map_err(serde::de::Error::custom)?)
    }
}
