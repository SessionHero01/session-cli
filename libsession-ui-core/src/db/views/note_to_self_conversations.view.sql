SELECT my.session_id AS id,
    'NOTE_TO_SELF' AS type,
    null AS name,
    null AS single_avatar,
    true AS approved,
    null AS multiple_avatar,
    p.nts_priority AS priority,
    (SELECT md.content
     FROM message_details md
     WHERE md.id = ((SELECT id
                     FROM (SELECT vm.id, MAX(vm.created_at)
                           FROM messages vm INDEXED BY messages_repo_participant_created
                           WHERE vm.repository = my.session_id AND vm.participant = '' AND vm.is_visible AND vm.delete_state IS NULL)))) AS last_message_summary,
    0 AS unread_count,
    0 AS mentioned_me,
    null AS joined_at
FROM my_identity my,
    config_user_profile p
WHERE p.nts_priority != -1