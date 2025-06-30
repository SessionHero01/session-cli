use crate::clock::Timestamp;
use crate::config::contacts::Contact;
use crate::config::user_profile::UserProfilePicExt;
use crate::config::{
    Config, ContactsConfig, ConvoInfoVolatileConfig, Group, GroupInfoConfig, GroupKeys,
    GroupMemberConfig, GroupType, UserGroupsConfig, UserProfileConfig,
};
use crate::session_id::GroupID;
use crate::utils::iter::serde_iterator::SerdeIterator;
use crate::utils::json::Json;
use crate::utils::sqlite::statement_ext::StatementExt;
use anyhow::Context;
use rusqlite::{Connection, ToSql, params, prepare_and_bind};

pub trait SaveAsRows {
    fn save_as_rows(&self, id: Option<&str>, conn: &Connection) -> anyhow::Result<()>;
}

pub trait ConfigRepositoryExt {
    fn save_config_dump_and_rows<C: Config + SaveAsRows>(
        &self,
        config: &mut C,
        id: Option<&str>,
        timestamp: Timestamp,
    ) -> anyhow::Result<()>;

    fn save_config_dump<C: Config>(
        &self,
        config: &mut C,
        id: Option<&str>,
        timestamp: Timestamp,
    ) -> anyhow::Result<()>;

    fn remove_group_configs(&mut self, id: &GroupID) -> anyhow::Result<()>;

    fn get_config_dump(
        &self,
        config_type: &str,
        id: Option<&str>,
    ) -> anyhow::Result<Option<Vec<u8>>>;
}

impl ConfigRepositoryExt for Connection {
    fn save_config_dump_and_rows<C: Config + SaveAsRows>(
        &self,
        config: &mut C,
        arg: Option<&str>,
        timestamp: Timestamp,
    ) -> anyhow::Result<()> {
        if config.needs_dump() {
            save_config(self, config, arg, timestamp)?;
            config.save_as_rows(arg, self)
        } else {
            Ok(())
        }
    }

    fn save_config_dump<C: Config>(
        &self,
        config: &mut C,
        id: Option<&str>,
        timestamp: Timestamp,
    ) -> anyhow::Result<()> {
        save_config(self, config, id, timestamp)
    }

    fn remove_group_configs(&mut self, id: &GroupID) -> anyhow::Result<()> {
        let sp = self.savepoint()?;

        prepare_and_bind!(
            sp,
            //language=sqlite
            "DELETE FROM configs WHERE id = $id"
        )
        .raw_execute()
        .context("Delete group dump")?;

        prepare_and_bind!(
            sp,
            //language=sqlite
            "DELETE FROM config_group_info WHERE group_id = $id"
        )
        .raw_execute()
        .context("Delete group info")?;

        prepare_and_bind!(
            sp,
            //language=sqlite
            "DELETE FROM config_group_members WHERE group_id = $id"
        )
        .raw_execute()
        .context("Delete group members")?;

        sp.commit().context("Commit groups config")
    }

    fn get_config_dump(
        &self,
        config_type: &str,
        id: Option<&str>,
    ) -> anyhow::Result<Option<Vec<u8>>> {
        let id = id.unwrap_or_default();
        prepare_and_bind!(
            self,
            //language=sqlite
            "SELECT dump FROM configs WHERE config_type = $config_type AND id = $id"
        )
        .raw_query_single_row_first_column()
        .context("Getting config dump")
    }
}

fn save_config_dump_raw(
    conn: &Connection,
    config_type: &str,
    id: impl ToSql,
    dump: Option<&[u8]>,
    timestamp: Timestamp,
) -> anyhow::Result<usize> {
    prepare_and_bind!(
        conn,
        //language=sqlite
        "INSERT OR REPLACE INTO configs (config_type, id, dump, updated_at)
                VALUES ($config_type, coalesce($id, ''), $dump, $timestamp)"
    )
    .raw_execute()
    .context("Error saving config")
}

fn save_config<C: Config>(
    conn: &Connection,
    c: &mut C,
    id: impl ToSql,
    timestamp: Timestamp,
) -> anyhow::Result<()> {
    let dump = c.dump();
    let dump = dump.as_ref().map(|r| r.as_ref());
    save_config_dump_raw(conn, C::CONFIG_TYPE_NAME, id, dump, timestamp)?;
    Ok(())
}

impl SaveAsRows for UserProfileConfig {
    fn save_as_rows(&self, _id: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        conn.execute(
            //language=sqlite
            "INSERT OR REPLACE INTO config_user_profile (id, blinded_msgreqs, name, nts_expiry, nts_priority, profile_pic)
                VALUES (1, ?, ?, ?, ?, ?)",
            params![
                self.accepts_blinded_msgreqs(),
                self.name(),
                self.nts_expiry(),
                self.nts_priority(),
                Json(self.profile_pic()),
            ],
        )?;

        Ok(())
    }
}

