use crate::db::query::{QueryInfo, SQLRunnable};
use crate::utils::iter::serde_iterator::SerdeIterator;
use crate::utils::json::Json;
use libsession_protos::protos::list_accounts_response::Account;
use rusqlite::{params, Row};

pub fn list_accounts_query() -> impl SQLRunnable<Item = Account> {
    QueryInfo {
        name: "List all accounts",
        //language=sqlite
        sql: "SELECT session_id, name, avatar_image FROM accounts ORDER BY created_at",
        params: [],
        row_mapper: |row: &Row| {
            Ok(Account {
                session_id: row.get(0)?,
                name: row.get(1)?,
                avatar_image: row.get(2)?,
            })
        },
    }
}

impl super::ManagerRepository {
    pub fn save_accounts(&self, accounts: &[Account]) -> anyhow::Result<()> {
        self.with_transaction(|tx| {
            // Remove non-exists accounts
            tx.execute(
                //language=sqlite
                "DELETE FROM accounts WHERE session_id NOT IN (SELECT value FROM json_each(?))",
                [Json(SerdeIterator::new(
                    accounts.iter().map(|a| a.session_id.as_str()),
                ))],
            )?;

            // Insert or update accounts
            let mut stmt = tx.prepare(
                //language=sqlite
                r#"
            INSERT OR REPLACE INTO accounts (session_id, name, avatar_image)
            VALUES (?, ?, ?)
            "#,
            )?;

            for account in accounts {
                stmt.execute(params![
                    &account.session_id,
                    &account.name,
                    &account.avatar_image
                ])?;
            }

            Ok(())
        })?;

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::super::ManagerRepository;
    use r2d2_sqlite::SqliteConnectionManager;

    use super::*;

    #[test]
    fn account_works() {
        let repo =
            ManagerRepository::new(SqliteConnectionManager::memory()).expect("To create repo");

        // Save accounts and list them
        let accounts = vec![
            Account {
                session_id: "1".to_string(),
                name: "Alice".to_string(),
                avatar_image: Some(vec![1, 2, 3]),
            },
            Account {
                session_id: "2".to_string(),
                name: "Bob".to_string(),
                avatar_image: Some(vec![4, 5, 6]),
            },
        ];

        repo.save_accounts(&accounts).expect("To save accounts");

        let saved_accounts = repo
            .with_connection(|conn| list_accounts_query().run(conn))
            .expect("To list accounts");

        assert_eq!(accounts, saved_accounts.into_vec());
    }
}
