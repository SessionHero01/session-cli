use crate::batcher::BatchRPCExecutor;
use crate::clock::ClockSource;
use crate::config::{
    ConfigWrapper, ContactsConfig, ConvoInfoVolatileConfig, IndividualConfig, NamedConfig,
    PushRequestCallback, UserGroupsConfig, UserProfileConfig,
};
use crate::db::Repository;
use crate::db::config::ConfigRepositoryExt;
use crate::http_api::executor::HttpRPCExecutor;
use crate::identity::Identity;
use crate::key::curve25519::Curve25519PubKey;
use crate::network::NodeAddress;
use crate::network::swarm::SwarmManager;
use crate::oxenss::batch::BatchRequest;
use crate::oxenss::message::DefaultMessageCodec;
use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::retrieve::Message;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::GroupID;
use crate::sogs_api::community_id::CommunityId;
use crate::worker::CommunityCommand;
use crate::worker::group::GroupCommand;
use crate::worker::strategy::PollStrategy;
use anyhow::Context;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::mpsc;
use tokio::try_join;
use tracing::instrument;

pub struct SyncAccount {
    pub contacts_config: ConfigWrapper<ContactsConfig>,
    pub user_groups_config: ConfigWrapper<UserGroupsConfig>,
    pub convo_info_config: ConfigWrapper<ConvoInfoVolatileConfig>,
    pub user_profile_config: ConfigWrapper<UserProfileConfig>,

    pub side_channel_message_tx: mpsc::Sender<(Option<GroupID>, MessageNamespace, Vec<Message>)>,
    side_channel_message_rx: mpsc::Receiver<(Option<GroupID>, MessageNamespace, Vec<Message>)>,

    pub community_commands_tx: mpsc::Sender<(CommunityId, CommunityCommand)>,
    community_commands_rx: mpsc::Receiver<(CommunityId, CommunityCommand)>,

    contacts_push: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,
    groups_push: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,
    convo_info_push: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,
    user_profile_push: mpsc::UnboundedReceiver<Option<PushRequestCallback>>,

    repo: Arc<Repository>,
    identity: Identity,
}

impl SyncAccount {
    pub fn new(repo: Arc<Repository>, identity: Identity) -> anyhow::Result<Self> {
        let (user_profile_dump, contacts_dump, convo_info_dump, groups_dump) = repo
            .with_connection(|c| {
                Ok((
                    c.get_config_dump(UserProfileConfig::CONFIG_TYPE_NAME, None)?,
                    c.get_config_dump(ContactsConfig::CONFIG_TYPE_NAME, None)?,
                    c.get_config_dump(ConvoInfoVolatileConfig::CONFIG_TYPE_NAME, None)?,
                    c.get_config_dump(UserGroupsConfig::CONFIG_TYPE_NAME, None)?,
                ))
            })?;

        let (contacts_config, contacts_push) = ConfigWrapper::new(
            ContactsConfig::new(
                identity.ed25519_sec_key(),
                contacts_dump.as_ref().map(Vec::as_ref),
            )
            .context("Error creating contacts config")?,
        );

        let (groups_config, groups_push) = ConfigWrapper::new(
            UserGroupsConfig::new(
                identity.ed25519_sec_key(),
                groups_dump.as_ref().map(Vec::as_ref),
            )
            .context("Error creating groups config")?,
        );

        let (convo_info_config, convo_info_push) = ConfigWrapper::new(
            ConvoInfoVolatileConfig::new(
                identity.ed25519_sec_key(),
                convo_info_dump.as_ref().map(Vec::as_ref),
            )
            .context("Error creating convo info config")?,
        );

        let (user_profile_config, user_profile_push) = ConfigWrapper::new(
            UserProfileConfig::new(
                identity.ed25519_sec_key(),
                user_profile_dump.as_ref().map(Vec::as_ref),
            )
            .context("Error creating user profile config")?,
        );

        let (side_channel_message_tx, side_channel_message_rx) = mpsc::channel(100);
        let (community_commands_tx, community_commands_rx) = mpsc::channel(100);

        Ok(Self {
            contacts_config,
            user_groups_config: groups_config,
            convo_info_config,
            user_profile_config,
            contacts_push,
            groups_push,
            convo_info_push,
            user_profile_push,
            repo,
            identity,
            side_channel_message_tx,
            side_channel_message_rx,
            community_commands_tx,
            community_commands_rx,
        })
    }

