use crate::db::Repository;
use crate::db::app_setting::AppSettingRepositoryExt;
use crate::http_api::executor::HttpRPCExecutor;
use crate::sogs_api::community_id::CommunityId;
use crate::sogs_api::get_room::GetRoom;
use crate::sogs_api::poll_info::PollRoomInfo;
use crate::sogs_api::room::RoomInfo;
use anyhow::Context;

pub async fn sync_community_info<E>(
    executor: E,
    args: E::Args,
    community_id: &CommunityId,
    repo: &Repository,
    strategy: impl super::super::strategy::PollStrategy,
) -> anyhow::Result<()>
where
    E: HttpRPCExecutor + Sync,
    E::Args: Send + Clone,
{
    let mut last_room_update = repo
        .with_connection(|conn| conn.load_setting::<RoomInfo>(community_id))
        .context("Loading room info")?
        .map(|r| r.info_updates);

    loop {
        let r = async {
            let room_info = match last_room_update {
                Some(last_room_update) => {
                    executor
                        .execute_rpc(
                            args.clone(),
                            (
                                community_id.server_url().clone(),
                                PollRoomInfo {
                                    room_id: community_id.room().to_string(),
                                    last_info_updates: last_room_update,
                                },
                            ),
                        )
                        .await
                        .context("Fetching from API")?
                        .details
                }

                None => Some(
                    executor
                        .execute_rpc(
                            args.clone(),
                            (
                                community_id.server_url().clone(),
                                GetRoom(community_id.room().to_string()),
                            ),
                        )
                        .await
                        .context("Fetching from API")?,
                ),
            };

            if let Some(info) = room_info {
                last_room_update.replace(info.info_updates);
                repo.with_connection(|conn| conn.save_setting(community_id, &info))
                    .context("Saving room info")?;
            }

            anyhow::Ok(())
        };

        match r.await {
            Ok(_) => {
                tracing::info!("Synced community info successfully");
            }
            Err(e) => {
                tracing::error!("Error syncing community info: {e:?}");
                strategy.report_error(&e);
            }
        };

        if strategy.next_poll().await.is_none() {
            return Ok(());
        }
    }
}
