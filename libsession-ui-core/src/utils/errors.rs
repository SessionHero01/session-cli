use anyhow::format_err;
use derive_more::Display;
use http::StatusCode;
use std::error::Error as StdError;
use std::fmt::Debug;
use std::sync::Arc;

pub struct RetryableError {
    pub source: anyhow::Error,
    pub retryable: bool,
}

impl Debug for RetryableError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Debug::fmt(&self.source, f)
    }
}

impl Display for RetryableError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Display::fmt(&self.source, f)
    }
}

impl StdError for RetryableError {
    fn source(&self) -> Option<&(dyn StdError + 'static)> {
        Some(self.source.as_ref())
    }
}

impl From<(StatusCode, &str)> for RetryableError {
    fn from((code, msg): (StatusCode, &str)) -> Self {
        let source = format_err!("Error with http status: {code}, message = {msg}",);
        let retryable = code.is_server_error();
        RetryableError { source, retryable }
    }
}

pub trait ToStdError {
    fn to_std_error(self) -> impl StdError;
}

#[derive(Debug, Display)]
struct AnyhowError(Arc<anyhow::Error>);

impl ToStdError for Arc<anyhow::Error> {
    fn to_std_error(self) -> impl StdError {
        AnyhowError(self)
    }
}

impl StdError for AnyhowError {
    fn source(&self) -> Option<&(dyn StdError + 'static)> {
        Some(self.0.as_ref().as_ref())
    }
}

pub trait AnyhowExt: Sized {
    fn share(self) -> (Self, Arc<Self>);
    fn can_retry(&self) -> bool;
}

impl AnyhowExt for anyhow::Error {
    fn share(self) -> (Self, Arc<Self>) {
        let arc = Arc::new(self);
        (arc.clone().to_std_error().into(), arc)
    }

    fn can_retry(&self) -> bool {
        self.chain()
            .filter_map(|e| e.downcast_ref::<RetryableError>())
            .map(|e| e.retryable)
            .next()
            .unwrap_or(true)
    }
}

pub trait RetryableContext: Sized {
    type FromErr;
    type Target;

    // Explicitly mark the error as retryable or not
    fn with_retryable(self, f: impl FnOnce(&Self::FromErr) -> bool) -> Self::Target;
}

impl<T, E: Into<anyhow::Error>> RetryableContext for Result<T, E> {
    type FromErr = E;
    type Target = anyhow::Result<T>;

    fn with_retryable(self, f: impl FnOnce(&Self::FromErr) -> bool) -> Self::Target {
        self.map_err(|e| {
            RetryableError {
                retryable: f(&e),
                source: e.into(),
            }
            .into()
        })
    }
}
