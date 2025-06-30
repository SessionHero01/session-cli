use crate::blinding::blind15_ids;
use crate::clock::{Timestamp, UnixTimestampFloat};
use crate::config::{Group, GroupConfig, GroupInfoConfig, GroupMemberConfig};
use crate::db::Repository;
use crate::db::app_setting::AppSettingRepositoryExt;
use crate::db::config::ConfigRepositoryExt;
use crate::db::messages::{Message, MessageRepositoryExt};
use crate::identity::Identity;
use crate::key::curve25519;
use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::ED25519PubKey;
use crate::non_empty_vec;
use crate::session_id::{Blind15ID, IndividualID};
use crate::sogs_api::community_id::CommunityId;
use crate::sogs_api::room::RoomInfo;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::json::Json;
use crate::utils::test::{TestState, setup_repository_for_testing};
use crate::worker::CommunityPubKeys;
use itertools::Itertools;
use libsession_protos::protos;
use libsession_protos::protos::session::{AttachmentPointer, DataMessage};
use rand::prelude::SliceRandom;
use rand::{Rng, random, thread_rng};
use std::borrow::Cow;
use std::sync::Arc;

pub fn create_test_environment(
    repo: &Repository,
    contact_count: usize,
    message_per_contact: usize,
    group_count: usize,
    message_per_group: usize,
    community_count: usize,
    message_per_community: usize,
) {
    let mut contacts = Vec::with_capacity(contact_count);
    let mut groups = Vec::with_capacity(group_count);
    let mut communities = Vec::with_capacity(community_count);

    let TestState { clock_source, .. } =
        setup_repository_for_testing(repo, |c, my_identity, clock| {
            // Create contact_count contacts
            for i in 0..contact_count {
                let id = Identity::generate().individual_id().clone();
                let mut contact = c.contacts_config.get_or_construct(&id.into()).unwrap();
                contact.set_name(&format!("Contact {i}")).unwrap();
                contact.approved = true;
                contact.approved_me = i % 30 == 0;
                c.contacts_config.set(&contact);
                contacts.push(contact);
            }

            // Create group_count groups, and part of which are we the admin
            for i in 0..group_count {
                let mut group = c.user_groups_config.create_group().unwrap();
                let id = group.group_id().unwrap();

                let me_as_admin = i % 4 == 0;

                // Set up the group
                let mut group_info =
                    GroupInfoConfig::new(&id, group.sec_key().as_ref(), b"").unwrap();
                group_info.set_name(&format!("Group {i}")).unwrap();
                let mut group_members =
                    GroupMemberConfig::new(&id, group.sec_key().as_ref(), b"").unwrap();

                // Add ourselves into the group
                let mut member = group_members
                    .get_or_construct_member(my_identity.individual_id())
                    .unwrap();
                member.set_name(c.user_profile_config.name()).unwrap();
                member
                    .set_profile_pic(c.user_profile_config.profile_pic())
                    .unwrap();
                member.set_admin(me_as_admin);
                group_members.set_member(&member);

                // Add up to 3 unknown members into the group
                for member_index in 0..(1 + i % 3) {
                    let id = IndividualID::new(Curve25519PubKey::from(random::<[u8; 32]>()));
                    let mut member = group_members.get_or_construct_member(&id).unwrap();
                    member.set_name(&format!("Member {member_index}")).unwrap();
                    if me_as_admin {
                        member.set_admin(member_index % 2 == 0);
                    } else if member_index == 0 {
                        member.set_admin(true);
                    }

                    group_members.set_member(&member);
                }

                // Add up to 5 contacts into the group
                for contact in contacts.iter().take(5) {
                    let mut member = group_members
                        .get_or_construct_member(&contact.session_id().unwrap().try_into().unwrap())
                        .unwrap();
                    member.set_name(contact.name()).unwrap();
                    group_members.set_member(&member);
                }

                if !me_as_admin {
                    group.clear_sec_key();
                    thread_rng().fill(group.auth_data.as_mut_slice());
                }

                c.user_groups_config
                    .set_group(&Group::Group(group.clone()))
                    .unwrap();

                groups.push((group, group_info, group_members));
            }

            // Create community_count communities
            for i in 0..community_count {
                let community_id = CommunityId::new_from_strings(
                    &format!("http://session-community-number{i}.com"),
                    &format!("room{i}"),
                )
                .unwrap();
                let pub_key = curve25519::gen_pair().0;
                let community = c
                    .user_groups_config
                    .get_or_construct_community(&community_id, &pub_key)
                    .unwrap();

                // Generate 1000 members, and plus our own identity
                let blinds = blind15_ids(my_identity.individual_id(), &pub_key).unwrap();
                let member_ids = (0..1000)
                    .map(|_| Blind15ID::new(ED25519PubKey::from(random::<[u8; 32]>())))
                    .chain([blinds.0.clone(), blinds.1.clone()].into_iter())
                    .collect::<Vec<_>>();

                // Set up community info
                let room_info = RoomInfo {
                    name: format!("Community {i}"),
                    description: "".to_string(),
                    created: UnixTimestampFloat(clock.now_or_uncalibrated()),
                    active_users: 1000,
                    image_id: None,
                    moderators: vec![],
                    admins: member_ids
                        .choose_multiple(&mut thread_rng(), 10)
                        .cloned()
                        .map(|id| id.into())
                        .collect(),
                    hidden_moderators: vec![],
                    hidden_admins: vec![],
                    read: true,
                    write: true,
                    upload: true,
                    moderator: false,
                    admin: false,
                    info_updates: 0,
                };

                c.user_groups_config
                    .set_group(&Group::Community(community.clone()))
                    .unwrap();

                let pub_keys = CommunityPubKeys(non_empty_vec!(blinds.0.into(), blinds.1.into()));
                communities.push((community, room_info, pub_keys, member_ids));
            }
        });

    repo.with_transaction(|conn| {
        // Save group configs
        for (group, group_info, group_members) in &mut groups {
            conn.save_config_dump_and_rows(
                group_info,
                Some(group.group_id().unwrap().as_str()),
                clock_source.now_or_uncalibrated(),
            )
            .unwrap();

            conn.save_config_dump_and_rows(
                group_members,
                Some(group.group_id().unwrap().as_str()),
                clock_source.now_or_uncalibrated(),
            )
            .unwrap();
        }

        // Save community configs
        for (info, room, keys, _) in &mut communities {
            let id = info.id().unwrap();
            conn.save_setting(&id, room).unwrap();
            conn.save_setting(&id, keys).unwrap();
        }

        Ok(())
    })
    .unwrap();

    println!("Saved group configs");

    let one_year_ago = clock_source.now_or_uncalibrated().as_millis() - 365 * 24 * 60 * 60 * 1000;

    let contact_messages = contacts
        .iter()
        .flat_map(|c| {
            (0..message_per_contact as u64)
                .into_iter()
                .map(move |i| (c, i))
        })
        .map(|(c, i)| {
            let contact_id = c.session_id().unwrap().to_string();
            let (sender, receiver) = if i % 2 == 0 {
                (Cow::Owned(contact_id), Cow::Borrowed(""))
            } else {
                (Cow::Borrowed(""), Cow::Owned(contact_id))
            };

            Message {
                repository: Cow::Borrowed(""),
                server_id: Some(Cow::Owned(uuid::Uuid::new_v4().to_string())),
                content: Json(create_message_content(i)),
                sender,
                receiver,
                created_at: Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap(),
                sent_at: Some(Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap()),
                expiration_at: None,
            }
        });

    let group_messages = groups
        .iter()
        .flat_map(|(group, _, members)| {
            let members = Arc::new(
                members
                    .members()
                    .map(|m| m.session_id().clone())
                    .collect::<Vec<_>>(),
            );
            (0..message_per_group as u64)
                .into_iter()
                .map(move |i| (group.group_id().unwrap(), members.clone(), i))
        })
        .map(|(id, members, i)| {
            let sender = &members[(i % (members.len() as u64)) as usize];
            Message {
                repository: Cow::Owned(id.to_string()),
                server_id: Some(Cow::Owned(uuid::Uuid::new_v4().to_string())),
                content: Json(create_message_content(i)),
                sender: Cow::Owned(sender.to_string()),
                receiver: Cow::Borrowed(""),
                created_at: Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap(),
                sent_at: Some(Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap()),
                expiration_at: None,
            }
        });

    let community_messages = communities
        .iter()
        .flat_map(|(info, room, keys, members)| {
            (0u64..message_per_community as u64)
                .into_iter()
                .map(move |i| (info.id().unwrap(), members, i))
        })
        .map(|(id, members, i)| {
            let sender = &members[(i % members.len() as u64) as usize];
            Message {
                repository: Cow::Owned(id.to_string()),
                server_id: Some(Cow::Owned(uuid::Uuid::new_v4().to_string())),
                content: Json(create_message_content(i)),
                sender: Cow::Owned(sender.to_string()),
                receiver: Cow::Borrowed(""),
                created_at: Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap(),
                sent_at: Some(Timestamp::from_mills(one_year_ago + i * 60 * 1000).unwrap()),
                expiration_at: None,
            }
        });

    for message_chunk in &contact_messages
        .chain(group_messages)
        .chain(community_messages)
        .chunks(100000)
    {
        repo.with_transaction(|conn| {
            conn.save_messages(message_chunk).unwrap();

            Ok(())
        })
        .unwrap();

        println!("Saved 100000 messages");
    }
}

fn create_message_content(index: u64) -> protos::session::Content {
    let mut content = protos::session::Content::default();

    if index % 10 == 0 {
        // Image every 10 messages
        content.data_message = Some(DataMessage {
            attachments: vec![AttachmentPointer {
                id: 0,
                content_type: Some("image/jpeg".to_string()),
                url: Some("https://example.com/image.jpg".to_string()),
                ..Default::default()
            }],
            ..Default::default()
        });
    } else {
        content.data_message = Some(DataMessage {
            body: Some(format!("Message {index}")),
            ..Default::default()
        });
    }

    // Text message
    content
}
