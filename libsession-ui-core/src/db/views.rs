use anyhow::Context;
use hmac::digest::Digest;
use include_dir::{include_dir, Dir};
use rusqlite::{prepare_and_bind, Connection, OptionalExtension};

static VIEWS_DIR: Dir<'_> = include_dir!("$CARGO_MANIFEST_DIR/src/db/views");

pub(super) fn upgrade_views(conn: &Connection) -> anyhow::Result<()> {
    let mut query_view_hash = conn.prepare(
        // language=sqlite
        "SELECT hash FROM view_versions WHERE view_name = ?",
    )?;

    for file in VIEWS_DIR.files() {
        let file_name = file
            .path()
            .file_name()
            .context("File name doesn't exist")?
            .to_str()
            .context("Invalid filename")?;

        let Some(view_name) = file_name.strip_suffix(".view.sql") else {
            tracing::warn!("File {file_name} is not a view, skipping");
            continue;
        };

        let file_hash = format!("{:X}", sha2::Sha256::digest(file.contents()));

        match query_view_hash
            .query_row((view_name,), |row| row.get::<_, String>(0))
            .optional()?
        {
            Some(old_hash) if old_hash == file_hash => {
                tracing::info!("View {view_name} is up to date");
            }

            _ => {
                tracing::info!("Creating/upgrading view {view_name}");
                let query =
                    std::str::from_utf8(file.contents()).context("Invalid UTF-8 in view")?;

                conn.execute_batch(&format!(
                    "DROP VIEW IF EXISTS {view_name};
                     CREATE VIEW {view_name} AS
                    {query}"
                ))
                .with_context(|| format!("Error creating view {view_name}"))?;

                prepare_and_bind!(
                    conn,
                    // language=sqlite
                    "INSERT OR REPLACE INTO view_versions (view_name, hash) VALUES ($view_name, $file_hash)"
                ).raw_execute().context("Failed to update view hash")?;
            }
        }
    }

    Ok(())
}
