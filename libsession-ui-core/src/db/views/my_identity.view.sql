-- A view that returns the public identity of current user
SELECT value ->> '$.session_id' AS session_id
FROM app_settings
WHERE name = 'identity' AND id = ''
LIMIT 1;
