use std::time::Duration;

pub trait PollStrategy {
    fn next_poll(&self) -> impl Future<Output = Option<()>> + Send;
    fn report_error(&self, error: &anyhow::Error);
}

#[derive(Clone, Copy)]
pub struct SimplePollStrategy {
    interval: Duration,
}

impl SimplePollStrategy {
    pub fn new(interval: Duration) -> Self {
        Self { interval }
    }
}

impl PollStrategy for SimplePollStrategy {
    async fn next_poll(&self) -> Option<()> {
        tokio::time::sleep(self.interval).await;
        Some(())
    }

    fn report_error(&self, _error: &anyhow::Error) {}
}

impl<T: PollStrategy + Sync> PollStrategy for &T {
    async fn next_poll(&self) -> Option<()> {
        (*self).next_poll().await
    }

    fn report_error(&self, error: &anyhow::Error) {
        (*self).report_error(error)
    }
}
