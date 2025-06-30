use crate::utils::sqlite::reactive::ReactiveDatabaseManager;
use anyhow::Context;
use derive_more::Deref;
use r2d2_sqlite::SqliteConnectionManager;

#[derive(Deref)]
pub struct Repository(ReactiveDatabaseManager);

impl Repository {
    pub fn new(conn: SqliteConnectionManager) -> anyhow::Result<Self> {
        let migrations = super::migrations::create_migrations()?;
        let manager = ReactiveDatabaseManager::new(conn.with_init(|conn| {
            conn.query_row("PRAGMA journal_mode = WAL", [], |_| Ok(()))?;
            Ok(())
        }))?;

        manager
            .with_connection(|conn| {
                Ok(migrations.to_latest(conn)?)
            })
            .context("Error running db migrations")?;

        manager
            .with_transaction(|tx| super::views::upgrade_views(tx))
            .context("Error upgrading db views")?;

        Ok(Self(manager))
    }

    pub fn new_with_password(
        conn: SqliteConnectionManager,
        password: String,
    ) -> anyhow::Result<Self> {
        Self::new(conn.with_init(move |conn| {
            conn.query_row(&format!("PRAGMA key = '{password}'"), [], |_| Ok(()))?;
            let _ = conn.query_row("SELECT COUNT(*) FROM sqlite_master", [], |_| Ok(()))?;
            Ok(())
        }))
    }
}
