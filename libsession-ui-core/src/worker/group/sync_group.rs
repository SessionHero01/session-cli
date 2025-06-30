use super::super::{sync_config, sync_regular_messages};
use super::auth::GroupSwarmAuth;
use crate::clock::ClockSource;
use crate::config::{
    ConfigWrapper, GroupConfig, GroupInfoConfig, GroupKeys, GroupMemberConfig, NamedConfig,
    UserGroupsConfig,
};
use crate::db::Repository;
use crate::db::config::ConfigRepositoryExt;
use crate::identity::Identity;
use crate::network::NodeAddress;
use crate::network::swarm::SwarmManager;
use crate::oxenss::message::GroupMessageCodec;
use crate::oxenss::namespace::MessageNamespace;
use crate::oxenss::retrieve::Message;
use crate::oxenss::rpc::StorageRPCExecutor;
use crate::session_id::GroupID;
use anyhow::{Context, bail};
use futures_util::future::{Either, select, try_join5};
use futures_util::{FutureExt, pin_mut};
use std::future::pending;
use tokio::sync::mpsc;
use tracing::instrument;

pub enum GroupCommand {
    SideChannelMessageReceived(MessageNamespace, Vec<Message>),
}

pub async fn sync_group(
    executor: impl StorageRPCExecutor<Args = Option<NodeAddress>> + Sync,
    identity: &Identity,
    group_id: &GroupID,
    user_groups: ConfigWrapper<UserGroupsConfig>,
    repo: &Repository,
    clock: &ClockSource,
    commands: mpsc::Receiver<GroupCommand>,
    message_strategy: impl super::super::strategy::PollStrategy + Sync,
    config_strategy: impl super::super::strategy::PollStrategy + Sync,
) -> anyhow::Result<()> {
    let swarm_manager = SwarmManager::new(group_id.clone().into(), &executor, None);

    let (info, members, keys) = repo
        .with_connection(|conn| {
            Ok((
                conn.get_config_dump(GroupInfoConfig::CONFIG_TYPE_NAME, Some(group_id.as_str()))?
                    .unwrap_or_default(),
                conn.get_config_dump(GroupMemberConfig::CONFIG_TYPE_NAME, Some(group_id.as_str()))?
                    .unwrap_or_default(),
                conn.get_config_dump(GroupKeys::CONFIG_TYPE_NAME, Some(group_id.as_str()))?
                    .unwrap_or_default(),
            ))
        })
        .context("Error restoring group configs")?;

    let admin_key = user_groups
        .borrow()
        .get_group(&group_id)
        .and_then(|g| g.sec_key());

    let (info, info_push) = ConfigWrapper::new(
        GroupInfoConfig::new(&group_id, admin_key.as_ref(), info.as_slice())
            .context("Error creating group info config")?,
    );

    let (members, members_push) = ConfigWrapper::new(
        GroupMemberConfig::new(&group_id, admin_key.as_ref(), members.as_slice())
            .context("Error creating group members config")?,
    );

    let (keys, keys_push) = ConfigWrapper::new(
        GroupKeys::new(
            identity.ed25519_sec_key(),
            group_id.pub_key(),
            admin_key.as_ref(),
            info.clone(),
            members.clone(),
            keys.as_slice(),
        )
        .context("Error creating group keys config")?,
    );

    let auth = GroupSwarmAuth {
        id: group_id.clone(),
        group_keys: keys.clone(),
        user_groups_config: user_groups.clone(),
    };

    let (sync_key_poll_results_tx, mut sync_key_poll_results) = mpsc::channel(1);
    let (key_side_channel_tx, key_side_channel_rx) = mpsc::channel(1);
    let sync_key = sync_config(
        &executor,
        &swarm_manager,
        Some(group_id.as_str()),
        keys.clone(),
        keys_push,
        &repo,
        &auth,
        &clock,
        &config_strategy,
        Some(sync_key_poll_results_tx),
        Some(key_side_channel_rx),
    )
    .fuse();

    let wait_for_group_keys = wait_for_group_keys(&keys, &mut sync_key_poll_results);

    pin_mut!(sync_key, wait_for_group_keys);

    // Wait for the group keys to come through
    match select(wait_for_group_keys, &mut sync_key).await {
        Either::Left((Ok(0), _)) => bail!("Group expired"),
        Either::Left((Ok(_), _)) => {}

        Either::Left((Err(err), _)) | Either::Right((Err(err), _)) => {
            tracing::error!(?err, "Error while waiting for group keys");
            return Err(err);
        }

        Either::Right((Ok(_), _)) => bail!("Initial key sync completed unexpectedly"),
    }

    tracing::info!("Received group keys! Able to proceed to group syncing");

    let (info_side_channel_tx, info_side_channel_rx) = mpsc::channel(1);
    let sync_info = sync_config(
        &executor,
        &swarm_manager,
        Some(group_id.as_str()),
        info.clone(),
        info_push,
        &repo,
        &auth,
        &clock,
        &config_strategy,
        None,
        Some(info_side_channel_rx),
    );

    let (members_side_channel_tx, members_side_channel_rx) = mpsc::channel(1);
    let sync_members = sync_config(
        &executor,
        &swarm_manager,
        Some(group_id.as_str()),
        members.clone(),
        members_push,
        &repo,
        &auth,
        &clock,
        &config_strategy,
        None,
        Some(members_side_channel_rx),
    );

    let (kicked_side_channel_tx, kicked_side_channel_rx) = mpsc::channel(1);

    let wait_for_kicked = wait_for_kicked();

    let (messages_side_channel_tx, messages_side_channel_rx) = mpsc::channel(1);
    let sync_messages = sync_regular_messages::<GroupMessageCodec, _, _>(
        MessageNamespace::GroupMessages,
        &repo,
        &executor,
        &auth,
        &swarm_manager,
        message_strategy,
        &clock,
        Some(messages_side_channel_rx),
    );

    let handle_command = handle_command(
        commands,
        key_side_channel_tx,
        info_side_channel_tx,
        members_side_channel_tx,
        kicked_side_channel_tx,
        messages_side_channel_tx,
    );

    pin_mut!(
        sync_info,
        sync_members,
        wait_for_kicked,
        handle_command,
        sync_messages
    );

    match select(
        wait_for_kicked,
        try_join5(
            handle_command,
            sync_key,
            sync_info,
            sync_members,
            sync_messages,
        ),
    )
    .await
    {
        Either::Left((Ok(()), _)) => bail!("Kicked from group"),
        Either::Left((Err(err), _)) => Err(err),
        Either::Right((r, _)) => r.map(|_| ()),
    }
}

