use crate::utils::errors::{AnyhowExt, ToStdError};
use std::future::Future;
use std::ops::{Deref, DerefMut};
use std::sync::Arc;
use std::time::{Duration, Instant};
use tokio::sync::Mutex as AsyncMutex;

enum State<T> {
    Idle,
    Loaded {
        value: Arc<T>,
        loaded_at: Instant,
    },
    Error {
        last_success: Option<Arc<T>>,
        error: Arc<anyhow::Error>,
        loaded_at: Instant,
    },
    RetryRequested {
        last_success: Option<Arc<T>>,
    },
}

impl<T> Default for State<T> {
    fn default() -> Self {
        State::Idle
    }
}

pub struct SharedAsyncRetrieveState<T> {
    state: AsyncMutex<State<T>>,
    refresh_interval: Duration,
    min_retry_interval: Duration,
}

impl<T> SharedAsyncRetrieveState<T> {
    pub fn new(refresh_interval: Duration, min_retry_interval: Duration) -> Self {
        Self {
            state: AsyncMutex::new(State::Idle),
            refresh_interval,
            min_retry_interval,
        }
    }

    pub async fn set_error(&self, error: Arc<anyhow::Error>) {
        let mut state = self.state.lock().await;
        *state = match std::mem::take(state.deref_mut()) {
            State::Loaded {
                value: last_success,
                ..
            }
            | State::Error {
                last_success: Some(last_success),
                ..
            } => State::Error {
                last_success: Some(last_success),
                error,
                loaded_at: Instant::now(),
            },

            _ => State::Error {
                last_success: None,
                error,
                loaded_at: Instant::now(),
            },
        };
    }

    pub async fn force_retry_next(&self) {
        let mut state = self.state.lock().await;
        *state = match std::mem::take(state.deref_mut()) {
            State::Loaded {
                value: last_success,
                ..
            }
            | State::Error {
                last_success: Some(last_success),
                ..
            } => State::RetryRequested {
                last_success: Some(last_success),
            },

            _ => State::RetryRequested { last_success: None },
        }
    }

    pub async fn get_or_retrieve<Func, Fut>(&self, retrieve: Func) -> anyhow::Result<Arc<T>>
    where
        Func: FnOnce() -> Fut,
        Fut: Future<Output = anyhow::Result<T>>,
    {
        let mut state = self.state.lock().await;
        match state.deref() {
            // Have a totally valid value, return it
            State::Loaded { value, loaded_at } if loaded_at.elapsed() < self.refresh_interval => {
                return Ok(value.clone());
            }

            // Error but not yet reach another retry
            State::Error {
                last_success,
                error,
                loaded_at,
                ..
            } if loaded_at.elapsed() < self.min_retry_interval => {
                return last_success
                    .as_ref()
                    .map(Arc::clone)
                    .ok_or_else(|| error.clone().to_std_error().into());
            }

            _ => tracing::debug!("Start retrieving"),
        }

        let result = retrieve().await;
        match (state.deref(), result) {
            // Have a fresh value
            (_, Ok(value)) => {
                let value = Arc::new(value);
                *state = State::Loaded {
                    value: value.clone(),
                    loaded_at: Instant::now(),
                };
                Ok(value)
            }

            // Have an error but has got a success value
            (State::Loaded { value, .. }, Err(e))
            | (
                State::Error {
                    last_success: Some(value),
                    ..
                },
                Err(e),
            ) => {
                let last_success = value.clone();
                *state = State::Error {
                    last_success: Some(last_success.clone()),
                    error: Arc::new(e),
                    loaded_at: Instant::now(),
                };

                Ok(last_success)
            }

            // Have an error and no success value
            (_, Err(e)) => {
                let (e, error) = e.share();
                *state = State::Error {
                    last_success: None,
                    error,
                    loaded_at: Instant::now(),
                };

                Err(e)
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::future::ready;
    use tokio::time::sleep;

    #[tokio::test]
    async fn async_retrieve_returns_error() {
        let state = SharedAsyncRetrieveState::<isize>::new(
            Duration::from_millis(200),
            Duration::from_millis(200),
        );

        assert!(
            state
                .get_or_retrieve(|| ready(Err(anyhow::anyhow!("error"))))
                .await
                .is_err()
        );

        // Should not retry within the min retry interval
        sleep(Duration::from_millis(100)).await;
        assert!(
            state
                .get_or_retrieve(|| ready(anyhow::Ok(1)))
                .await
                .is_err()
        );

        // Should retry after the min retry interval
        sleep(Duration::from_millis(200)).await;
        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(2)))
                .await
                .unwrap()),
            2
        );
    }

    #[tokio::test]
    async fn async_retrieve_success_works() {
        let state = SharedAsyncRetrieveState::<isize>::new(
            Duration::from_millis(200),
            Duration::from_millis(200),
        );

        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(1)))
                .await
                .unwrap()),
            1
        );

        // Should return the same value within the refresh interval
        sleep(Duration::from_millis(100)).await;
        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(2)))
                .await
                .unwrap()),
            1
        );

        // Should return a new value after the refresh interval
        sleep(Duration::from_millis(200)).await;
        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(3)))
                .await
                .unwrap()),
            3
        );

        // If there's an error, should return the last success value
        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(Err(anyhow::anyhow!("error"))))
                .await
                .unwrap()),
            3
        );
    }

    #[tokio::test]
    async fn retry_works() {
        let state = SharedAsyncRetrieveState::<isize>::new(
            Duration::from_millis(200),
            Duration::from_millis(200),
        );

        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(1)))
                .await
                .unwrap()),
            1
        );

        state.force_retry_next().await;

        assert_eq!(
            *(state
                .get_or_retrieve(|| ready(anyhow::Ok(2)))
                .await
                .unwrap()),
            2
        );
    }
}
