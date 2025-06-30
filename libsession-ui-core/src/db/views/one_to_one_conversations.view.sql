SELECT c.session_id AS id,
    'ONE_TO_ONE' AS type,
    c.display_name AS name,
    c.avatar AS single_avatar,
    c.approved AS approved,
    null AS multiple_avatar,
    c.priority AS priority,
    (SELECT md.content FROM message_details md WHERE md.id =
        (SELECT id FROM (SELECT vm.id, MAX(vm.created_at)
                         FROM messages vm INDEXED BY messages_repo_participant_created
                         WHERE vm.repository = my.session_id AND vm.participant = c.session_id
                             AND vm.is_visible AND vm.delete_state IS NULL))
    ) AS last_message_summary,
    (SELECT COUNT(m.id)
     FROM messages m INDEXED BY messages_repo_participant_visible_created
     WHERE m.repository = my.session_id
         AND m.participant = c.session_id
         AND created_at > ifnull(convo.last_read, 0)
         AND m.is_visible
         AND m.delete_state IS NULL) AS unread_count,
    EXISTS (
       SELECT 1 FROM messages m INDEXED BY messages_repo_visible_created
       INNER JOIN json_each(m.mentions) mentions
       WHERE m.repository = my.session_id
         AND m.is_visible
         AND m.delete_state IS NULL
         AND m.created_at > ifnull(convo.last_read, 0)
         AND m.sender != ''
    ) AS mentioned_me,
    null AS joined_at
FROM config_contacts c, my_identity my
                            LEFT JOIN config_convo_info convo ON convo.id = c.session_id
WHERE c.priority != -1 AND c.session_id != my.session_id AND c.session_id LIKE '05%' AND NOT c.blocked;