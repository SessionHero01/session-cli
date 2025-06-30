CREATE VIRTUAL TABLE messages_body_fts USING fts5(
    message_id,
    text_body
);

-- Insert message body into the FTS table when a message is inserted
CREATE TRIGGER messages_body_fts_insert AFTER INSERT ON messages
    WHEN NEW.content_text IS NOT NULL
BEGIN
    INSERT INTO messages_body_fts (message_id, text_body)
    VALUES (NEW.id, NEW.content_text);
END;

-- Update message body in the FTS table when a message is updated
CREATE TRIGGER messages_body_fts_update AFTER UPDATE ON messages
    WHEN NEW.content_text IS NOT NULL
    BEGIN
        INSERT OR REPLACE INTO messages_body_fts (message_id, text_body)
        VALUES (NEW.id, NEW.content_text);
    END;

-- Delete message body in the FTS table when a message is updated to have no body
CREATE TRIGGER messages_body_fts_update_delete AFTER UPDATE ON messages
    WHEN NEW.content_text IS NULL
    BEGIN
        DELETE FROM messages_body_fts WHERE message_id = NEW.id;
    END;

-- Delete message body in the FTS table when a message is deleted
CREATE TRIGGER messages_body_fts_delete AFTER DELETE ON messages
    BEGIN
        DELETE FROM messages_body_fts WHERE message_id = OLD.id;
    END;