-- App settings table
CREATE TABLE app_settings (
    name TEXT NOT NULL,
    id TEXT NOT NULL DEFAULT '',
    value TEXT,
    PRIMARY KEY (name, id)
) WITHOUT ROWID;

CREATE INDEX app_settings_name ON app_settings(name);

