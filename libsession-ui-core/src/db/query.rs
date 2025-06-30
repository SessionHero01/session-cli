use crate::utils::json::Json;
use crate::utils::timed_log::timed_log;
use anyhow::Context;
use rusqlite::{Connection, Params, Row};
use serde::Deserialize;
use smallvec::SmallVec;

#[derive(Clone)]
pub struct QueryInfo<Sql, P, F> {
    pub name: &'static str,
    pub sql: Sql,
    pub params: P,
    pub row_mapper: F,
}

pub fn first_json_column_row_mapper<T>(r: &Row<'_>) -> rusqlite::Result<T>
where
    T: for<'de> Deserialize<'de>,
{
    Ok(r.get::<_, Json<T>>(0)?.0)
}

pub type SQLRowsVec<T> = SmallVec<[T; 1]>;

pub trait SQLRunnable {
    type Item: Send + Sync + 'static;

    fn name(&self) -> &'static str;
    fn sql(&self) -> &str;
    fn params(&self) -> impl Params + Sized;
    fn run(&self, conn: &Connection) -> anyhow::Result<SQLRowsVec<Self::Item>>;
}

impl<Sql, P, F, T> SQLRunnable for QueryInfo<Sql, P, F>
where
    Sql: AsRef<str>,
    P: Params + Clone,
    F: for<'a> Fn(&Row<'a>) -> rusqlite::Result<T> + Send + Sync,
    T: Send + Sync + 'static,
{
    type Item = T;

    fn name(&self) -> &'static str {
        self.name
    }

    fn sql(&self) -> &str {
        self.sql.as_ref()
    }

    fn params(&self) -> impl Params + Sized {
        self.params.clone()
    }

    fn run(&self, conn: &Connection) -> anyhow::Result<SmallVec<[Self::Item; 1]>> {
        timed_log(self.name, || {
            conn.prepare_cached(self.sql())?
                .query_map(self.params(), |r| (self.row_mapper)(r))?
                .collect::<Result<SmallVec<_>, _>>()
                .context("Error running sql query")
        })
    }
}