    #[instrument(skip_all, fields(account_id=?self.identity), ret, name="sync_account")]
    pub async fn run(
        self,
        executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Clone + Send + Sync + 'static,
        http_executor: impl HttpRPCExecutor<Args = Curve25519PubKey> + Send + Clone + Sync + 'static,
        clock_source: ClockSource,
        message_strategy: impl PollStrategy + Send + Sync + Clone + 'static,
        config_strategy: impl PollStrategy + Send + Sync + Clone + 'static,
    ) -> anyhow::Result<()> {
        let Self {
            contacts_config,
            user_groups_config,
            convo_info_config,
            user_profile_config,
            mut side_channel_message_rx,
            contacts_push,
            groups_push: user_groups_push,
            convo_info_push,
            user_profile_push,
            repo,
            identity,
            community_commands_rx,
            ..
        } = self;

        let (executor, executor_runner) = BatchRPCExecutor::new(
            |requests| std::future::ready(BatchRequest::try_from(requests)),
            executor,
            Duration::from_millis(100),
        );

        let swarm_manager =
            SwarmManager::new(identity.individual_id().clone().into(), &executor, None);

        let (user_profile_message_tx, user_profile_side_channel_message_rx) = mpsc::channel(16);
        let sync_user_profile_config = super::sync_config(
            &executor,
            &swarm_manager,
            None,
            user_profile_config,
            user_profile_push,
            &repo,
            &identity,
            &clock_source,
            &config_strategy,
            None,
            Some(user_profile_side_channel_message_rx),
        );

        let (contacts_message_tx, contacts_side_channel_message_rx) = mpsc::channel(16);
        let sync_contacts_config = super::sync_config(
            &executor,
            &swarm_manager,
            None,
            contacts_config,
            contacts_push,
            &repo,
            &identity,
            &clock_source,
            &config_strategy,
            None,
            Some(contacts_side_channel_message_rx),
        );

        let (user_groups_message_tx, user_groups_side_channel_message_rx) = mpsc::channel(16);
        let sync_user_groups_config = super::sync_config(
            &executor,
            &swarm_manager,
            None,
            user_groups_config.clone(),
            user_groups_push,
            &repo,
            &identity,
            &clock_source,
            &config_strategy,
            None,
            Some(user_groups_side_channel_message_rx),
        );

        let (convo_info_message_tx, convo_info_side_channel_message_rx) = mpsc::channel(16);
        let sync_convo_info_config = super::sync_config(
            &executor,
            &swarm_manager,
            None,
            convo_info_config,
            convo_info_push,
            &repo,
            &identity,
            &clock_source,
            &config_strategy,
            None,
            Some(convo_info_side_channel_message_rx),
        );

        let (group_command_tx, group_command_rx) = mpsc::channel(16);
        let (regular_message_tx, regular_message_rx) = mpsc::channel(16);

        let dispatch_side_channel_messages = async {
            while let Some((group_id, ns, messages)) = side_channel_message_rx.recv().await {
                let tx = match (group_id, ns) {
                    (Some(group_id), namespace) => {
                        let _ = group_command_tx
                            .send((
                                group_id,
                                GroupCommand::SideChannelMessageReceived(namespace, messages),
                            ))
                            .await;
                        continue;
                    }
                    (_, MessageNamespace::ContactsConfig) => &contacts_message_tx,
                    (_, MessageNamespace::UserGroupsConfig) => &user_groups_message_tx,
                    (_, MessageNamespace::UserProfileConfig) => &user_profile_message_tx,
                    (_, MessageNamespace::ConvoInfoVolatileConfig) => &convo_info_message_tx,
                    (_, MessageNamespace::UserMessages) => &regular_message_tx,
                    (_, unknown) => {
                        tracing::warn!("Unknown namespace: {unknown}");
                        continue;
                    }
                };

                let _ = tx.send(messages).await;
            }

            anyhow::Ok(())
        };

        let sync_groups = super::sync_groups(
            executor.clone(),
            identity.clone(),
            repo.clone(),
            user_groups_config.clone(),
            clock_source.clone(),
            group_command_rx,
            config_strategy.clone(),
            message_strategy.clone(),
        );

        let sync_regular_messages = super::sync_regular_messages::<DefaultMessageCodec, _, _>(
            MessageNamespace::UserMessages,
            &repo,
            &executor,
            &identity,
            &swarm_manager,
            &message_strategy,
            &clock_source,
            Some(regular_message_rx),
        );

        let sync_communities = super::sync_communities(
            http_executor,
            repo.clone(),
            identity.clone(),
            user_groups_config,
            clock_source.clone(),
            community_commands_rx,
            config_strategy.clone(),
            message_strategy.clone(),
        );

        try_join!(
            sync_user_profile_config,
            sync_contacts_config,
            sync_user_groups_config,
            sync_convo_info_config,
            dispatch_side_channel_messages,
            sync_groups,
            sync_regular_messages,
            sync_communities,
            executor_runner.run(),
        )?;

        Ok(())
    }
}
