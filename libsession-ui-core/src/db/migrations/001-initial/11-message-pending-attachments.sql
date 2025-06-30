-- A table to store message's attachments that are not yet uploaded to the server.
CREATE TABLE message_pending_attachments (
    message_id INTEGER NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    attachment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_name TEXT,
    content_type TEXT NOT NULL,
    content BLOB NOT NULL,
    status TEXT,
    meta TEXT CHECK ( meta IS NULL OR json_valid(meta) )
);