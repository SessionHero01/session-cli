SELECT
    CASE
        WHEN m.repository = '' THEN coalesce(nullif(participant, ''), my.session_id)

        WHEN m.repository LIKE '03%' OR m.repository LIKE 'http://%' OR m.repository LIKE 'https://%'
            THEN m.repository

        END as conversation_id,
    m.*
FROM messages m, my_identity my