use crate::clock::Timestamp;
use crate::db::query::{first_json_column_row_mapper, QueryInfo, SQLRunnable};
use crate::protos;
use std::num::NonZeroUsize;

pub fn conversation_list_query(
    approved: Option<bool>,
) -> impl SQLRunnable<Item = protos::ConversationSummary> {
    QueryInfo {
        name: "Query conversation list",
        //language=sqlite
        sql: r"
             SELECT
                json_object(
                    'id', id,
                    'name', name,
                    'type', type,
                    iif(single_avatar IS NOT NULL, 'single_avatar', 'multiple_avatar'),
                    json(ifnull(single_avatar, multiple_avatar)),
                    'approved', json(iif(approved, 'true', 'false')),
                    'unread_count', unread_count,
                    'mentioned_me', json(iif(mentioned_me, 'true', 'false')),
                    'last_message', json(last_message_summary)
                ) AS item
            FROM conversations
            WHERE
                name IS NOT NULL AND
                (single_avatar IS NOT NULL OR multiple_avatar IS NOT NULL) AND
                ($1 IS NULL OR approved = $1)
            ORDER BY priority, last_message_summary->>'$.created_at' DESC, joined_at DESC, name
            ",
        params: (approved,),
        row_mapper: first_json_column_row_mapper,
    }
}

pub fn conversation_details_query(
    id: String,
) -> impl SQLRunnable<Item = protos::ConversationDetails> {
    QueryInfo {
        name: "Query conversation details",
        sql: //language=sqlite
        r"
            SELECT
                json_object(
                    'id', id,
                    'name', name,
                    'unread_count', unread_count,
                    'active_community_members', active_community_members,
                    'total_group_members', total_group_members,
                    'can_post_text', json(iif(can_post_text, 'true', 'false')),
                    'can_upload', json(iif(can_upload, 'true', 'false')),
                    'approved', json(iif(approved, 'true', 'false')),
                    iif(single_avatar IS NOT NULL, 'single_avatar', 'multiple_avatar'),
                    json(ifnull(single_avatar, multiple_avatar))
                )
            FROM conversation_details
            WHERE id = $1
            ",
        params: (id,),
        row_mapper: first_json_column_row_mapper,
    }
}

pub fn conversation_messages_query_limit(
    convo_id: String,
    until: Timestamp,
    limit: NonZeroUsize,
) -> impl SQLRunnable<Item = protos::Message> {
    QueryInfo {
        name: "Query conversation messages",
        sql: //language=sqlite
        r"
            SELECT
                json_patch(
                    md.content,
                    json_object('reactions', json(md.reactions))
                ) AS content
            FROM message_details md
            WHERE md.id IN (
                SELECT vm.id
                FROM conversation_messages vm
                WHERE vm.conversation_id = $1
                  AND vm.created_at < $2
                  AND vm.is_visible
                ORDER BY vm.created_at DESC
                LIMIT $3
            ) AND md.content IS NOT NULL
            ORDER BY md.content ->> '$.created_at' DESC
        ",
        params: (convo_id, until, limit),
        row_mapper: first_json_column_row_mapper,
    }
}

pub fn conversation_messages_query_after(
    convo_id: String,
    until: Timestamp,
    after: Timestamp,
) -> impl SQLRunnable<Item = protos::Message> {
    QueryInfo {
        name: "Query conversation messages",
        sql: //language=sqlite
        r"
            SELECT
                md.content
            FROM message_details md
            WHERE md.id IN (
                SELECT vm.id
                FROM conversation_messages vm
                WHERE vm.conversation_id = $1
                  AND vm.created_at < $2
                  AND vm.created_at >= $3
                  AND vm.is_visible
                ORDER BY vm.created_at DESC
            ) AND md.content IS NOT NULL
            ORDER BY md.content ->> '$.created_at' DESC
        ",
        params: (convo_id, until, after),
        row_mapper: first_json_column_row_mapper,
    }
}
