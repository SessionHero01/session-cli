use super::super::Repository;
use crate::db::conversations::conversation_list_query;
use crate::db::messages::{AttachmentId, Message as DbMessage, MessageRepositoryExt};
use crate::identity::Identity;
use crate::network::swarm_auth::SwarmAuth;
use crate::utils::json::Json;
use crate::utils::test::{TestState, setup_repository_for_testing};
use libsession_protos::protos::message::Body;
use libsession_protos::protos::message_content::full::Attachments;
use libsession_protos::protos::{
    AttachmentContent, FileAttachment, FileAttachments, Message, MessageContent, RegularMessage,
    UserName, attachment_content, message_content,
    session::{AttachmentPointer, Content, DataMessage},
    user_name,
};
use r2d2_sqlite::SqliteConnectionManager;
use rand::{Rng, thread_rng};
use std::borrow::Cow;
use std::io::Read;

#[test]
fn test_message_with_attachments() {
    let repo = Repository::new(SqliteConnectionManager::memory()).unwrap();
    let other = Identity::generate();

    let TestState {
        identity: me,
        clock_source,
        test_contact,
        ..
    } = setup_repository_for_testing(&repo, |_, _, _| {});

    let existing_attachment = AttachmentPointer {
        id: 1,
        content_type: Some("application/octet-stream".to_string()),
        file_name: Some("existing".to_string()),
        url: Some("http://url".to_string()),
        ..Default::default()
    };

    let data_message = DataMessage {
        body: Some("test".to_string()),
        attachments: vec![existing_attachment.clone()],
        ..Default::default()
    };

    let mut pending_attachment_data = vec![0u8; 1024];
    thread_rng().fill(&mut pending_attachment_data[..]);

    repo.with_transaction(|conn| {
        conn.save_messages(
            [(DbMessage {
                repository: Cow::Borrowed(me.individual_id().as_str()),
                server_id: None,
                content: Json(Content {
                    data_message: Some(data_message.clone()),
                    ..Default::default()
                }),
                sender: Cow::Borrowed(""),
                receiver: Cow::Borrowed(other.individual_id().as_str()),
                created_at: clock_source.now_or_uncalibrated(),
                sent_at: Some(clock_source.now_or_uncalibrated()),
                expiration_at: None,
            })]
            .into_iter(),
        )
    })
    .unwrap();

    let convo = repo
        .query(&conversation_list_query(None))
        .unwrap()
        .into_iter()
        .filter(|c| c.id == test_contact.session_id().unwrap().as_str())
        .next()
        .unwrap();

    assert_eq!(convo.name, "Other");

    let last_message = convo.last_message.expect("No last message");
    let Message {
        body:
            Some(Body::Regular(RegularMessage {
                author_id,
                author_name,
                content:
                    MessageContent {
                        content:
                            Some(message_content::Content::Full(message_content::Full {
                                text,
                                attachments: Some(Attachments::Files(FileAttachments { files })),
                            })),
                        ..
                    },
                ..
            })),
        ..
    } = last_message
    else {
        panic!("Last message is not an expected message");
    };

    assert_eq!(files.len(), 2);
    assert_eq!(files[0].file_name.as_ref().unwrap(), "existing");

    if let Some(FileAttachment {
        content:
            AttachmentContent {
                content: Some(attachment_content::Content::PendingAttachmentId(pending_id)),
            },
        file_name,
        size,
        ..
    }) = files.get(1)
    {
        assert_eq!(file_name.as_ref().unwrap(), "pending");
        assert_eq!(*size, Some(pending_attachment_data.len() as u32));

        let bytes_from_db = repo
            .with_connection(|conn| {
                let (length, mut data) = conn
                    .get_pending_attachment(*pending_id as AttachmentId)
                    .unwrap()
                    .unwrap();
                assert_eq!(length, pending_attachment_data.len());
                let mut bytes_from_db = vec![];
                data.read_to_end(&mut bytes_from_db).unwrap();
                Ok(bytes_from_db)
            })
            .unwrap();

        assert_eq!(pending_attachment_data, bytes_from_db.as_slice());
    } else {
        panic!("Second attachment is not an expected attachment");
    };

    assert_eq!(text, "test");
    assert_eq!(author_id, other.session_id().as_str());
    assert!(matches!(
        author_name,
        UserName {
            name: Some(user_name::Name::Other(v))
        } if v == "Other"
    ));
}
