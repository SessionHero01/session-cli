use crate::session_id::SessionID;
use crate::sogs_api::community_id::CommunityId;
use crate::sogs_api::message::MessageId;
use crate::utils::iter::serde_iterator::IteratorExt;
use crate::utils::json::Json;
use rusqlite::{Connection, OptionalExtension};
use std::collections::HashMap;

pub struct CommunityMessageReaction<'a> {
    pub index: isize,
    pub count: usize,
    pub reactors: &'a [SessionID],
}

pub trait CommunityMessageReactionRepository {
    fn save_community_message_reactions(
        &self,
        community_id: &CommunityId,
        message_server_id: MessageId,
        reactions_by_emoji: &HashMap<&str, CommunityMessageReaction<'_>>,
    ) -> anyhow::Result<()>;
}

impl CommunityMessageReactionRepository for Connection {
    fn save_community_message_reactions(
        &self,
        community_id: &CommunityId,
        message_server_id: MessageId,
        reactions_by_emoji: &HashMap<&str, CommunityMessageReaction<'_>>,
    ) -> anyhow::Result<()> {
        let Some(message_id) = self
            .query_row(
                //language=sqlite
                "SELECT id FROM messages WHERE repository = ? AND server_id = ?",
                (community_id, message_server_id),
                |r| r.get::<_, i64>(0),
            )
            .optional()?
        else {
            return Ok(());
        };

        // Remove the ones that are not in the new reactions
        self.prepare_cached(
            //language=sqlite
            "DELETE FROM community_message_reactions 
                 WHERE message_id = ? 
                       AND emoji NOT IN (SELECT value FROM json_each(?))",
        )?
        .execute((message_id, Json(reactions_by_emoji.keys().to_ser())))?;

        let mut stmt = self.prepare_cached(
            //language=sqlite
            "INSERT OR REPLACE INTO
                community_message_reactions(message_id, emoji, `index`, count, reactors)
            VALUES (?, ?, ?, ?, ?)",
        )?;

        for (emoji, reaction) in reactions_by_emoji {
            stmt.execute((
                message_id,
                emoji,
                reaction.index,
                reaction.count as i64,
                Json(reaction.reactors.iter().to_ser()),
            ))?;
        }

        Ok(())
    }
}
