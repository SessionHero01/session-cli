-- Caching table for groups/communities
CREATE TABLE user_cache (
    repository TEXT NOT NULL,
    session_id TEXT NOT NULL,
    cache_type TEXT NOT NULL,
    value TEXT NOT NULL,
    data_timestamp TIMESTAMP NOT NULL,
    PRIMARY KEY (repository, session_id, cache_type)
) WITHOUT ROWID;

-- Indexes for user_cache
CREATE INDEX user_cache_repo ON user_cache(repository);
CREATE INDEX user_cache_session_id ON user_cache(session_id);

-- A trigger for user_cache that ignore the update if the data_timestamp is older than the current data
CREATE TRIGGER user_cache_update_timestamp
    BEFORE UPDATE OF value
    ON user_cache
BEGIN
    SELECT RAISE(IGNORE) WHERE NEW.data_timestamp < OLD.data_timestamp;
END;

-- A trigger on messages that saves the latest user profile name into the user_cache
CREATE TRIGGER user_cache_insert_name
    AFTER INSERT
    ON messages
    WHEN (NEW.repository LIKE 'http://%' OR NEW.repository LIKE 'https://%' OR NEW.repository LIKE '03%')
        AND NEW.sender != ''
        AND (nullif(NEW.content ->> '$.dataMessage.profile.displayName', '') IS NOT NULL
            OR nullif(NEW.content ->> '$.messageRequestResponse.profile.displayName', '') IS NOT NULl)

BEGIN
    INSERT OR
    REPLACE
    INTO user_cache (repository, session_id, cache_type, value, data_timestamp)
    VALUES (NEW.repository,
            NEW.sender,
            'name',
            coalesce(
                NEW.content ->> '$.dataMessage.profile.displayName',
                NEW.content ->> '$.messageRequestResponse.profile.displayName'
            ),
            NEW.created_at);
END;



-- A trigger on message that saves the latest user profile picture into the user_cache
CREATE TRIGGER user_cache_insert_profile_pic
    AFTER INSERT
    ON messages
    WHEN (NEW.repository LIKE 'http://%' OR NEW.repository LIKE 'https://%' OR NEW.repository LIKE '03%')
        AND NEW.sender != ''
        AND (nullif(NEW.content ->> '$.dataMessage.profile.profilePicture', '') IS NOT NULL
            OR nullif(NEW.content ->> '$.messageRequestResponse.profile.profilePicture', '') IS NOT NULL)
BEGIN
    INSERT OR
    REPLACE
    INTO user_cache (repository, session_id, cache_type, value, data_timestamp)
    VALUES (NEW.repository,
            NEW.sender,
            'profile_picture',
            iif(
                nullif(NEW.content ->> '$.dataMessage.profile.profilePicture', '') IS NOT NULL,
                json_object(
                    'url', NEW.content ->> '$.dataMessage.profile.profilePicture',
                    'key', NEW.content ->> '$.dataMessage.profileKey'
                ),
                json_object(
                    'url', NEW.content ->> '$.messageRequestResponse.profile.profilePicture',
                    'key', NEW.content ->> '$.messageRequestResponse.profile.profileKey'
                )
            ),
            NEW.created_at);
END;

-- Create trigger on configs table that if the user groups config is deleted, delete all user_cache entries
CREATE TRIGGER user_cache_delete_community_on_delete_config
    AFTER DELETE
    ON config_user_groups
    WHEN OLD.type = 'community'
BEGIN
    DELETE
    FROM user_cache
    WHERE repository = OLD.id;
END;