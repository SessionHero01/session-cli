use anyhow::Context;
use rusqlite::{prepare_and_bind, prepare_cached_and_bind, types::FromSql, Connection, ToSql};

use crate::app_setting::{AppSetting, AppSettingsID};
use crate::utils::sqlite::statement_ext::StatementExt;

pub trait AppSettingRepositoryExt {
    fn load_setting<T: AppSetting + FromSql>(
        &self,
        id: &T::IDType<'_>,
    ) -> anyhow::Result<Option<T>>;

    fn save_setting<T: AppSetting + ToSql>(
        &self,
        id: &T::IDType<'_>,
        value: &T,
    ) -> anyhow::Result<()>;
    fn remove_settings_by_name(&self, name: &str) -> anyhow::Result<()>;

    fn load_settings_without_id<T>(&self) -> anyhow::Result<Option<T>>
    where
        T: for<'a> AppSetting<IDType<'a> = ()> + FromSql,
    {
        self.load_setting(&Default::default())
    }

    fn save_settings_without_id<T>(&self, value: &T) -> anyhow::Result<()>
    where
        T: for<'a> AppSetting<IDType<'a> = ()> + ToSql,
    {
        self.save_setting(&Default::default(), value)
    }
}

impl AppSettingRepositoryExt for Connection {
    fn load_setting<T: AppSetting + FromSql>(
        &self,
        id: &T::IDType<'_>,
    ) -> anyhow::Result<Option<T>> {
        let name = T::NAME;
        let id = id.as_str();
        prepare_cached_and_bind!(
            self,
            //language=sqlite
            "SELECT value FROM app_settings WHERE name = $name AND id = $id"
        )
        .raw_query_single_row_first_column()
        .context("Error getting setting")
    }

    fn save_setting<T: AppSetting + ToSql>(
        &self,
        id: &T::IDType<'_>,
        value: &T,
    ) -> anyhow::Result<()> {
        let name = T::NAME;
        let id = id.as_str();

        prepare_cached_and_bind!(
            self,
            //language=sqlite
            "INSERT OR REPLACE INTO app_settings (name, id, value) VALUES ($name, $id, $value)"
        )
        .raw_execute()
        .context("Error setting setting")?;

        Ok(())
    }

    fn remove_settings_by_name(&self, name: &str) -> anyhow::Result<()> {
        prepare_and_bind!(
            self,
            //language=sqlite
            "DELETE FROM app_settings WHERE name = $name"
        )
        .raw_execute()
        .context("Error removing settings")?;

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::AppSettingRepositoryExt;
    use crate::app_setting::AppSetting;
    use crate::db::Repository;
    use r2d2_sqlite::SqliteConnectionManager;
    use rusqlite::types::{FromSql, ToSqlOutput};
    use rusqlite::ToSql;

    #[derive(Eq, PartialEq, Debug)]
    struct TestSetting(String);

    impl AppSetting for TestSetting {
        const NAME: &'static str = "test";
        type IDType<'a> = str;
    }

    impl ToSql for TestSetting {
        fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
            self.0.to_sql()
        }
    }

    impl FromSql for TestSetting {
        fn column_result(
            value: rusqlite::types::ValueRef<'_>,
        ) -> rusqlite::types::FromSqlResult<Self> {
            Ok(Self(value.as_str()?.to_string()))
        }
    }

    #[test]
    fn app_settings_works() {
        let repo = Repository::new(SqliteConnectionManager::memory()).expect("To create repo");

        repo.with_connection(|conn| {
            let setting1 = TestSetting("value1".to_string());
            let setting2 = TestSetting("value2".to_string());

            conn.save_setting(Default::default(), &setting1)
                .expect("To save setting");
            conn.save_setting("id1", &setting2)
                .expect("To save settings");

            let loaded_setting1: TestSetting = conn
                .load_setting::<TestSetting>(Default::default())
                .expect("To load setting1")
                .expect("To have settings1");
            let loaded_setting2: TestSetting = conn
                .load_setting::<TestSetting>("id1")
                .expect("To load setting2")
                .expect("To have settings2");

            assert_eq!(setting1, loaded_setting1);
            assert_eq!(setting2, loaded_setting2);

            conn.remove_settings_by_name(TestSetting::NAME)
                .expect("To remove settings");

            assert!(conn
                .load_setting::<TestSetting>(Default::default())
                .expect("To load setting1")
                .is_none());

            Ok(())
        })
        .unwrap();
    }
}