async fn wait_for_kicked() -> anyhow::Result<()> {
    pending().await
}

#[tracing::instrument(skip_all, ret)]
async fn handle_command(
    mut cmd: mpsc::Receiver<GroupCommand>,
    key_side_channel_tx: mpsc::Sender<Vec<Message>>,
    info_side_channel_tx: mpsc::Sender<Vec<Message>>,
    members_side_channel_tx: mpsc::Sender<Vec<Message>>,
    kicked_side_channel_tx: mpsc::Sender<Vec<Message>>,
    messages_side_channel_tx: mpsc::Sender<Vec<Message>>,
) -> anyhow::Result<()> {
    // Handle commands here
    while let Some(cmd) = cmd.recv().await {
        match cmd {
            GroupCommand::SideChannelMessageReceived(namespace, messages) => {
                tracing::debug!(
                    "Received {} messages for namespace {namespace}",
                    messages.len()
                );

                let tx = match namespace {
                    MessageNamespace::GroupMessages => &messages_side_channel_tx,
                    MessageNamespace::GroupInfoConfig => &info_side_channel_tx,
                    MessageNamespace::GroupMemberConfig => &members_side_channel_tx,
                    MessageNamespace::GroupKeysConfig => &key_side_channel_tx,
                    MessageNamespace::GroupKickedMessages => &kicked_side_channel_tx,
                    n => {
                        tracing::error!("Received unknown namespace messages: {n}");
                        continue;
                    }
                };

                if let Err(e) = tx.send(messages).await {
                    tracing::error!(?e, "Error sending side channel message");
                }
            }
        }
    }

    Ok(())
}

#[instrument(skip_all, ret)]
async fn wait_for_group_keys(
    keys: &ConfigWrapper<GroupKeys>,
    poll_results: &mut mpsc::Receiver<anyhow::Result<()>>,
) -> anyhow::Result<usize> {
    // Wait for first successful key poll
    while let Err(e) = poll_results
        .recv()
        .await
        .context("Error waiting for key poll results")?
    {
        tracing::debug!(?e, "Error polling key, keep waiting until it succeeds");
        continue;
    }

    tracing::debug!("Got first successful key poll");
    Ok(keys.borrow().len())
}
