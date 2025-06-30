use anyhow::Context;
use std::any::type_name;
use std::future::Future;
use std::sync::Arc;

pub trait RPC<UpstreamInput, UpstreamOutput> {
    type Output;

    fn into_upstream_input(self) -> anyhow::Result<UpstreamInput>;
    fn output_from_upstream(
        output: UpstreamOutput,
    ) -> impl Future<Output = anyhow::Result<Self::Output>> + Send;
}

pub trait RPCExecutor<Input, Output> {
    type Args;

    fn execute(
        &self,
        args: Self::Args,
        input: Input,
    ) -> impl Future<Output = anyhow::Result<Output>> + Send;

    fn execute_rpc<T>(
        &self,
        args: Self::Args,
        rpc: T,
    ) -> impl Future<Output = anyhow::Result<T::Output>> + Send
    where
        T: RPC<Input, Output> + Send,
        Self::Args: Send,
        Self: Sync,
    {
        async move {
            let request: Input = rpc.into_upstream_input().with_context(|| {
                format!(
                    "Error convert {} to RPC request type {}",
                    type_name::<T>(),
                    type_name::<Input>()
                )
            })?;

            let response = self.execute(args, request).await?;
            T::output_from_upstream(response).await.with_context(|| {
                format!(
                    "Error convert RPC response type {} to {}",
                    type_name::<Output>(),
                    type_name::<T::Output>()
                )
            })
        }
    }
}

impl<E, Input, Output> RPCExecutor<Input, Output> for &E
where
    E: RPCExecutor<Input, Output> + Sync,
    Input: Send,
    E::Args: Send,
{
    type Args = E::Args;

    async fn execute(&self, args: Self::Args, input: Input) -> anyhow::Result<Output> {
        (**self).execute(args, input).await
    }
}

impl<E, Input, Output> RPCExecutor<Input, Output> for Arc<E>
where
    E: RPCExecutor<Input, Output> + Send + Sync,
    Input: Send,
    E::Args: Send,
{
    type Args = E::Args;

    async fn execute(&self, args: Self::Args, input: Input) -> anyhow::Result<Output> {
        (**self).execute(args, input).await
    }
}
