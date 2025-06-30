-- Configs table
CREATE TABLE configs (
    config_type TEXT NOT NULL,
    id TEXT NOT NULL DEFAULT '',
    updated_at TIMESTAMP NOT NULL,
    dump BLOB,
    PRIMARY KEY (config_type, id)
) WITHOUT ROWID;

CREATE TABLE config_user_profile (
    id INTEGER PRIMARY KEY,
    blinded_msgreqs BOOLEAN,
    name TEXT,
    nts_expiry INTEGER,
    nts_priority INTEGER,
    profile_pic TEXT CHECK (profile_pic IS NULL OR json_valid(profile_pic))
);

CREATE TABLE config_contacts (
    session_id TEXT NOT NULL PRIMARY KEY,
    name TEXT,
    nickname TEXT,
    approved BOOLEAN,
    approved_me BOOLEAN,
    blocked BOOLEAN,
    profile_picture TEXT,
    priority INTEGER,
    notification_mode TEXT,

    -- Below are generated columns that are just for formatting data
    display_name TEXT GENERATED ALWAYS AS (coalesce(nullif(nickname, ''), name)) VIRTUAL,
    avatar TEXT GENERATED ALWAYS AS (json_object('image', json(profile_picture), 'fallback_text', display_name)) VIRTUAL
) WITHOUT ROWID;

CREATE TABLE config_convo_info (
    id TEXT NOT NULL,
    last_read TIMESTAMP,
    type TEXT NOT NULL,
    unread BOOLEAN,
    CONSTRAINT valid_group_id CHECK (type != 'group' OR id LIKE '03%'),
    CONSTRAINT valid_user_id CHECK (type != 'one_to_one' OR id LIKE '05%'),
    CONSTRAINT valid_community_id CHECK (type != 'community' OR (id LIKE 'http://%' OR id LIKE 'https://%')),
    PRIMARY KEY (id, type)
) WITHOUT ROWID;

CREATE TABLE config_user_groups (
    id TEXT NOT NULL,
    type TEXT NOT NULL,

    -- Common data
    name TEXT,
    notification_mode TEXT,
    mute_until TIMESTAMP, -- Mute notification until this time (in seconds), overrides the "notifications" flag
    priority INTEGER NOT NULL, -- 0 = unpinned, negative = hidden, positive = pinned (higher = pinned higher)
    joined_at TIMESTAMP, -- Join time in unix timestamp (seconds)
    invited BOOLEAN NOT NULL, -- Whether the user was invited but not yet accepted to this group

    --- Group data
    is_kicked BOOLEAN,

    CONSTRAINT valid_group_data CHECK (type != 'group' OR (id LIKE '03%' AND is_kicked IS NOT NULL)),
    CONSTRAINT valid_community_data CHECK (type != 'community' OR (id LIKE 'http://%' OR id LIKE 'https://%')),

    PRIMARY KEY (id, type)
) WITHOUT ROWID;

CREATE INDEX config_user_groups_type_priority ON config_user_groups (type, priority);
CREATE INDEX config_user_groups_type ON config_user_groups (type);


CREATE TABLE config_group_info (
    group_id TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    delete_attach_before TIMESTAMP,
    delete_before TIMESTAMP,
    expiry_timer INTEGER,
    created TIMESTAMP NULL,
    profile_pic TEXT CHECK (profile_pic IS NULL OR json_valid(profile_pic))
) WITHOUT ROWID;

CREATE TABLE config_group_members (
    group_id TEXT NOT NULL,
    session_id TEXT NOT NULL,
    admin BOOLEAN NOT NULL,
    name TEXT NOT NULL,
    profile_picture TEXT CHECK (profile_picture IS NULL OR json_valid(profile_picture)),
    status INTEGER NOT NULL, -- see members.h for all constants
    supplement BOOLEAN NOT NULL,
    PRIMARY KEY (group_id, session_id)
) WITHOUT ROWID;
