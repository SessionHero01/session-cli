use derive_more::Display;
use pin_project_lite::pin_project;
use std::future::Future;
use std::pin::Pin;
use std::task::{ready, Context, Poll};
use std::time::Duration;
use thiserror::Error;
use tokio::time::{timeout, Timeout as TokioTimeout};

pub trait TimeoutFutureExt: Future {
    fn timeout(self, duration: Duration) -> Timeout<Self>
    where
        Self: Sized,
    {
        Timeout {
            inner: timeout(duration, self),
        }
    }
}

#[derive(Debug, Error, Default, Display)]
pub struct TimeoutError;

impl<F> TimeoutFutureExt for F where F: Future {}

pin_project! {
    pub struct Timeout<F> {
        #[pin]
        inner: TokioTimeout<F>,
    }
}

impl<T, E, F> Future for Timeout<F>
where
    F: Future<Output = Result<T, E>> + Unpin,
    E: Into<anyhow::Error>,
{
    type Output = anyhow::Result<T>;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        match ready!(self.project().inner.poll(cx)) {
            Ok(Ok(v)) => Poll::Ready(Ok(v)),
            Ok(Err(e)) => Poll::Ready(Err(e.into())),
            Err(_) => Poll::Ready(Err(TimeoutError.into())),
        }
    }
}
