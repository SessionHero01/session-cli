CREATE TABLE blind_id_mappings (
    blind_id TEXT NOT NULL PRIMARY KEY COLLATE NOCASE,
    session_id TEXT NOT NULL COLLATE NOCASE,

    CONSTRAINT valid_blind_id CHECK (blind_id LIKE '15%' OR blind_id LIKE '25%'),
    CONSTRAINT valid_session_id CHECK (session_id LIKE '05%')
);

CREATE INDEX blind_id_mappings_session_id ON blind_id_mappings (session_id);

CREATE TRIGGER blind_id_mappings_groups_insert
AFTER INSERT ON config_user_groups
WHEN type = 'community'
BEGIN
   INSERT INTO blind_id_mappings(blind_id, session_id)
   VALUES (
        SELECT j.value, c.session_id FROM config_contacts c
        LEFT JOIN json_each(blind_ids(NEW.server_pub_key, c.session_id)) j
   );
END;

CREATE TRIGGER blind_id_mappings_contacts_insert
AFTER INSERT ON config_contacts
BEGIN
    INSERT INTO blind_id_mappings(blind_id, session_id)
    VALUES (
       SELECT j.value, c.session_id
       FROM config_contacts c
       LEFT JOIN json_each(blind_ids(NEW.server_pub_key, c.session_id)) j
    );
END;