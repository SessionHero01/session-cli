SELECT * FROM one_to_one_conversations
UNION ALL
SELECT * FROM group_conversations
UNION ALL
SELECT * FROM community_conversations
UNION ALL
SELECT * FROM note_to_self_conversations;