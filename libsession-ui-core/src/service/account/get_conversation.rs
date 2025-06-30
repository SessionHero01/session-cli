use crate::clock::{ClockSource, Timestamp};
use crate::db::conversations::{
    conversation_details_query, conversation_messages_query_after,
    conversation_messages_query_limit,
};
use crate::db::Repository;
use crate::protos::{GetConversationMessagesRequest, GetConversationMessagesResponse};
use crate::service::{Service, StreamingService};
use crate::sogs_api::community_id::CommunityId;
use crate::utils::timeout::TimeoutFutureExt;
use crate::worker::{CommunityCommand, DownloadMessageCommand};
use anyhow::{bail, ensure, Context};
use futures_core::Stream;
use futures_util::TryStreamExt;
use libsession_protos::protos::get_conversation_messages_request::Earlier;
use libsession_protos::protos::{GetConversationDetailsRequest, GetConversationDetailsResponse};
use std::num::NonZeroUsize;
use std::str::FromStr;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::{mpsc, oneshot};

#[derive(Clone)]
pub struct GetConversationMessagesService {
    pub repo: Arc<Repository>,
    pub clock: ClockSource,
    pub community_commands: mpsc::Sender<(CommunityId, CommunityCommand)>,
}

impl Service for GetConversationMessagesService {
    type Request = GetConversationMessagesRequest;
    type Response = GetConversationMessagesResponse;

    async fn call(&self, req: Self::Request) -> anyhow::Result<Self::Response> {
        let GetConversationMessagesRequest {
            id,
            until,
            earlier: Some(earlier),
        } = req
        else {
            bail!("Invalid request: missing earlier field");
        };

        let until = match until {
            Some(t) => Timestamp::from_mills(t).context("Invalid timestamp")?,
            None => self.clock.now_or_uncalibrated(),
        };

        let messages = match earlier {
            Earlier::Limit(limit) => {
                let limit = NonZeroUsize::new(limit as usize).context("Invalid limit")?;
                let query = conversation_messages_query_limit(id.clone(), until, limit);

                match self.repo.query(&query) {
                    Ok(r) if r.is_empty() => {
                        // If we get nothing from db and this is a community,
                        // try to load earlier community message and reload from db again
                        if let Ok(community_id) = CommunityId::from_str(&id) {
                            let (tx, rx) = oneshot::channel();
                            self.community_commands
                                .send((
                                    community_id,
                                    CommunityCommand::SyncMessageCommand(
                                        DownloadMessageCommand::LoadEarlierMessage { callback: tx },
                                    ),
                                ))
                                .await?;

                            let _ = rx.timeout(Duration::from_secs(5)).await??;
                            self.repo.query(&query)
                        } else {
                            Ok(r)
                        }
                    }

                    r => r,
                }
            }

            Earlier::After(after) => {
                let after = Timestamp::from_mills(after).context("Invalid timestamp")?;
                ensure!(after < until, "Invalid after timestamp");
                self.repo
                    .query(&conversation_messages_query_after(id, until, after))
            }
        }?;

        Ok(GetConversationMessagesResponse {
            messages: messages.into_vec(),
        })
    }
}

#[derive(Clone)]
pub struct GetConversationDetailsService(pub Arc<Repository>);

impl StreamingService for GetConversationDetailsService {
    type Request = GetConversationDetailsRequest;
    type Item = anyhow::Result<GetConversationDetailsResponse>;

    async fn call(
        &self,
        req: Self::Request,
    ) -> anyhow::Result<impl Stream<Item = Self::Item> + Send + 'static> {
        Ok(self
            .0
            .clone()
            .rerun_query_on_changes(Duration::from_secs(1), conversation_details_query(req.id))?
            .map_ok(|r| GetConversationDetailsResponse {
                details: r.into_iter().next(),
            }))
    }
}
