use super::query::{QueryInfo, SQLRunnable};
use crate::network::NodeAddress;
use crate::oxenss::namespace::MessageNamespace;
use crate::session_id::IndividualOrGroupID;
use crate::sogs_api::community_id::CommunityId;
use crate::sogs_api::message::{MessageId, MessageSeqNo};
use rusqlite::{Connection, Row};

#[derive(Debug, Eq, PartialEq)]
pub struct SwarmMessageSyncState {
    pub last_synced_hash: String,
}

#[derive(Debug, Eq, PartialEq)]
pub struct CommunityMessageSyncState {
    pub has_earlier_messages: bool,
    pub earliest_message_id: MessageId,
    pub latest_seq: MessageSeqNo,
}

pub fn get_swarm_message_sync_state_query(
    ns: MessageNamespace,
    session_id: &IndividualOrGroupID,
    node_address: &NodeAddress,
) -> impl SQLRunnable<Item = SwarmMessageSyncState> {
    QueryInfo {
        name: "get_swarm_message_sync_state",
        //language=sqlite
        sql: "SELECT last_synced_hash FROM swarm_message_sync_state WHERE session_id = ? AND namespace = ? AND node_public_key = ?",
        params: (session_id, ns as isize, node_address.pub_key.hex()),
        row_mapper: |r: &Row| {
            Ok(SwarmMessageSyncState {
                last_synced_hash: r.get(0)?,
            })
        },
    }
}

pub fn get_community_message_sync_state_query(
    id: CommunityId,
) -> impl SQLRunnable<Item = CommunityMessageSyncState> {
    QueryInfo {
        name: "get_community_message_sync_state",
        //language=sqlite
        sql: "SELECT has_earlier_messages, earliest_message_id, latest_seq FROM community_message_sync_state WHERE community_id = ?",
        params: [id],
        row_mapper: |r: &Row| {
            Ok(CommunityMessageSyncState {
                has_earlier_messages: r.get(0)?,
                earliest_message_id: r.get(1)?,
                latest_seq: r.get(2)?,
            })
        },
    }
}

pub trait MessageSyncStateRepository {
    fn save_swarm_message_sync_state(
        &self,
        ns: MessageNamespace,
        session_id: &IndividualOrGroupID,
        node_address: &NodeAddress,
        state: &SwarmMessageSyncState,
    ) -> anyhow::Result<()>;

    fn save_community_message_sync_state(
        &self,
        id: &CommunityId,
        state: &CommunityMessageSyncState,
    ) -> anyhow::Result<()>;
}

impl MessageSyncStateRepository for Connection {
    fn save_swarm_message_sync_state(
        &self,
        ns: MessageNamespace,
        session_id: &IndividualOrGroupID,
        node_address: &NodeAddress,
        state: &SwarmMessageSyncState,
    ) -> anyhow::Result<()> {
        self.execute(
            //language=sqlite
            "INSERT OR REPLACE INTO swarm_message_sync_state(session_id, namespace, node_public_key, last_synced_hash) VALUES (?, ?, ?, ?)",
            (session_id, ns as isize, node_address.pub_key.hex(), &state.last_synced_hash),
        )?;
        Ok(())
    }

    fn save_community_message_sync_state(
        &self,
        id: &CommunityId,
        state: &CommunityMessageSyncState,
    ) -> anyhow::Result<()> {
        self.execute(
            //language=sqlite
            "INSERT OR REPLACE INTO community_message_sync_state(community_id, has_earlier_messages, earliest_message_id, latest_seq) VALUES (?, ?, ?, ?)",
            (id, state.has_earlier_messages, state.earliest_message_id, state.latest_seq),
        )?;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::identity::Identity;
    use crate::key::ed25519::{ED25519PubKey, gen_pair};
    use r2d2_sqlite::SqliteConnectionManager;

    #[test]
    fn test_saving_swarm_sync_state() {
        let repo = super::super::Repository::new(SqliteConnectionManager::memory()).unwrap();
        let session_id: IndividualOrGroupID =
            Identity::new(gen_pair()).individual_id().clone().into();

        let expect_state = SwarmMessageSyncState {
            last_synced_hash: "hash".to_string(),
        };

        let node_address = NodeAddress {
            addr: "1.2.3.4:5000".parse().unwrap(),
            pub_key: ED25519PubKey::from([0u8; 32]),
            x25519_pub_key: None,
        };

        repo.with_connection(|c| {
            c.save_swarm_message_sync_state(
                MessageNamespace::UserMessages,
                &session_id,
                &node_address,
                &expect_state,
            )
        })
        .unwrap();

        let actual_state = repo
            .query_first_row(&get_swarm_message_sync_state_query(
                MessageNamespace::UserMessages,
                &session_id,
                &node_address,
            ))
            .unwrap()
            .unwrap();

        assert_eq!(expect_state, actual_state);
    }

    #[test]
    fn test_saving_community_sync_state() {
        let repo = super::super::Repository::new(SqliteConnectionManager::memory()).unwrap();
        let community_id: CommunityId = "https://community/room".parse().unwrap();

        let expect_state = CommunityMessageSyncState {
            has_earlier_messages: true,
            earliest_message_id: 1,
            latest_seq: 2,
        };

        repo.with_connection(|c| c.save_community_message_sync_state(&community_id, &expect_state))
            .unwrap();

        let actual_state = repo
            .query_first_row(&get_community_message_sync_state_query(
                community_id.clone(),
            ))
            .unwrap()
            .unwrap();

        assert_eq!(expect_state, actual_state);
    }
}
