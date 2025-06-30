use crate::app_setting::AppSetting;
use crate::db::app_setting::AppSettingRepositoryExt;
use crate::db::http_cache::HttpCacheRepository;
use crate::db::Repository;
use anyhow::Context;
use chrono::{DateTime, TimeDelta, Utc};
use futures_util::{select, FutureExt};
use rusqlite::types::FromSql;
use rusqlite::ToSql;
use std::time::Duration;
use tokio::sync::{mpsc, oneshot};
use tokio::time::sleep;
use tracing::instrument;

struct NextTrimFileDeadline(DateTime<Utc>);

impl AppSetting for NextTrimFileDeadline {
    const NAME: &'static str = "next_trim_file_deadline";
    type IDType<'a> = ();
}

impl FromSql for NextTrimFileDeadline {
    fn column_result(value: rusqlite::types::ValueRef<'_>) -> rusqlite::types::FromSqlResult<Self> {
        DateTime::<Utc>::column_result(value).map(NextTrimFileDeadline)
    }
}

impl ToSql for NextTrimFileDeadline {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        self.0.to_sql()
    }
}

pub enum TrimFileCacheCommand {
    Trim {
        keep: Option<Duration>,
        callback: oneshot::Sender<usize>,
    },
}

#[instrument(skip(repo, command), ret)]
pub async fn trim_file_cache(
    repo: &Repository,
    max_cache: Duration,
    check_interval: Duration,
    mut command: mpsc::Receiver<TrimFileCacheCommand>,
) -> anyhow::Result<()> {
    let mut next_deadline = repo.with_transaction(|tx| {
        match tx
            .load_setting::<NextTrimFileDeadline>(&())
            .context("Failed to load trim file deadline")?
        {
            Some(v) => Ok(v),
            None => {
                let v = next_trim_file_deadline(check_interval)?;
                tx.save_setting(&(), &v)
                    .context("Failed to save trim file deadline")?;
                Ok(v)
            }
        }
    })?;

    loop {
        let delay = next_deadline
            .0
            .signed_duration_since(Utc::now())
            .to_std()
            .unwrap_or_default();
        tracing::info!("Next file trimming will be at {delay:?} later");

        let mut keep_duration = max_cache;

        let callback = select! {
            _ = sleep(delay).fuse() => None,
            cmd = command.recv().fuse() => {
                match cmd {
                    Some(TrimFileCacheCommand::Trim { keep, callback }) => {
                        if let Some(keep) = keep {
                            keep_duration = keep;
                        }

                        Some(callback)
                    },
                    _ => None,
                }
            }
        };

        let num_deleted = repo.with_connection(|conn| {
            conn.trim_cache(
                &Utc::now()
                    .checked_sub_signed(TimeDelta::from_std(keep_duration)?)
                    .context("Failed to calculate earliest time")?,
            )
        })?;

        tracing::info!("Trimmed {num_deleted} files");
        if let Some(callback) = callback {
            let _ = callback.send(num_deleted);
        }

        next_deadline = next_trim_file_deadline(check_interval)?;
        repo.with_connection(|conn| conn.save_setting(&(), &next_deadline))
            .context("Failed to save next trim file deadline")?;
    }
}

fn next_trim_file_deadline(interval: Duration) -> anyhow::Result<NextTrimFileDeadline> {
    Ok(NextTrimFileDeadline(
        Utc::now()
            .checked_add_signed(TimeDelta::from_std(interval)?)
            .context("Failed to add sign")?,
    ))
}
