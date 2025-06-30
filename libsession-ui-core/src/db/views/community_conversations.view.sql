SELECT groups.id,
    'COMMUNITY' AS type,
    info.name,
    iif(nullif(info.image_id, '') IS NULL,
        json_object('empty', json_object()),
        json_object('community_image', json_object(
                        'community_url', groups.id,
                        'community_file_id', info.image_id))
    ) AS single_avatar,
    true AS approved,
    null AS multiple_avatar,
    groups.priority,
    (SELECT md.content
     FROM message_details md
     WHERE md.id = (SELECT id
                    FROM (SELECT vm.id, MAX(vm.created_at)
                          FROM messages vm INDEXED BY messages_repo_created
                          WHERE vm.repository = groups.id AND vm.is_visible AND vm.delete_state IS NULL))) last_message_summary,
    (SELECT COUNT(m.id)
     FROM messages m INDEXED BY messages_repo_visible_created
     WHERE m.repository = groups.id
         AND m.is_visible
         AND m.delete_state IS NULL
         AND m.created_at > ifnull(convo.last_read, 0)) AS unread_count,
    EXISTS (
        SELECT 1 FROM
                    messages m INDEXED BY messages_repo_visible_created,
                    json_each(m.mentions) mentions
        INNER JOIN my_community_identities identities ON identities.community_id = groups.id AND m.sender != mentions.value AND identities.session_id = mentions.value
        WHERE m.repository = groups.id
            AND m.is_visible
            AND m.delete_state IS NULL
            AND m.created_at > ifnull(convo.last_read, 0)
    ) AS mentioned_me,
    groups.joined_at
FROM config_user_groups groups
         INNER JOIN community_room_info info ON info.community_id = groups.id
         LEFT JOIN config_convo_info convo ON convo.id = groups.id
WHERE groups.type = 'community';