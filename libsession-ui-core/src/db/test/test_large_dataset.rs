use crate::db::test_utils::create_test_environment;
use crate::db::Repository;
use r2d2_sqlite::SqliteConnectionManager;

// #[test]
fn test_medium_dataset() {
    let path = std::env::current_dir()
        .unwrap()
        .join("medium_data.sqlite3db");
    let _ = std::fs::remove_file(&path);

    println!("DB file = {}", path.display());
    let repo = Repository::new(SqliteConnectionManager::file(path)).unwrap();
    create_test_environment(&repo, 1000, 50, 10, 2500, 10, 2000);
}

// #[test]
fn test_large_dataset() {
    let path = std::env::current_dir()
        .unwrap()
        .join("large_data.sqlite3db");
    let _ = std::fs::remove_file(&path);

    println!("DB file = {}", path.display());
    let repo = Repository::new(SqliteConnectionManager::file(path)).unwrap();
    create_test_environment(&repo, 1000, 500, 10, 2500, 10, 20000);
}
