use crate::config::{ConfigWrapper, Group, UserGroupsConfig};
use anyhow::bail;
use futures_util::future::{Either, select};
use futures_util::{stream, stream::StreamExt};
use itertools::Itertools;
use std::collections::{HashMap, HashSet};
use std::fmt::Debug;
use std::hash::Hash;
use std::pin::pin;
use tokio::sync::mpsc;
use tokio::task::JoinSet;
use tokio_stream::wrappers::BroadcastStream;

struct Handle<CommandType> {
    command_tx: mpsc::Sender<CommandType>,
    _tasks: JoinSet<anyhow::Result<()>>,
}

pub async fn sync_generic_groups<GroupIDType, GroupType, GroupCommandType, F>(
    config: ConfigWrapper<UserGroupsConfig>,
    filter_map_groups: fn(Group) -> Option<(GroupIDType, GroupType)>,
    mut sync_group: impl FnMut(GroupIDType, GroupType, mpsc::Receiver<GroupCommandType>) -> F,
    mut group_command_rx: mpsc::Receiver<(GroupIDType, GroupCommandType)>,
) -> anyhow::Result<()>
where
    GroupIDType: Eq + Hash + Send + Debug + Clone + 'static,
    GroupType: Clone + Send,
    GroupCommandType: Send + 'static,
    F: Future<Output = anyhow::Result<()>> + Send + 'static,
{
    let mut handles: HashMap<GroupIDType, Handle<GroupCommandType>> = HashMap::new();

    let mut active_groups = stream::iter([()])
        .chain(BroadcastStream::new(config.subscribe()).map(|_| ()))
        .map(|_| {
            config
                .borrow()
                .get_groups()
                .filter_map(filter_map_groups)
                .collect::<HashMap<_, _>>()
        })
        .scan(
            None,
            |last_groups: &mut Option<HashMap<GroupIDType, GroupType>>, curr_groups| {
                let r = match last_groups {
                    Some(last)
                        if last.keys().collect::<HashSet<_>>()
                            == curr_groups.keys().collect::<HashSet<_>>() =>
                    {
                        None
                    }

                    _ => {
                        last_groups.replace(curr_groups.clone());
                        Some(curr_groups)
                    }
                };

                std::future::ready(Some(r))
            },
        )
        .filter_map(|s| std::future::ready(s));

    loop {
        let group_command_rx = pin!(group_command_rx.recv());
        match select(active_groups.next(), group_command_rx).await {
            Either::Left((Some(groups), _)) => {
                // Remove groups that are no longer active
                handles.retain(|group_id, _| groups.contains_key(group_id));

                let new_group_ids = groups
                    .iter()
                    .filter(|(gid, _)| !handles.contains_key(*gid))
                    .map(|(gid, g)| (gid.clone(), g.clone()))
                    .collect_vec();

                for (group_id, group) in new_group_ids {
                    let (command_tx, command_rx) = mpsc::channel(1);

                    let mut tasks = JoinSet::new();
                    tasks.spawn(sync_group(group_id.clone(), group, command_rx));
                    handles.insert(
                        group_id,
                        Handle {
                            command_tx,
                            _tasks: tasks,
                        },
                    );
                }
            }
            Either::Right((Some((group_id, group_cmd)), _)) => match handles.get(&group_id) {
                None => tracing::warn!("Sending command to non-existent {group_id:?}"),
                Some(handle) => {
                    let _ = handle.command_tx.send(group_cmd).await;
                }
            },

            Either::Right((None, _)) => bail!("Command stream ended unexpectedly"),
            Either::Left((None, _)) => bail!("Config stream ended unexpectedly"),
        }
    }
}
