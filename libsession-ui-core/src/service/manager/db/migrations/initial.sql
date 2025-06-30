CREATE TABLE accounts (
    session_id TEXT PRIMARY KEY COLLATE NOCASE,
    name TEXT,
    avatar_image BLOB,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
