-- Record the last synced server id for each repository and namespace
CREATE TABLE swarm_message_sync_state (
    session_id TEXT NOT NULL,
    node_public_key TEXT NOT NULL,
    namespace INTEGER NOT NULL,
    last_synced_hash TEXT NOT NULL,
    PRIMARY KEY (session_id, node_public_key, namespace)
) WITHOUT ROWID;

-- Record the sequence range of messages synced for each community
CREATE TABLE community_message_sync_state (
    community_id TEXT PRIMARY KEY,
    has_earlier_messages BOOLEAN NOT NULL DEFAULT TRUE,
    earliest_message_id INTEGER NOT NULL,
    latest_seq INTEGER NOT NULL
) WITHOUT ROWID;
