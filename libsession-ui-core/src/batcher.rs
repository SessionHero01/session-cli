use crate::non_empty_vec;
use crate::rpc::{RPC, RPCExecutor};
use crate::utils::errors::ToStdError;
use crate::utils::iter::non_empty::NonEmpty;
use crate::utils::sync::join_set::LocalJoinSet;
use anyhow::{Context, format_err};
use futures_util::{FutureExt, select};
use std::collections::VecDeque;
use std::future::pending;
use std::marker::PhantomData;
use std::ops::Add;
use std::sync::Arc;
use std::time::{Duration, Instant};
use tokio::sync::{mpsc, oneshot};

pub struct BatchRPCExecutor<I: Send, O, E: RPCExecutor<I, O>> {
    executor: E,
    tx: mpsc::Sender<PendingBatchRequest<(E::Args, I), O>>,
}

impl<I: Send, O, E: RPCExecutor<I, O> + Clone> Clone for BatchRPCExecutor<I, O, E> {
    fn clone(&self) -> Self {
        Self {
            executor: self.executor.clone(),
            tx: self.tx.clone(),
        }
    }
}

impl<I: Send, O, E: RPCExecutor<I, O>> BatchRPCExecutor<I, O, E> {
    pub fn new<BatchRPC, BatchRPCFactory, BatchRPCFactoryFut>(
        factory: BatchRPCFactory,
        executor: E,
        batch_window: Duration,
    ) -> (
        Self,
        BatchRPCExecutorRunner<I, O, E, BatchRPC, BatchRPCFactory, BatchRPCFactoryFut>,
    )
    where
        E: RPCExecutor<I, O> + Clone,
        BatchRPC: RPC<I, O>,
        BatchRPC::Output: TryInto<NonEmpty<O>, Error = anyhow::Error>,
        BatchRPCFactory: Fn(NonEmpty<I>) -> BatchRPCFactoryFut,
        BatchRPCFactoryFut: Future<Output = anyhow::Result<BatchRPC>> + Send,
        I: Batchable,
        E::Args: Batchable,
    {
        let (tx, rx) = mpsc::channel(10);
        (
            Self {
                tx,
                executor: executor.clone(),
            },
            BatchRPCExecutorRunner {
                rx,
                _batch_rpc: PhantomData,
                factory,
                batch_window,
                executor,
            },
        )
    }
}

impl<I, O, E> RPCExecutor<I, O> for BatchRPCExecutor<I, O, E>
where
    E: RPCExecutor<I, O> + Sync,
    I: Batchable + Send,
    O: Send,
    E::Args: Batchable + Send,
{
    type Args = E::Args;

    async fn execute(&self, args: Self::Args, input: I) -> anyhow::Result<O> {
        if !input.can_batch() || !args.can_batch() {
            return self.executor.execute(args, input).await;
        }

        let (tx, rx) = oneshot::channel();
        let args = args.into();
        self.tx
            .send(PendingBatchRequest {
                input: (args, input),
                tx,
            })
            .await
            .map_err(|_| format_err!("No batch runner is running"))?;

        rx.await.context("Cancelled")?
    }
}

pub struct BatchRPCExecutorRunner<
    I: Send,
    O,
    E: RPCExecutor<I, O>,
    BatchRPC,
    BatchRPCFactory,
    BatchRPCFactoryFut,
> {
    rx: mpsc::Receiver<PendingBatchRequest<(E::Args, I), O>>,
    factory: BatchRPCFactory,
    _batch_rpc: PhantomData<(BatchRPC, BatchRPCFactoryFut)>,
    batch_window: Duration,
    executor: E,
}

impl<I, O, E, BatchRPC, BatchRPCFactory, BatchRPCFactoryFut>
    BatchRPCExecutorRunner<I, O, E, BatchRPC, BatchRPCFactory, BatchRPCFactoryFut>
