use crate::db::query::{SQLRowsVec, SQLRunnable};
use crate::utils::sqlite::query_meta::QueryMetaExt;
use anyhow::{Context, format_err};
use futures_core::Stream;
use parking_lot::RwLock;
use r2d2_sqlite::SqliteConnectionManager;
use rusqlite::Connection;
use rusqlite::hooks::{Action, PreUpdateCase};
use smallvec::SmallVec;
use std::cell::RefCell;
use std::collections::HashMap;
use std::ops::DerefMut;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::broadcast;
use tokio_stream::wrappers::BroadcastStream;
use tokio_stream::{StreamExt, once};

thread_local! {
    static TRACKING_TABLE_CHANGES: RefCell<SmallVec<[String; 1]>> = RefCell::new(Default::default());
}

pub struct ReactiveDatabaseManager {
    db: r2d2::Pool<SqliteConnectionManager>,
    table_change_broadcast_tx: broadcast::Sender<Arc<[String]>>,
    _table_change_broadcast_rx: broadcast::Receiver<Arc<[String]>>,
    sql_read_table_cache: Arc<RwLock<HashMap<String, Arc<[String]>>>>,
}

impl ReactiveDatabaseManager {
    pub fn new(conn: SqliteConnectionManager) -> anyhow::Result<Self> {
        let db = r2d2::Pool::new(conn.with_init(|conn| {
            conn.preupdate_hook(Some(
                |_a: Action, _db_name: &str, table: &str, _case: &PreUpdateCase| {
                    TRACKING_TABLE_CHANGES.with(|changes| {
                        let Ok(mut changes) = changes.try_borrow_mut() else {
                            tracing::warn!("Table change tracking already in progress");
                            return;
                        };

                        if let Err(insertion) = changes.binary_search_by_key(&table, |s| s.as_str())
                        {
                            changes.insert(insertion, table.to_string());
                        }
                    });
                },
            ));

            Ok(())
        }))?;

        let (table_change_broadcast_tx, _table_change_broadcast_rx) = broadcast::channel(1);

        Ok(Self {
            db,
            table_change_broadcast_tx,
            _table_change_broadcast_rx,
            sql_read_table_cache: Default::default(),
        })
    }

    fn obtain_connection(&self) -> anyhow::Result<impl DerefMut<Target = Connection> + 'static> {
        self.db
            .get_timeout(Duration::from_secs(1))
            .context("Unable to get connection from pool")
    }

    fn with_table_change_tracking<T>(
        &self,
        f: impl FnOnce() -> anyhow::Result<T>,
    ) -> anyhow::Result<T> {
        let result = f();

        let changes = TRACKING_TABLE_CHANGES.replace(Default::default());

        if result.is_ok() && !changes.is_empty() {
            if let Err(e) = self
                .table_change_broadcast_tx
                .send(changes.into_vec().into())
            {
                tracing::error!("Error sending table changes: {e:?}");
            }
        }

        result
    }

    pub fn rerun_query_on_changes<R>(
        &self,
        debounce: Duration,
        sql_runnable: R,
    ) -> anyhow::Result<
        impl Stream<Item = anyhow::Result<SQLRowsVec<R::Item>>> + Send + Sync + use<R>,
    >
    where
        R: SQLRunnable + Send + Sync,
    {
        let tables_to_watch = self
            .sql_read_table_cache
            .read()
            .get(sql_runnable.sql())
            .cloned();

        let tables_to_watch = match tables_to_watch {
            Some(tables) => tables,
            None => {
                let tables = self
                    .obtain_connection()?
                    .find_tables_read_by_sql(sql_runnable.sql(), sql_runnable.params())?;
                let tables: Arc<[String]> = Arc::from(tables);
                self.sql_read_table_cache
                    .write()
                    .insert(sql_runnable.sql().to_string(), tables.clone());
                tables
            }
        };

        tracing::debug!("Watching tables: {:?}", tables_to_watch);

        let initial = sql_runnable.run(self.obtain_connection()?.deref_mut())?;

        let db = self.db.clone();
        let subsequent = BroadcastStream::new(self.table_change_broadcast_tx.subscribe())
            .filter(move |changed| match changed {
                Ok(changed) => sorted_slices_intercept(tables_to_watch.as_ref(), changed.as_ref()), // Only pass down value when it's in watching table
                Err(_) => true, // Error will be passed down as is
            })
            .throttle(debounce)
            .map(move |r| {
                r.map_err(|e| format_err!("Table change error: {:?}", e))
                    .and_then(|r| {
                        tracing::info!("Refetching due to table change: {r:?}");
                        sql_runnable.run(db.get()?.deref_mut())
                    })
            });

        Ok(once(Ok(initial)).chain(subsequent))
    }

    pub fn with_connection<T>(
        &self,
        f: impl FnOnce(&mut Connection) -> anyhow::Result<T>,
    ) -> anyhow::Result<T> {
        self.with_table_change_tracking(|| f(self.obtain_connection()?.deref_mut()))
    }

    pub fn with_transaction<T>(
        &self,
        f: impl FnOnce(&mut rusqlite::Transaction<'_>) -> anyhow::Result<T>,
    ) -> anyhow::Result<T> {
        self.with_table_change_tracking(|| {
            let mut conn = self.obtain_connection()?;
            let mut tx = conn.transaction().context("Starting db transaction")?;
            let r = f(&mut tx)?;
            tx.commit().context("Committing db transaction")?;
            Ok(r)
        })
    }

    pub fn query<R: SQLRunnable>(&self, runnable: &R) -> anyhow::Result<SQLRowsVec<R::Item>> {
        self.with_connection(|conn| runnable.run(conn))
    }

    pub fn query_first_row<R: SQLRunnable>(&self, runnable: &R) -> anyhow::Result<Option<R::Item>> {
        self.with_connection(|conn| {
            let mut rows = runnable.run(conn)?;
            Ok(rows.pop())
        })
    }
}

fn sorted_slices_intercept(v1: &[String], v2: &[String]) -> bool {
    v1.into_iter().any(|e| v2.binary_search(e).is_ok())
}
