-- Information about a community room. Refer to https://api.oxen.io/sogs/#/rooms?id=get-room%e2%9f%aaroom%e2%9f%ab
SELECT s.id AS community_id,
    s.value ->> '$.image_id' AS image_id,
    s.value ->> '$.name' AS name,
    s.value ->> '$.active_users' AS active_users,
    s.value -> '$.moderators' AS moderators,
    s.value -> '$.admins' AS admins,
    s.value ->> '$.read' AS can_read,
    s.value ->> '$.write' AS can_write,
    s.value ->> '$.upload' AS can_upload,
    s.value ->> '$.description' AS description
FROM app_settings s
WHERE s.name = 'community_room_info';