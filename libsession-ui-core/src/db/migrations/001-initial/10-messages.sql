CREATE TABLE messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Where the message is stored remotely.
    -- For your own messages, this is empty.
    -- For group messages, this is the group session id (03xxx)
    -- For community messages, this is the community id (url + room name) (http://server/room, https://server/room)
    repository TEXT NOT NULL COLLATE NOCASE,

    -- The server id of the message. This is used to identify the message on the server.
    -- For a swarm message (own or groups), this is a hash of the message content.
    -- For a community message, this is the message id on the server.
    -- In any case, this should be treated as a black box of data and shall not be interpreted in any way by the client.
    server_id TEXT NULL DEFAULT NULL,

    content TEXT NOT NULL CHECK (json_valid(content)),
    content_text TEXT GENERATED ALWAYS AS (content ->> '$.dataMessage.body') VIRTUAL, -- The text content of the message. This is used for searching and displaying the message.

    -- Sender of this message. It's set to empty if the message is sent by the "owner" of the repository.
    -- For example, if the repository is empty
    sender TEXT NOT NULL COLLATE NOCASE,
    receiver TEXT NOT NULL COLLATE NOCASE,
    created_at TIMESTAMP NOT NULL,
    sent_at TIMESTAMP,
    expiration_at TIMESTAMP,

    participant TEXT GENERATED ALWAYS AS (coalesce(nullif(sender, ''), receiver)) VIRTUAL, -- The participant of the message. This is the other party in a one-to-one conversation, or the sender in a group conversation.

    is_one_to_one BOOLEAN GENERATED ALWAYS AS (repository = '') VIRTUAL , -- Whether this is a one-to-one conversation.
    is_group BOOLEAN GENERATED ALWAYS AS (repository LIKE '03%') VIRTUAL, -- Whether this is a group conversation.
    is_community BOOLEAN GENERATED ALWAYS AS (repository LIKE 'http://%' OR repository LIKE 'https://%') VIRTUAL, -- Whether this is a community conversation.

    is_visible BOOLEAN GENERATED ALWAYS AS (
        -- Has text content
        length(content_text) > 0
            -- OR is message request response
            OR content ->> '$.messageRequestResponse.isApproved'
            -- Or is a data extraction notification
            OR json_type(content, '$.dataExtractionNotification.type') = 'string'
            -- Or is an open group invitation
            OR json_type(content, '$.dataMessage.openGroupInvitation') = 'object'
            -- Or is one of the displayable group update messages
            OR json_type(content, '$.groupUpdateMessage.infoChangeMessage') = 'object'
            OR json_type(content, '$.groupUpdateMessage.memberChangeMessage') = 'object'
            OR json_type(content, '$.groupUpdateMessage.memberLeftNotificationMessage') = 'object'
            -- Or an attachment is present
            OR json_array_length(content -> '$.dataMessage.attachments') > 0
            -- Or the message has been deleted (implies that the message was visible)
            OR delete_state IS NOT NULL
        ) VIRTUAL , -- Whether this message should be displayed to the user. This logic must match the one in message details view

    message_timestamp_reacted_to INTEGER GENERATED ALWAYS AS (content ->> '$.dataMessage.reaction.id') VIRTUAL, -- The created_at of the message that this message is reacting to.

    -- A list of mentions that comes within the message text. This information should already exist in the
    -- content field, however sqlite is not able to do the extraction easily, hence the developers are responsible
    -- for updating this field.
    mentions TEXT CHECK ( mentions IS NULL OR json_array_length(mentions) > 0 ),
    delete_state TEXT DEFAULT NULL CHECK (delete_state IS NULL OR delete_state IN ('DELETED_LOCALLY', 'DELETED')),

    -- The state of syncing the message to the message's repository.
    -- For 1to1 message, this is for sending to your own swarm,
    -- For groups, this is for sending to the group swarm;
    -- For communities, this is the state for sending to the community server
    sync_state TEXT DEFAULT NULL CHECK ((sync_state IS NULL AND server_id IS NOT NULL) OR sync_state IN ('Queued', 'PermanentlyFailed', 'Failed')),

    -- The state of sending the message to other party's swarm. Right now only 1to1 messages have these.
    send_state TEXT DEFAULT NULL CHECK (send_state IS NULL OR send_state IN ('Queued', 'PermanentlyFailed', 'Failed')),

    -- The receipt for this message. This is used to track the delivery status of the message. Currently only 1to1 messages have this.
    receipt TEXT DEFAULT NULL CHECK (receipt IS NULL OR receipt IN ('DELIVERY', 'READ'))
);

CREATE UNIQUE INDEX messages_repo_hash ON messages(repository, server_id);
CREATE INDEX messages_repo_created ON messages(repository, created_at);
CREATE INDEX messages_repo_sender_receiver ON messages(repository, sender, receiver);
CREATE INDEX messages_repo_sender_visible_created ON messages(repository, sender, is_visible, created_at);
CREATE INDEX messages_repo_visible_created ON messages(repository, is_visible, created_at);
CREATE INDEX messages_repo_sender ON messages(repository, sender);
CREATE INDEX messages_repo_participant ON messages(repository, participant);
CREATE INDEX messages_repo_participant_created ON messages(repository, participant, created_at);
CREATE INDEX messages_repo_participant_visible_created ON messages(repository, participant, is_visible, created_at);
CREATE INDEX message_reaction_id ON messages(message_timestamp_reacted_to);
CREATE INDEX message_send_status ON messages(repository, send_state);
CREATE INDEX message_sync_state ON messages(repository, sync_state);
