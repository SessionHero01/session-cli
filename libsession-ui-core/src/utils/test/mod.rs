use crate::clock::ClockSource;
use crate::config::contacts::Contact;
use crate::config::{
    ConfigWrapper, ContactsConfig, ConvoInfoVolatileConfig, Group, GroupConfig, GroupInfoConfig,
    GroupKeys, GroupMemberConfig, IndividualConfig, UserGroupsConfig, UserProfileConfig,
};
use crate::db::Repository;
use crate::db::app_setting::AppSettingRepositoryExt;
use crate::db::config::ConfigRepositoryExt;
use crate::identity::Identity;
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519SecKey;
use crate::session_id::GroupID;
use crate::sogs_api::community_id::CommunityId;

pub struct TestState {
    pub identity: Identity,
    pub clock_source: ClockSource,
    pub test_contact: Contact,
    pub test_group_id: GroupID,
    pub test_community_id: CommunityId,
}

pub struct Configs {
    pub user_profile_config: UserProfileConfig,
    pub user_groups_config: UserGroupsConfig,
    pub convo_info_volatile_config: ConvoInfoVolatileConfig,
    pub contacts_config: ContactsConfig,
}

impl Configs {
    pub fn new(sec_key: &ED25519SecKey) -> anyhow::Result<Self> {
        Ok(Self {
            user_profile_config: UserProfileConfig::new(sec_key, None)?,
            user_groups_config: UserGroupsConfig::new(sec_key, None)?,
            convo_info_volatile_config: ConvoInfoVolatileConfig::new(sec_key, None)?,
            contacts_config: ContactsConfig::new(sec_key, None)?,
        })
    }
}

pub fn setup_repository_for_testing(
    repo: &Repository,
    setup_configs: impl FnOnce(&mut Configs, &Identity, &ClockSource),
) -> TestState {
    let identity = Identity::generate();
    let clock_source = ClockSource::default();

    // Save identity to database
    repo.with_connection(|conn| conn.save_setting(&(), &identity))
        .unwrap();

    // Initial configs
    let mut configs =
        Configs::new(identity.ed25519_sec_key()).expect("Failed to create config state");

    // User profile
    configs.user_profile_config.set_name("I am user").unwrap();

    // Add a test contact
    let test_contact = Identity::generate().individual_id().clone();
    let mut contact = configs
        .contacts_config
        .get_or_construct(&test_contact.clone().into())
        .unwrap();
    contact.set_name("Other").unwrap();
    contact.approved = true;
    contact.approved_me = true;
    configs.contacts_config.set(&contact);

    // Add a test group
    let mut group = configs.user_groups_config.create_group().unwrap();
    let group_id = group.group_id().unwrap();
    group.set_name("Test Group").unwrap();
    configs
        .user_groups_config
        .set_group(&Group::Group(group.clone()))
        .unwrap();

    // Group config
    let mut info = GroupInfoConfig::new(&group_id, group.sec_key().as_ref(), b"").unwrap();
    info.set_name("Test Group").unwrap();

    let (info, _) = ConfigWrapper::new(info);

    let mut members = GroupMemberConfig::new(&group_id, group.sec_key().as_ref(), b"").unwrap();
    let mut myself = members
        .get_or_construct_member(identity.individual_id())
        .unwrap();
    myself.set_name("Me").unwrap();
    members.set_member(&myself);

    let mut other = members.get_or_construct_member(&test_contact).unwrap();
    other.set_name("Other").unwrap();
    members.set_member(&other);

    let (members, _) = ConfigWrapper::new(members);

    let mut keys = GroupKeys::new(
        identity.ed25519_sec_key(),
        group_id.pub_key(),
        group.sec_key().as_ref(),
        info.clone(),
        members.clone(),
        b"",
    )
    .unwrap();

    // Community
    let community = configs
        .user_groups_config
        .get_or_construct_community(
            &"https://open.getsession.org/session".parse().unwrap(),
            &Curve25519PubKey::from_hex(
                "a03c383cf63c3c4efe67acc52112a6dd734b3a946b9545f488aaa93da7991238",
            )
            .unwrap(),
        )
        .unwrap();

    setup_configs(&mut configs, &identity, &clock_source);

    // Save configs into db
    let timestamp = clock_source.now_or_uncalibrated();
    repo.with_transaction(|conn| {
        conn.save_config_dump_and_rows(&mut configs.contacts_config, None, timestamp)
            .unwrap();
        conn.save_config_dump_and_rows(&mut configs.user_profile_config, None, timestamp)
            .unwrap();
        conn.save_config_dump_and_rows(&mut configs.user_groups_config, None, timestamp)
            .unwrap();
        conn.save_config_dump_and_rows(&mut configs.convo_info_volatile_config, None, timestamp)
            .unwrap();
        info.mutate(|info| {
            conn.save_config_dump_and_rows(info, Some(group_id.as_str()), timestamp)
        })
        .unwrap();
        members
            .mutate(|members| {
                conn.save_config_dump_and_rows(members, Some(group_id.as_str()), timestamp)
            })
            .unwrap();
        conn.save_config_dump(&mut keys, Some(group_id.as_str()), timestamp)
            .unwrap();
        Ok(())
    })
    .unwrap();

    TestState {
        identity,
        clock_source,
        test_contact: contact,
        test_group_id: group_id,
        test_community_id: community.id().unwrap(),
    }
}
