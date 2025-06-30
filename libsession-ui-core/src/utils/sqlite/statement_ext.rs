use rusqlite::types::FromSql;
use rusqlite::Row;

pub trait StatementExt {
    fn raw_query_single_row<T>(
        &mut self,
        map: impl FnMut(&Row) -> rusqlite::Result<T>,
    ) -> rusqlite::Result<Option<T>>;

    fn raw_query_single_row_first_column<T: FromSql>(&mut self) -> rusqlite::Result<Option<T>> {
        self.raw_query_single_row(|r| r.get(0))
    }
}

impl StatementExt for rusqlite::Statement<'_> {
    fn raw_query_single_row<T>(
        &mut self,
        map: impl FnMut(&Row) -> rusqlite::Result<T>,
    ) -> rusqlite::Result<Option<T>> {
        match self.raw_query().mapped(map).next() {
            Some(Ok(row)) => Ok(Some(row)),
            Some(Err(e)) => Err(e),
            None => Ok(None),
        }
    }
}
