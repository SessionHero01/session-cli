-- A view that returns the public identities of all communities
SELECT s.id AS community_id,
    ea.value AS session_id
FROM app_settings s, json_each(s.value) ea
WHERE name = 'community_pub_keys';