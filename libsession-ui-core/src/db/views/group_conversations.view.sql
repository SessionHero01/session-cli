SELECT groups.id,
    'GROUP' AS type,
    group_info.name,
    iif(group_info.profile_pic IS NOT NULL,
        json_object('image', json(group_info.profile_pic), 'fallback_text', group_info.name), null) AS single_avatar,
    true AS approved,
    iif(
        group_info.profile_pic IS NULL,
        json_object('avatars', json(
            (SELECT json_group_array(json(avatar))
             FROM (SELECT gm.avatar
                   FROM group_members gm
                   WHERE gm.group_id = groups.id
                   ORDER BY gm.display_name, gm.session_id DESC
                   LIMIT 10)))),
        null
    ) AS multiple_avatar,
    groups.priority,
    (SELECT md.content FROM message_details md WHERE md.id =
        (SELECT id FROM (SELECT vm.id, MAX(vm.created_at)
                         FROM messages vm INDEXED BY messages_repo_created
                         WHERE vm.repository = groups.id AND vm.is_visible AND vm.delete_state IS NULL))
    ) AS last_message_summary,
    (SELECT COUNT(m.id)
     FROM messages m INDEXED BY messages_repo_visible_created
     WHERE
         m.repository = groups.id
         AND m.is_visible
         AND m.delete_state IS NULL
         AND m.created_at > ifnull(convo.last_read, 0)) AS unread_count,
    EXISTS (
       SELECT 1 FROM
                    messages m INDEXED BY messages_repo_visible_created,
                    json_each(m.mentions) mentions
       INNER JOIN my_identity identity ON identity.session_id = mentions.value
       WHERE m.repository = groups.id
         AND m.is_visible
         AND m.delete_state IS NULL
         AND m.created_at > ifnull(convo.last_read, 0)
         AND m.sender != identity.session_id
    ) AS mentioned_me,
    groups.joined_at
FROM config_user_groups groups,
    my_identity my
        INNER JOIN config_group_info group_info ON group_info.group_id = groups.id
        LEFT JOIN config_convo_info convo ON convo.id = groups.id
WHERE groups.type = 'group' AND groups.priority != -1