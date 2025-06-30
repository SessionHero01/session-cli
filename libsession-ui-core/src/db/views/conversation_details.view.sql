SELECT
    convo_list.id,
    convo_list.name,
    convo_list.unread_count,
    convo_info.last_read,
    convo_list.single_avatar,
    convo_list.multiple_avatar,
    convo_list.approved,

    room_info.active_users AS active_community_members, -- Active members in a community

    iif(
        convo_list.type = 'GROUP',
        (SELECT COUNT(gm.session_id) FROM config_group_members gm WHERE gm.group_id = convo_list.id),
        null
    ) as total_group_members, -- Total members in a group

    CASE convo_list.type
        WHEN 'COMMUNITY' THEN coalesce(room_info.can_write, false)
        WHEN 'GROUP' THEN NOT ug.is_kicked
        ELSE true
        END as can_post_text, -- Whether the user can post text messages

    CASE convo_list.type
        WHEN 'COMMUNITY' THEN coalesce(room_info.can_upload, false)
        WHEN 'GROUP' THEN NOT ug.is_kicked
        ELSE coalesce(c.approved_me, false)
        END as can_upload -- Whether the user can upload files
FROM conversations convo_list
         LEFT JOIN config_convo_info convo_info ON
    (convo_list.type != 'COMMUNITY' AND convo_info.id = convo_list.id) OR
        (convo_info.id = convo_list.id)
         LEFT JOIN config_contacts c ON (convo_list.type = 'ONE_TO_ONE' AND c.session_id = convo_list.id)
         LEFT JOIN community_room_info room_info ON (convo_list.type = 'COMMUNITY' AND room_info.community_id = convo_list.id)
         LEFT JOIN config_user_groups ug ON (convo_list.type = 'GROUP' AND ug.id = convo_list.id)