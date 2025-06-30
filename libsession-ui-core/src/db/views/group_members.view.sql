-- A view that extends the information to config_group_members to source the name, avtar and other details of the group members
-- from more places
WITH normalised_config AS (
    SELECT gm.*,
        coalesce(
            -- If we have the user in the contact, use the name from there
            (SELECT nullif(config_contacts.display_name, '')
             FROM config_contacts
             WHERE config_contacts.session_id = gm.session_id),
            -- Otherwise, use the name from the member conifg
            nullif(gm.name, ''),
            -- Otherwise, look for the updated name from the cache
            (SELECT cache.value
             FROM user_cache cache
             WHERE cache.repository = gm.group_id
                 AND cache.session_id = gm.session_id
                 AND cache.cache_type = 'name')
        ) AS display_name
    FROM config_group_members gm
)
SELECT gm.group_id,
    gm.session_id,
    gm.admin,
    gm.status,
    gm.display_name,
    json_object(
        'image', json(
        coalesce(
            -- If we have the user in the contact, use the profile picture from there
            (SELECT config_contacts.profile_picture
             FROM config_contacts
             WHERE config_contacts.session_id = gm.session_id),
            -- Otherwise, use the profile picture from the member conifg
            nullif(gm.profile_picture, ''),
            -- Otherwise, look in the cache
            (SELECT cache.value
             FROM user_cache cache
             WHERE cache.repository = gm.group_id
                 AND cache.session_id = gm.session_id
                 AND cache.cache_type = 'profile_picture')
        )
                 ),
        'fallback_text', gm.display_name
    ) AS avatar,
    gm.supplement
FROM normalised_config gm;