use crate::clock::ClockSource;
use crate::config::{
    ConfigWrapper, ContactsConfig, ConvoInfoVolatileConfig, UserGroupsConfig, UserProfileConfig,
};
use crate::db::Repository;
use crate::http_api::executor::{HttpRPCRequest, HttpRPCResponse};
use crate::identity::Identity;
use crate::network::dynamic::DynamicNetwork;
use crate::rpc::RPCExecutor;
use crate::sogs_api::community_id::CommunityId;
use crate::worker::{CommunityCommand, TrimFileCacheCommand};
use std::path::PathBuf;
use std::sync::Arc;
use tokio::sync::{broadcast, mpsc, oneshot};

pub struct ConfigState {
    pub user_profile: ConfigWrapper<UserProfileConfig>,
    pub user_groups: ConfigWrapper<UserGroupsConfig>,
    pub contacts: ConfigWrapper<ContactsConfig>,
    pub convo_info: ConfigWrapper<ConvoInfoVolatileConfig>,
}

pub struct State {
    pub identity: Identity,
    pub config_state: ConfigState,
    pub repository: Arc<Repository>,
    pub file_cache_dir: PathBuf,
    pub clock_source: ClockSource,
    pub manual_poll_trigger_tx: broadcast::Sender<()>,
    pub network: Arc<DynamicNetwork>,
    pub trim_file_command_tx: mpsc::Sender<TrimFileCacheCommand>,
    pub community_commands: mpsc::Sender<(CommunityId, CommunityCommand)>,
}

impl State {
    pub fn community_rpc_executor(&self) -> CommunityRPCExecutor {
        CommunityRPCExecutor(self.community_commands.clone())
    }
}

pub struct CommunityRPCExecutor(mpsc::Sender<(CommunityId, CommunityCommand)>);

impl RPCExecutor<HttpRPCRequest, HttpRPCResponse> for CommunityRPCExecutor {
    type Args = CommunityId;

    async fn execute(
        &self,
        args: Self::Args,
        input: HttpRPCRequest,
    ) -> anyhow::Result<HttpRPCResponse> {
        let (tx, rx) = oneshot::channel();
        self.0
            .send((
                args,
                CommunityCommand::ExecuteRPC {
                    request: input,
                    callback: tx,
                },
            ))
            .await?;

        rx.await?
    }
}
