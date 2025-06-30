CREATE TABLE community_message_reactions (
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    emoji TEXT NOT NULL,                                          -- The actual emoji (e.g. '👍')
    `index` INTEGER NOT NULL,                                     -- Index of the emoji in the message (used for sorting)
    count INTEGER NOT NULL,                                       -- Number of reactors in total
    reactors TEXT NOT NULL CHECK (json_type(reactors) = 'array'), -- Array of user ids
    PRIMARY KEY (message_id, emoji)
);

CREATE INDEX community_message_reactions_message_id_index ON community_message_reactions(message_id);
