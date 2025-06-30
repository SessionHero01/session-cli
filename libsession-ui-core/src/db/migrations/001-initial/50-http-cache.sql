CREATE TABLE http_cache (
    url TEXT NOT NULL PRIMARY KEY,
    response_status_code INTEGER NOT NULL,
    response_headers TEXT NOT NULL CHECK ( json_type(response_headers) = 'array' ),
    response BLOB NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_accessed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) WITHOUT ROWID;