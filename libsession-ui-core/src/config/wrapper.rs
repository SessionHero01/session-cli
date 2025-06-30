use crate::oxenss::retrieve::Message;
use libsession_util_sys::seqno_t;
use parking_lot::RwLock;
use std::ops::DerefMut;
use std::{ops::Deref, sync::Arc};
use tokio::sync::{broadcast, mpsc, oneshot};

pub type PushRequestCallback = oneshot::Sender<anyhow::Result<()>>;
pub type ConfigChanges = ();

pub struct ConfigWrapper<C> {
    inner: Arc<RwLock<C>>,
    push_requests: mpsc::UnboundedSender<Option<PushRequestCallback>>,
    change_notifications: (
        broadcast::Sender<ConfigChanges>,
        broadcast::Receiver<ConfigChanges>,
    ),
}

impl<C> Clone for ConfigWrapper<C> {
    fn clone(&self) -> Self {
        Self {
            inner: self.inner.clone(),
            push_requests: self.push_requests.clone(),
            change_notifications: (
                self.change_notifications.0.clone(),
                self.change_notifications.0.subscribe(),
            ),
        }
    }
}

impl<C> ConfigWrapper<C>
where
    C: super::Config,
{
    pub fn new(config: C) -> (Self, mpsc::UnboundedReceiver<Option<PushRequestCallback>>) {
        let (push_requests, push_requests_rx) = mpsc::unbounded_channel();
        let change_notifications = broadcast::channel(1);

        // If the config needs a push (it could have been restored from db), send a push request now
        if config.needs_push() {
            let _ = push_requests.send(None);
        }

        (
            Self {
                inner: Arc::new(RwLock::new(config)),
                push_requests,
                change_notifications,
            },
            push_requests_rx,
        )
    }

    pub fn subscribe(&self) -> broadcast::Receiver<ConfigChanges> {
        self.change_notifications.0.subscribe()
    }

    pub fn merge(&self, messages: &[Message]) -> usize {
        if messages.is_empty() {
            return 0;
        }

        let needs_push: bool;
        let num_merged: usize;

        {
            let mut config = self.inner.write();
            num_merged = config.merge(messages).iter().filter(|r| r.is_ok()).count();
            needs_push = config.needs_push();
        }

        if num_merged > 0 {
            self.change_notifications.0.send(()).ok();
        }

        if needs_push {
            let _ = self.push_requests.send(None);
        }

        num_merged
    }

    pub fn borrow(&self) -> impl Deref<Target = C> {
        self.inner.read()
    }

    pub(super) fn borrow_mut(&self) -> impl DerefMut<Target = C> {
        self.inner.write()
    }

    fn do_mutate<T>(
        &self,
        can_send_push_request: bool,
        f: impl FnOnce(&mut C) -> T,
        cb: Option<PushRequestCallback>,
    ) -> T {
        let needs_push: bool;
        let ret: T;
        let changed: bool;

        {
            let mut config = self.inner.write();
            ret = f(&mut config);
            needs_push = config.needs_push();
            changed = config.needs_dump();
        }

        if changed {
            let _ = self.change_notifications.0.send(());
        }

        if needs_push && can_send_push_request {
            let _ = self.push_requests.send(cb);
        } else if let Some(cb) = cb {
            let _ = cb.send(Ok(()));
        }

        ret
    }

    pub fn confirm_pushed(&self, seq: seqno_t, msg_hashes: &[&str]) {
        self.do_mutate(
            false,
            |config| {
                config.confirm_pushed(seq, msg_hashes);
            },
            None,
        );
    }

    pub fn mutate<T>(&self, f: impl FnOnce(&mut C) -> T) -> T {
        self.do_mutate(true, f, None)
    }

    pub async fn mutate_and_await_push<T>(&self, f: impl FnOnce(&mut C) -> T) -> anyhow::Result<T> {
        let (tx, rx) = oneshot::channel();
        let ret = self.do_mutate(true, f, Some(tx));

        rx.await??;
        Ok(ret)
    }
}
