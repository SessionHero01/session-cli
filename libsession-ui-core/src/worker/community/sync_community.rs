use crate::app_setting::{AppSetting, impl_sql_for_serde};
use crate::blinding::{blind15_ids, blind15_key_pair};
use crate::db::Repository;
use crate::db::app_setting::AppSettingRepositoryExt;
use crate::http_api::executor::HttpRPCExecutor;
use crate::identity::Identity;
use crate::non_empty_vec;
use crate::session_id::IndividualOrBlindedID;
use crate::sogs_api::authenticated_executor::CommunityIdentityType;
use crate::sogs_api::capabilities::{Capability, GetCapabilitiesRequest, ServerCapabilities};
use crate::sogs_api::community_id::{CommunityId, CommunityPublicKey};
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::sync::join_set::LocalJoinSet;
use crate::worker::CommunityCommand;
use anyhow::Context;
use futures_util::future::{Either, FutureExt, select};
use futures_util::try_join;
use serde::{Deserialize, Serialize};
use std::pin::pin;
use tokio::sync::mpsc;
use tracing::Instrument;

#[derive(Serialize, Deserialize, Debug)]
pub struct CommunityPubKeys(pub NonEmpty<IndividualOrBlindedID>);

impl AppSetting for CommunityPubKeys {
    const NAME: &'static str = "community_pub_keys";
    type IDType<'a> = CommunityId;
}

impl_sql_for_serde!(CommunityPubKeys);

pub async fn sync_community<E>(
    executor: E,
    server_key: CommunityPublicKey,
    identity: &Identity,
    id: CommunityId,
    repo: &Repository,
    mut command_rx: mpsc::Receiver<CommunityCommand>,
    config_strategy: impl super::super::strategy::PollStrategy + Sync,
    message_strategy: impl super::super::strategy::PollStrategy + Sync,
) -> anyhow::Result<()>
where
    E: HttpRPCExecutor<Args = (CommunityPublicKey, CommunityIdentityType)> + Sync,
{
    // Wait until we have the capabilities
    let caps = get_community_caps(&executor, &server_key, &id, &config_strategy).await;

    let (pub_keys, community_identity_type) = if caps.capabilities.contains(&Capability::Blind) {
        let (k1, k2) = blind15_ids(identity.individual_id(), &server_key)?;

        (
            CommunityPubKeys(non_empty_vec![k1.into(), k2.into()]),
            CommunityIdentityType::Blind15(
                blind15_key_pair(identity.ed25519_sec_key(), &server_key)?.0,
            ),
        )
    } else {
        (
            CommunityPubKeys(non_empty_vec![identity.individual_id().clone().into()]),
            CommunityIdentityType::Unblinded,
        )
    };

    repo.with_connection(|conn| conn.save_setting(&id, &pub_keys))
        .context("Saving community pub keys")?;

    let (download_command_tx, download_command_rx) = mpsc::channel(5);

    let sync_messages = super::download_community_messages::download_community_messages(
        &id,
        repo,
        download_command_rx,
        &executor,
        (server_key.clone(), community_identity_type.clone()),
        message_strategy,
    )
    .instrument(tracing::info_span!("download_messages"));

    let sync_info = super::sync_community_info::sync_community_info(
        &executor,
        (server_key.clone(), community_identity_type.clone()),
        &id,
        repo,
        config_strategy,
    )
    .instrument(tracing::info_span!("sync_info"));

    let serve_command = async {
        let mut rpc_join_set = LocalJoinSet::new();

        loop {
            let command = pin!(command_rx.recv());
            match select(rpc_join_set.next().fuse(), command.fuse()).await {
                Either::Left((_, _)) => {
                    // An RPC command completed, we don't really care about the result
                }

                Either::Right((Some(CommunityCommand::ExecuteRPC { request, callback }), _)) => {
                    tracing::info!(request = ?request, "Executing RPC command");

                    rpc_join_set.push(async {
                        let response = executor
                            .execute(
                                (server_key.clone(), community_identity_type.clone()),
                                request,
                            )
                            .await;

                        tracing::info!(
                            response = ?response,
                            "RPC command executed finished"
                        );

                        let _ = callback.send(response);
                    });
                }

                Either::Right((Some(CommunityCommand::SyncMessageCommand(cmd)), _)) => {
                    let _ = download_command_tx.send(cmd).await;
                }

                Either::Right((None, _)) => break,
            }
        }

        anyhow::Ok(())
    }
    .instrument(tracing::info_span!("serve_command"));

    try_join!(sync_messages, sync_info, serve_command)?;
    Ok(())
}

async fn get_community_caps(
    executor: impl HttpRPCExecutor<Args = (CommunityPublicKey, CommunityIdentityType)> + Sync,
    server_key: &CommunityPublicKey,
    id: &CommunityId,
    config_strategy: impl super::super::strategy::PollStrategy,
) -> ServerCapabilities {
    loop {
        match executor
            .execute_rpc(
                (server_key.clone(), CommunityIdentityType::None),
                (id.server_url().clone(), GetCapabilitiesRequest),
            )
            .await
        {
            Ok(caps) => return caps,
            Err(e) => {
                tracing::error!(?e, "Error getting capabilities");
                config_strategy.report_error(&e);
                let _ = config_strategy.next_poll().await;
            }
        }
    }
}
