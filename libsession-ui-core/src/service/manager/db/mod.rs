pub mod accounts;
use crate::utils::sqlite::reactive::ReactiveDatabaseManager;
use anyhow::Context;
use derive_more::Deref;
use r2d2_sqlite::SqliteConnectionManager;
use rusqlite_migration::{Migrations, M};

#[derive(Deref)]
pub struct ManagerRepository(ReactiveDatabaseManager);

impl ManagerRepository {
    pub fn new(conn: SqliteConnectionManager) -> anyhow::Result<Self> {
        let migrations = Migrations::new(vec![M::up(include_str!("migrations/initial.sql"))]);

        let manager = ReactiveDatabaseManager::new(conn)?;

        manager
            .with_connection(|conn| Ok(migrations.to_latest(conn)?))
            .context("Error running db migrations")?;

        Ok(Self(manager))
    }
}
