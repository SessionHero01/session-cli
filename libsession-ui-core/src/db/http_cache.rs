use crate::utils::iter::serde_iterator::SerdeIterator;
use crate::utils::json::Json;
use crate::utils::sqlite::statement_ext::StatementExt;
use anyhow::Context;
use chrono::{DateTime, Utc};
use http::Response;
use rusqlite::{Connection, prepare_cached_and_bind};

pub trait HttpCacheRepository {
    fn get_cache(&self, url: &str) -> anyhow::Result<Option<Response<Vec<u8>>>>;
    fn save_cache(&self, url: &str, response: &Response<impl AsRef<[u8]>>) -> anyhow::Result<()>;

    fn trim_cache(&self, earliest: &DateTime<Utc>) -> anyhow::Result<usize>;
}

impl HttpCacheRepository for Connection {
    fn get_cache(&self, url: &str) -> anyhow::Result<Option<Response<Vec<u8>>>> {
        let Some((status_code, headers, response)) = prepare_cached_and_bind!(
            self,
            //language=sqlite
            "SELECT response_status_code, response_headers, response FROM http_cache WHERE url = $url COLLATE NOCASE"
        ).raw_query_single_row(|r| Ok((r.get::<_, u16>(0)?, r.get::<_, Json<Vec<(String, String)>>>(1)?, r.get::<_, Vec<u8>>(2)?)))? else {
            return Ok(None);
        };

        let resp = headers
            .0
            .into_iter()
            .fold(Response::builder().status(status_code), |acc, (k, v)| {
                acc.header(k, v)
            })
            .body(response)
            .context("Building http response")?;

        prepare_cached_and_bind!(
            self,
            //language=sqlite
            "UPDATE http_cache SET last_accessed_at = CURRENT_TIMESTAMP WHERE url = $url COLLATE NOCASE"
        ).raw_execute()
            .context("Failed to update last accessed time")?;

        Ok(Some(resp))
    }

    fn save_cache(&self, url: &str, response: &Response<impl AsRef<[u8]>>) -> anyhow::Result<()> {
        let headers = response
            .headers()
            .iter()
            .filter_map(|(name, value)| Some((name.as_str(), value.to_str().ok()?)));

        let body = response.body().as_ref();

        //language=sqlite
        self.prepare("INSERT OR REPLACE INTO http_cache(url, response_status_code, response_headers, response) VALUES (?, ?, ?, ?)")?
            .execute((url, response.status().as_u16(), Json(SerdeIterator::new(headers)), body))?;
        Ok(())
    }

    fn trim_cache(&self, earliest: &DateTime<Utc>) -> anyhow::Result<usize> {
        //language=sqlite
        Ok(0)
    }
}
