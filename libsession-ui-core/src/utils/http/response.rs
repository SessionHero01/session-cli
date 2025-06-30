use crate::utils::http::mime::ContentTypeExt;
use anyhow::{Context, bail, ensure};
use http::Response;
use mime::{APPLICATION_JSON, APPLICATION_OCTET_STREAM};
use serde::Deserialize;

pub trait ResponseExt {
    async fn success_json<T: for<'de> Deserialize<'de>>(self) -> anyhow::Result<T>
    where
        Self: Sized;
}

impl ResponseExt for Response<Vec<u8>> {
    async fn success_json<T: for<'de> Deserialize<'de>>(self) -> anyhow::Result<T>
    where
        Self: Sized,
    {
        let (parts, body) = self.into_parts();
        ensure!(
            parts.status.is_success(),
            "HTTP request failed with status code: {}",
            parts.status
        );

        match parts.headers.get_content_type() {
            Some(mime) if mime != APPLICATION_JSON && mime != APPLICATION_OCTET_STREAM => {
                bail!("Not a valid response: {mime}")
            }
            _ => {}
        }

        serde_json::from_slice(&body).with_context(|| {
            format!(
                "Error converting JSON response to {}",
                std::any::type_name::<T>()
            )
        })
    }
}