impl SaveAsRows for ContactsConfig {
    fn save_as_rows(&self, _id: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        let contacts = self.all().collect::<Vec<_>>();

        // Remove all contacts that are not part of the new list from the db and the list
        conn.execute(
            //language=sqlite
            "DELETE FROM config_contacts WHERE session_id NOT IN (SELECT value FROM json_each(?))",
            [&Json(SerdeIterator::new(
                contacts
                    .iter()
                    .filter_map(Contact::session_id)
                    .map(|s| s.to_string()),
            ))],
        )?;

        // Add or replace existing contacts
        let mut stmt = conn.prepare(
            //language=sqlite
            "INSERT OR REPLACE INTO config_contacts (session_id, name, nickname, approved, approved_me, blocked, profile_picture, priority, notification_mode)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        )?;

        for contact in contacts {
            let session_id = contact.session_id().context("Invalid session ID")?;
            stmt.execute(params![
                session_id,
                contact.name(),
                contact.nickname(),
                contact.approved,
                contact.approved_me,
                contact.blocked,
                Json(contact.profile_pic.to_encrypted_file()),
                contact.priority,
                contact.notification_mode()
            ])?;
        }

        Ok(())
    }
}

impl SaveAsRows for ConvoInfoVolatileConfig {
    fn save_as_rows(&self, _id: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        let convos = self.all().collect::<Vec<_>>();

        // Delete non-existent records
        conn.execute(
            //language=sqlite
            "DELETE FROM config_convo_info WHERE (id, type) NOT IN (
                SELECT value ->> '$[0]', value ->> '$[1]' FROM json_each(?))",
            [&Json(SerdeIterator::new(
                convos.iter().map(|c| (c.id(), c.item_type())),
            ))],
        )?;

        // Add or replace existing records
        let mut stmt = conn.prepare(
            //language=sqlite
            "INSERT OR REPLACE INTO config_convo_info (id, last_read, type, unread)
                VALUES (?, ?, ?, ?)",
        )?;

        for item in convos {
            let id = item.id().context("Invalid ID")?.to_string();
            stmt.execute(params![
                id,
                item.last_read(),
                item.item_type(),
                item.unread()
            ])?;
        }

        Ok(())
    }
}

impl SaveAsRows for UserGroupsConfig {
    fn save_as_rows(&self, _arg: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        let groups = self.get_groups().collect::<Vec<_>>();

        // Delete all the existing records first
        conn.execute(
            //language=sqlite
            "DELETE FROM config_user_groups WHERE (id, type) NOT IN (
                SELECT value ->> '$[0]', value ->> '$[1]' FROM json_each(?))",
            [&Json(SerdeIterator::new(
                groups
                    .iter()
                    .filter_map(|g| Some((g.id()?, g.group_type()))),
            ))],
        )?;

        let mut stmt = conn.prepare(
            //language=sqlite
            "INSERT OR REPLACE INTO config_user_groups (id, type, invited, joined_at, mute_until, name, notification_mode, priority, is_kicked)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        )?;

        for group in groups {
            match group {
                Group::Group(g) => {
                    stmt.execute(params![
                        g.group_id().context("Invalid group ID")?,
                        GroupType::Group,
                        g.invited,
                        g.joined_at(),
                        g.mute_until(),
                        g.name(),
                        g.notification_mode(),
                        g.priority,
                        g.is_kicked(),
                    ])?;
                }
                Group::Community(g) => {
                    stmt.execute(params![
                        g.id().context("Invalid community ID")?,
                        GroupType::Community,
                        g.invited,
                        Timestamp::from_mills(g.joined_at),
                        Timestamp::from_mills(g.mute_until),
                        Option::<&str>::None,
                        g.notification_mode(),
                        g.priority,
                        Option::<bool>::None,
                    ])?;
                }
                _ => {}
            }
        }

        Ok(())
    }
}

impl SaveAsRows for GroupInfoConfig {
    fn save_as_rows(&self, id: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        conn.execute(
            //language=sqlite
            "INSERT OR REPLACE INTO config_group_info (group_id, name, description, delete_attach_before, delete_before, expiry_timer, created, profile_pic)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            params![
                id.context("Missing group ID")?,
                self.name(),
                self.description(),
                self.delete_attach_before(),
                self.delete_before(),
                self.expiry_timer(),
                self.created(),
                Json(self.profile_pic().to_encrypted_file()),
            ],
        )?;

        Ok(())
    }
}

impl SaveAsRows for GroupMemberConfig {
    fn save_as_rows(&self, id: Option<&str>, conn: &Connection) -> anyhow::Result<()> {
        let id = id.context("Missing group ID")?;
        let members = self.members().collect::<Vec<_>>();

        // Delete all the existing records first
        conn.execute(
            //language=sqlite
            "DELETE FROM config_group_members WHERE group_id = $id AND session_id NOT IN (SELECT value FROM json_each(?))",
            (id, Json(SerdeIterator::new(
                members.iter().map(|m| m.session_id()),
            ))),
        )?;

        // Add the new records
        let mut stmt = conn.prepare(
            //language=sqlite
            "INSERT OR REPLACE INTO config_group_members (group_id, session_id, admin, name, profile_picture, supplement, status)
                VALUES (?, ?, ?, ?, ?, ?, ?)",
        )?;

        for member in self.members() {
            stmt.execute(params![
                id,
                member.session_id(),
                member.admin(),
                member.name(),
                Json(member.profile_pic()),
                member.supplement(),
                self.member_status(&member).map(|s| <&'static str>::from(s)),
            ])?;
        }

        Ok(())
    }
}

impl SaveAsRows for GroupKeys {
    fn save_as_rows(&self, _id: Option<&str>, _conn: &Connection) -> anyhow::Result<()> {
        // Nothing to save for keys
        Ok(())
    }
}
