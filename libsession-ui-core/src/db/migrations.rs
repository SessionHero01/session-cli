use include_dir::{include_dir, Dir};
use rusqlite_migration::{Migrations, M};

static MIGRATIONS_DIR: Dir = include_dir!("$CARGO_MANIFEST_DIR/src/db/migrations");

pub fn create_migrations() -> anyhow::Result<Migrations<'static>> {
    let mut migration_dirs = MIGRATIONS_DIR.dirs().collect::<Vec<_>>();

    migration_dirs.sort_by_key(|d| d.path().file_name().unwrap());

    let migrations = migration_dirs
        .into_iter()
        .flat_map(|dir| {
            let mut files = dir.files().collect::<Vec<_>>();
            files.sort_by_key(|f| f.path().file_name().unwrap());
            files.into_iter().map(|f| M::up(f.contents_utf8().unwrap()))
        })
        .collect();

    Ok(Migrations::new(migrations))
}
