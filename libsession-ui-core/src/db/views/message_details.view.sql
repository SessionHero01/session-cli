WITH
    community_moderators AS (
        SELECT
            info.community_id,
            ea.value AS session_id
        FROM community_room_info info, json_each(info.admins) ea
        UNION ALL
        SELECT
            info.community_id,
            ea.value AS session_id
        FROM community_room_info info, json_each(info.moderators) ea
    ),

    normalised_messages1 AS (
        SELECT
            CASE
                WHEN m.is_one_to_one OR
                     m.is_group OR
                     (m.is_community AND !m.is_sender_blind) THEN m.sender = my.session_id

                -- For communities, check if the sender is one of our blinded keys for this community
                WHEN m.is_community THEN EXISTS (
                    SELECT 1
                    FROM my_community_identities my
                    WHERE my.community_id = m.repository AND my.session_id = m.sender
                )

                ELSE false
                END as from_me,
            m.*
        FROM messages m, my_identity my
    ),
    normalised_messages2 AS (
        SELECT
            -- Convert the network protobuf based message into our own message format
            CASE
                -- Case for deleted message
                WHEN m.delete_state IS NOT NULL THEN
                    json_object('content', json_object('deleted', m.delete_state))

                -- Case for message request response
                WHEN m.content->>'$.messageRequestResponse.isApproved' THEN
                    json_object('control', json_object('message_approval_from_me', json(iif(m.from_me, 'true', 'false'))))

                -- Case for data screenshot taken
                WHEN m.content->>'$.dataExtractionNotification.type' = 'SCREENSHOT' THEN
                    json_object('control', json_object('screenshot_taken_from_me', json(iif(m.from_me, 'true', 'false'))))

                -- Case for media saved
                WHEN m.content->>'$.dataExtractionNotification.type' = 'MEDIA_SAVED' THEN
                    json_object('control', json_object('media_saved_from_me', json(iif(m.from_me, 'true', 'false'))))

                -- Case for legacy close group control message (no content)
                WHEN json_type(m.content, '$.dataMessage.closedGroupControlMessage') = 'object' THEN NULL

                -- Case for open group invitation
                WHEN json_type(m.content, '$.dataMessage.openGroupInvitation') = 'object' THEN
                    json_object('control', json_object('open_group_invitation', m.content->'$.dataMessage.openGroupInvitation'))

                -- Case for normal message (can be null if no content or attachment is found)
                ELSE (
                    WITH
                        attachments AS (
                            SELECT
                                value->>'$.id' AS server_id,
                                null as pending_attachment_id,
                                value->>'$.contentType' AS content_type,
                                value->>'$.fileName' AS file_name,
                                value->>'$.flags' = 1 AND value->>'$.contentType' LIKE 'audio/%' AS is_voice,
                                value->>'$.size' AS size,
                                nullif(value->>'$.thumbnail', '') AS thumbnail,
                                value->>'$.width' AS width,
                                value->>'$.height' AS height,
                                iif(
                                    m.is_community AND value ->> '$.id' IS NOT NULL,
                                    json_object('community_file', json_object('community_url', m.repository, 'community_file_id', value->>'$.id')),
                                    json_object('file', json_object('url', value->>'$.url', 'key', ifnull(value->>'$.key', '')))
                                ) AS attachment_content
                            FROM json_each(m.content->'$.dataMessage.attachments')
                            UNION ALL
                            SELECT
                                null AS server_id,
                                a.attachment_id AS pending_attachment_id,
                                a.content_type,
                                a.file_name,
                                a.content_type LIKE 'audio/%' AS is_voice,
                                length(a.content) AS size,
                                a.meta->>'$.thumbnail' AS thumbnail,
                                a.meta->>'$.width' AS width,
                                a.meta->>'$.height' AS height,
                                json_object('pending_attachment_id', a.attachment_id) AS attachment_content
                            FROM message_pending_attachments a
                            WHERE a.message_id = m.id
                        ),
                        normalised_attachments AS (
                            SELECT *,
                                content_type LIKE 'image/%' AS is_image,
                                content_type LIKE 'video/%' AS is_video
                            FROM attachments
                            ORDER BY server_id NULLS LAST, pending_attachment_id
                        ),
                        first_attachment AS (
                            SELECT * FROM normalised_attachments LIMIT 1
                        ),
                        attachment_content AS (
                            SELECT
                                CASE
                                    -- If the first valid attachment is an image then our attachments will be an array of images
                                    WHEN first.is_image THEN
                                        json_object('images',
                                                    json_object('images',
                                                                json_group_array(
                                                                    json_object('content', json(a.attachment_content),
                                                                                'width', a.width,
                                                                                'height', a.height,
                                                                                'thumbnail', a.thumbnail))) )


                                    -- If the first valid attachment is a video then our attachments will be an array of videos
                                    WHEN first.is_video THEN
                                        json_object('videos',
                                                    json_object('videos',
                                                                json_group_array(
                                                                    json_object('content', json(a.attachment_content),
                                                                                'width', a.width,
                                                                                'height', a.height,
                                                                                'thumbnail', a.thumbnail))))

                                    -- Otherwise our attachments will be an array of files
                                    ELSE json_object('files',
                                                     json_object('files',
                                                                 json_group_array(
                                                                     json_object('content', json(a.attachment_content),
                                                                                 'file_name', a.file_name,
                                                                                 'size', a.size, 'thumbnail', a.thumbnail,
                                                                                 'content_type', a.content_type))))
                                    END as content
                            FROM first_attachment first, normalised_attachments a
                        )

                    SELECT
                        CASE
                            -- If the first attachment is voice, then this message is a voice message
                            WHEN first.is_voice THEN json_object(
                                'content',
                                json_object('voice', json_object('content', json(first.attachment_content), 'duration_mills', 0)))

                            -- If there's text, this is a full message
                            WHEN content.value IS NOT NULL AND attachment.content IS NOT NULL THEN json_object(
                                'content',
                                json_object('full', json_patch(attachment.content, json_object('text', content.value))))

                            -- Attachment only message
                            WHEN attachment.content IS NOT NULL THEN json_object('content', json(attachment.content))

                            -- Text only message
                            WHEN content.value IS NOT NULL THEN json_object('content', json_object('text', content.value))
                            END
                    FROM (SELECT m.content_text AS value) content
                             LEFT JOIN first_attachment first
                             LEFT JOIN attachment_content attachment ON NOT first.is_voice AND attachment.content IS NOT NULL

                )
                END AS partial_content,

            coalesce(
                CASE
                    WHEN m.from_me THEN (SELECT name FROM config_user_profile LIMIT 1)
                    WHEN m.is_one_to_one THEN (SELECT display_name FROM config_contacts WHERE config_contacts.session_id = m.sender)
                    WHEN m.is_community THEN (SELECT c.value FROM user_cache c WHERE c.session_id = m.sender AND c.cache_type = 'name')
                    WHEN m.is_group THEN (SELECT gm.display_name FROM group_members gm WHERE gm.group_id = m.repository AND gm.session_id = m.sender)
                    END,
                m.sender) as sender_name,
            m.*
        FROM normalised_messages1 m
    ),
    normalised_messages3 AS (
        SELECT
            CASE
                WHEN json_type(m.partial_content, '$.control') = 'object' THEN json_patch(
                    m.partial_content, json_object(
                        'id', CAST(m.id AS TEXT),
                        'created_at', m.created_at)
                                                                               )
                WHEN json_type(m.partial_content, '$.content') = 'object' THEN
                    json_object(
                        'id', CAST(m.id AS TEXT),
                        'created_at', m.created_at,
                        'regular',
                        json_patch(
                            m.partial_content,
                            json_object(
                                'author_id', coalesce(nullif(m.sender, ''), m.repository),
                                'author_name', iif(
                                    m.from_me,
                                    json_object('me', json_object()),
                                    json_object('other', m.sender_name)),
                                'author_avatar', json_object(
                                    'image', json(iif(
                                    m.from_me,
                                    (SELECT p.profile_pic FROM config_user_profile p LIMIT 1),
                                    coalesce(
                                        (SELECT c.profile_picture FROM config_contacts c WHERE c.session_id = m.sender),
                                        (SELECT c.value FROM user_cache c WHERE c.repository = m.repository AND c.session_id = m.sender AND c.cache_type = 'profile_picture')
                                    )
                                                  )),
                                    'fallback_text', m.sender_name,
                                    'is_moderator', json(iif(CASE
                                                                 WHEN m.is_community THEN EXISTS (
                                                                     SELECT 1
                                                                     FROM community_moderators cm
                                                                     WHERE cm.community_id = m.repository AND cm.session_id = m.sender
                                                                 )

                                                                 WHEN m.is_group THEN EXISTS (
                                                                     SELECT 1
                                                                     FROM config_group_members gm
                                                                     WHERE gm.group_id = m.repository AND gm.session_id = m.sender AND gm.admin
                                                                 )

                                                                 ELSE false
                                                                 END, 'true', 'false'))),
                                'content', json_object(
                                    'mentions',
                                    (SELECT
                                         json_group_object(mention.value, CASE
                                             WHEN m.is_community THEN
                                                 iif(
                                                     EXISTS (SELECT 1 FROM my_community_identities my WHERE my.community_id = m.repository AND my.session_id = mention.value),
                                                     json_object('me', json_object()),
                                                     json_object('other', ifnull(
                                                         (SELECT nullif(c.value, '') FROM user_cache c WHERE c.repository = m.repository AND c.session_id = mention.value AND c.cache_type = 'name'),
                                                         mention.value)
                                                     )
                                                 )

                                             WHEN m.is_group THEN
                                                 iif(
                                                     EXISTS (SELECT 1 FROM my_identity my WHERE my.session_id = mention.value),
                                                     json_object('me', json_object()),
                                                     json_object('other', ifnull(
                                                         (SELECT nullif(gm.display_name, '') FROM group_members gm WHERE gm.group_id = m.repository AND gm.session_id = mention.value),
                                                         mention.value)
                                                     )
                                                 )

                                             WHEN m.is_one_to_one THEN
                                                 iif(
                                                     EXISTS (SELECT 1 FROM my_identity my WHERE my.session_id = mention.value),
                                                     json_object('me', json_object()),
                                                     json_object('other', ifnull(
                                                         (SELECT nullif(c.display_name, '') FROM config_contacts c WHERE c.session_id = mention.value),
                                                         mention.value)
                                                     )
                                                 )

                                             END
                                         )
                                     FROM json_each(m.mentions) mention))
                            )
                        )
                    )

                END as normalised_content,
            CASE
                WHEN m.is_community THEN (
                    SELECT json_group_array(json_object('emoji', r.emoji, 'count', r.count) ORDER BY r.`index`)
                    FROM community_message_reactions r
                    WHERE r.message_id = m.id
                )
                WHEN (m.is_group OR m.is_one_to_one) THEN (
                    WITH reactions AS (SELECT MAX(r.created_at) AS timestamp,
                                           content ->> '$.dataMessage.reaction.emoji' AS emoji,
                                           content ->> '$.dataMessage.reaction.action' AS action,
                                           r.sender AS author
                                       FROM messages r
                                       WHERE r.message_timestamp_reacted_to = m.created_at
                                       GROUP BY emoji, author),
                        reactions_by_emoji AS (SELECT emoji, COUNT(author) AS cnt, MIN(timestamp) earliest FROM reactions WHERE action = 'REACT' GROUP BY emoji)
                    SELECT json_group_array(json_object('emoji', emoji, 'count', cnt) ORDER BY cnt DESC, earliest)
                    FROM reactions_by_emoji
                )
                ELSE json_array()
                END as reactions,
            m.*
        FROM normalised_messages2 m
    )
SELECT
    m.id,
    m.repository,
    m.normalised_content as content,
    m.sender,
    m.receiver,
    m.server_id,
    m.created_at,
    m.is_one_to_one,
    m.is_community,
    m.is_group,
    m.reactions
FROM normalised_messages3 m