use async_stream::stream;
use derive_more::Deref;
use futures_core::Stream;
use futures_util::future::try_select;
use std::future::Future;
use std::marker::PhantomData;
use std::pin::pin;
use tokio::sync::watch;

#[derive(Deref)]
pub struct Watcher<T> {
    #[deref]
    tx: watch::Sender<T>,
    rx: watch::Receiver<T>,
}

impl<T> Clone for Watcher<T> {
    fn clone(&self) -> Self {
        Self {
            tx: self.tx.clone(),
            rx: self.rx.clone(),
        }
    }
}

impl<T> Watcher<T> {
    pub fn new(value: T) -> Self {
        let (tx, rx) = watch::channel(value);
        Self { tx, rx }
    }

    pub fn subscribe(&self) -> watch::Receiver<T> {
        self.rx.clone()
    }
}

pub trait WatcherReceiver<T: Send + Sync + 'static>: Send + Sync {
    fn resubscribe(&self) -> Self;
    fn borrow(&self) -> impl Deref<Target = T>;
    fn changed(&mut self) -> impl Future<Output = Result<(), ()>> + Send + Sync;

    fn map<NewT, F>(self, transform: F) -> WatcherReceiverMap<T, NewT, Self, F>
    where
        F: Fn(&T) -> NewT + Clone + Send + Sync,
        NewT: Send + Sync + 'static,
        Self: Sized,
    {
        WatcherReceiverMap {
            old_receiver: self,
            transform,
            _phantom: PhantomData,
        }
    }

    fn combine_with<T2, R2, F, T3>(
        self,
        other: R2,
        combine: F,
    ) -> WatcherReceiverCombine<T, T2, Self, R2, F, T3>
    where
        R2: WatcherReceiver<T2>,
        F: Fn(&T, &T2) -> T3 + Clone + Send + Sync,
        T2: Send + Sync + 'static,
        T3: Send + Sync + 'static,
        Self: Sized,
    {
        WatcherReceiverCombine {
            receiver1: self,
            receiver2: other,
            combine,
            _phantom: PhantomData,
        }
    }

    fn into_stream(mut self) -> impl Stream<Item = T> + Send + 'static
    where
        Self: Sized + 'static,
        T: Clone + Send + Sync,
    {
        stream! {
            while self.changed().await.is_ok() {
                let value = self.borrow().clone();
                yield value;
            }
        }
    }

    fn connect_to(mut self, watcher: Watcher<T>) -> impl Future<Output = ()> + Send + Sync
    where
        Self: Sized,
        T: Eq + Clone,
    {
        async move {
            loop {
                watcher.send_if_modified(|value| {
                    let new = self.borrow();
                    if *value != *new {
                        value.clone_from(&*new);
                        true
                    } else {
                        false
                    }
                });

                if self.changed().await.is_err() {
                    break;
                }
            }
        }
    }
}

pub fn combine_watcher_receivers<T1, T2, R1, R2, F, T>(
    receiver1: R1,
    receiver2: R2,
    combine: F,
) -> WatcherReceiverCombine<T1, T2, R1, R2, F, T>
where
    R1: WatcherReceiver<T1>,
    R2: WatcherReceiver<T2>,
    F: Fn(&T1, &T2) -> T + Clone,
    T1: Send + Sync + 'static,
    T2: Send + Sync + 'static,
{
    WatcherReceiverCombine {
        receiver1,
        receiver2,
        combine,
        _phantom: PhantomData,
    }
}

impl<T: Send + Sync + 'static> WatcherReceiver<T> for watch::Receiver<T> {
    fn resubscribe(&self) -> Self {
        self.clone()
    }

    fn borrow(&self) -> impl Deref<Target = T> {
        self.borrow()
    }

    async fn changed(&mut self) -> Result<(), ()> {
        watch::Receiver::changed(self).await.map_err(|_| ())
    }
}

pub struct WatcherReceiverCombine<T1, T2, R1, R2, F, T>
where
    R1: WatcherReceiver<T1>,
    R2: WatcherReceiver<T2>,
    F: Fn(&T1, &T2) -> T + Clone,
    T1: Send + Sync + 'static,
    T2: Send + Sync + 'static,
{
    receiver1: R1,
    receiver2: R2,
    combine: F,
    _phantom: PhantomData<(T1, T2)>,
}

impl<T1, T2, R1, R2, F, T> WatcherReceiver<T> for WatcherReceiverCombine<T1, T2, R1, R2, F, T>
where
    R1: WatcherReceiver<T1> + Send + Sync,
    R2: WatcherReceiver<T2> + Send + Sync,
    F: Fn(&T1, &T2) -> T + Clone + Send + Sync,
    T1: Send + Sync + 'static,
    T2: Send + Sync + 'static,
    T: Send + Sync + 'static,
{
    fn resubscribe(&self) -> Self {
        Self {
            receiver1: self.receiver1.resubscribe(),
            receiver2: self.receiver2.resubscribe(),
            combine: self.combine.clone(),
            _phantom: PhantomData,
        }
    }

    fn borrow(&self) -> impl Deref<Target = T> {
        let data1 = self.receiver1.borrow();
        let data2 = self.receiver2.borrow();
        WatcherReceiverDeref((self.combine)(&*data1, &*data2))
    }

    async fn changed(&mut self) -> Result<(), ()>
    where
        T: Send + Sync,
    {
        let r1 = pin!(self.receiver1.changed());
        let r2 = pin!(self.receiver2.changed());
        try_select(r1, r2).await.map(|_| ()).map_err(|_| ())
    }
}

pub struct WatcherReceiverMap<OldT, NewT, R, F>
where
    F: Fn(&OldT) -> NewT + Clone,
    R: WatcherReceiver<OldT>,
    OldT: Send + Sync + 'static,
    NewT: Send + Sync + 'static,
{
    old_receiver: R,
    transform: F,
    _phantom: PhantomData<OldT>,
}

struct WatcherReceiverDeref<T>(T);

impl<T> Deref for WatcherReceiverDeref<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl<OldT, NewT, R, F> WatcherReceiver<NewT> for WatcherReceiverMap<OldT, NewT, R, F>
where
    F: Fn(&OldT) -> NewT + Clone + Send + Sync,
    R: WatcherReceiver<OldT>,
    OldT: Send + Sync + 'static,
    NewT: Send + Sync + 'static,
{
    fn resubscribe(&self) -> Self {
        Self {
            old_receiver: self.old_receiver.resubscribe(),
            transform: self.transform.clone(),
            _phantom: PhantomData,
        }
    }

    fn borrow(&self) -> impl Deref<Target = NewT> {
        let new_data = (self.transform)(&*self.old_receiver.borrow());
        WatcherReceiverDeref(new_data)
    }

    async fn changed(&mut self) -> Result<(), ()> {
        self.old_receiver.changed().await
    }
}

pub trait SenderExt<T> {
    // Calls the closure with a mutable reference to the value and a flag indicating whether the value was changed.
    fn with_mut<R>(&self, f: impl FnOnce(&mut T, &mut bool) -> R) -> R;
}

impl<T> SenderExt<T> for watch::Sender<T> {
    fn with_mut<R>(&self, f: impl FnOnce(&mut T, &mut bool) -> R) -> R {
        let mut value = None;
        self.send_if_modified(|v| {
            let mut changed = false;
            value.replace(f(v, &mut changed));
            changed
        });
        value.unwrap()
    }
}
