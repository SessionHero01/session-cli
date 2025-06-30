use crate::utils::json::Json;
use anyhow::Context;
use itertools::Itertools;
use rusqlite::{prepare_and_bind, Connection, Params};

pub trait QueryMetaExt {
    fn find_tables_read_by_sql(
        &self,
        sql: &str,
        params: impl Params,
    ) -> anyhow::Result<Vec<String>>;
}

impl QueryMetaExt for Connection {
    fn find_tables_read_by_sql(
        &self,
        sql: &str,
        params: impl Params,
    ) -> anyhow::Result<Vec<String>> {
        // Read Opcode "OpenRead", and it's P2 is the root page of the table
        let root_pages = self
            .prepare(&format!("EXPLAIN {sql}"))?
            .query_map(params, |row| {
                Ok((row.get::<_, String>(1)?, row.get::<_, i64>(3)?))
            })?
            .filter_map_ok(|(op_code, p2)| {
                if op_code == "OpenRead" {
                    Some(p2)
                } else {
                    None
                }
            })
            .collect::<Result<Vec<_>, _>>()?;

        let root_pages = Json(root_pages);

        // Get the table name from sqlite_master using the root page number
        prepare_and_bind!(
            self,
            //language=SQL
            "SELECT name FROM sqlite_master WHERE type = 'table' AND rootpage IN (SELECT value FROM json_each($root_pages))"
        ).raw_query()
            .mapped(|r| r.get::<_, String>(0))
            .collect::<Result<_, _>>()
            .context("Failed to find tables read by the query")
    }
}