where
    E: RPCExecutor<I, O> + Send + Sync,
    BatchRPC: RPC<I, O> + Send + 'static,
    BatchRPC::Output: TryInto<NonEmpty<O>, Error = anyhow::Error> + Send + 'static,
    BatchRPCFactory: Fn(NonEmpty<I>) -> BatchRPCFactoryFut,
    BatchRPCFactoryFut: Future<Output = anyhow::Result<BatchRPC>> + Send,
    I: Batchable + Send + 'static,
    O: Send + 'static,
    E::Args: Batchable + Send,
{
    pub async fn run(self) -> anyhow::Result<()> {
        let Self {
            mut rx,
            batch_window,
            executor,
            factory,
            ..
        } = self;

        let mut join_set = LocalJoinSet::new();

        // Oldest -> Newest
        let mut batching: VecDeque<(Instant, NonEmpty<PendingBatchRequest<(E::Args, I), O>>)> =
            Default::default();

        loop {
            let get_next_batch = async {
                if let Some(t) = batching.front().map(|s| s.0) {
                    tokio::time::sleep_until(t.into()).await;
                    batching.pop_front().unwrap().1
                } else {
                    pending().await
                }
            };

            select! {
                batch = get_next_batch.fuse() => {
                    join_set.push(Self::run_batch(&executor, batch, &factory));
                }

                batch = rx.recv().fuse() => {
                    if let Some(batch) = batch {
                        Self::insert_to_batching(&mut batching, batch, batch_window);
                    }
                }
                _ = join_set.next().fuse() => {}
            }
        }
    }

    fn insert_to_batching(
        batching: &mut VecDeque<(Instant, NonEmpty<PendingBatchRequest<(E::Args, I), O>>)>,
        req: PendingBatchRequest<(E::Args, I), O>,
        batch_window: Duration,
    ) {
        if let Some((_, reqs)) = batching
            .iter_mut()
            .find(|(_, reqs)| reqs.head().input.should_batch_with(&req.input))
        {
            reqs.push(req);
        } else {
            let deadline = Instant::now().add(batch_window);
            batching.push_back((deadline, non_empty_vec![req]));
        }
    }

    async fn run_batch(
        executor: &E,
        requests: NonEmpty<PendingBatchRequest<(E::Args, I), O>>,
        factory: &BatchRPCFactory,
    ) {
        let mut input = Vec::with_capacity(requests.len());
        let mut callbacks = Vec::with_capacity(requests.len());
        let mut args = None;

        for req in requests.into_iter() {
            input.push(req.input.1);
            if args.is_none() {
                args.replace(req.input.0);
            }
            callbacks.push(req.tx);
        }

        let input = NonEmpty::from_vec(input).unwrap();
        let args = args.unwrap();

        let result: anyhow::Result<NonEmpty<O>> = async move {
            let req: BatchRPC = (*factory)(input).await.context("Creating batch request")?;
            executor
                .execute_rpc::<BatchRPC>(args, req)
                .await?
                .try_into()
                .context("Parsing batch response")
        }
        .await;

        match result {
            Ok(v) => {
                for (res, tx) in v.into_iter().zip(callbacks) {
                    let _ = tx.send(Ok(res));
                }
            }
            Err(e) => {
                let e = Arc::new(e);
                for tx in callbacks {
                    let _ = tx.send(Err(e.clone().to_std_error().into()));
                }
            }
        }
    }
}

pub trait Batchable {
    fn should_batch_with(&self, other: &Self) -> bool;

    fn can_batch(&self) -> bool {
        true
    }
}

impl Batchable for () {
    fn should_batch_with(&self, _other: &Self) -> bool {
        true
    }
}

impl<T1, T2> Batchable for (T1, T2)
where
    T1: Batchable,
    T2: Batchable,
{
    fn should_batch_with(&self, other: &Self) -> bool {
        self.0.should_batch_with(&other.0) && self.1.should_batch_with(&other.1)
    }
}

struct PendingBatchRequest<Input, Output> {
    input: Input,
    tx: oneshot::Sender<anyhow::Result<Output>>,
}
