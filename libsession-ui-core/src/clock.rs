use crate::utils::sync::watcher::Watcher;
use derive_more::Display;
use num_traits::ToPrimitive;
use rusqlite::types::{ToSqlOutput, Value};
use rusqlite::ToSql;
use serde::{Deserialize, Serialize};
use std::num::NonZeroU64;
use std::time::{Instant, SystemTime, UNIX_EPOCH};

pub fn local_timestamp() -> Timestamp {
    Timestamp::from_mills(
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_millis(),
    )
    .expect("Unix timestamp to be NON-ZERO")
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, Display, Ord, PartialOrd, Eq, PartialEq)]
pub struct Timestamp(NonZeroU64);

impl Timestamp {
    pub fn from_mills(num: impl ToPrimitive) -> Option<Self> {
        let num: u64 = num.to_u64()?;
        NonZeroU64::new(num).map(Self)
    }
}

impl ToSql for Timestamp {
    fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
        Ok(ToSqlOutput::Owned(Value::Integer(self.0.get() as i64)))
    }
}

impl Timestamp {
    pub fn as_millis(&self) -> u64 {
        self.0.get()
    }

    pub fn as_secs(&self) -> u64 {
        self.0.get() / 1000
    }
}

#[derive(Debug, Clone, Copy, Ord, PartialOrd, Eq, PartialEq)]
pub struct UnixTimestampFloat(pub Timestamp);

impl Serialize for UnixTimestampFloat {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        (self.0.as_millis() as f64 / 1000.0f64).serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for UnixTimestampFloat {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let f = f64::deserialize(deserializer)?;
        Ok(UnixTimestampFloat(
            Timestamp::from_mills((f * 1000.0) as u64)
                .ok_or_else(|| serde::de::Error::custom("Failed to convert float to timestamp"))?,
        ))
    }
}

#[derive(Clone)]
pub struct ClockSource {
    baseline_time_and_instant: Watcher<Option<(Timestamp, Instant)>>,
}

impl AsRef<ClockSource> for ClockSource {
    fn as_ref(&self) -> &ClockSource {
        self
    }
}

impl Default for ClockSource {
    fn default() -> Self {
        ClockSource {
            baseline_time_and_instant: Watcher::new(None),
        }
    }
}

impl ClockSource {
    pub fn submit_calibration(&self, instant: Instant, timestamp: Timestamp) {
        let error_mills = (local_timestamp().as_millis() as i64) - (timestamp.as_millis() as i64);
        tracing::info!(
            "Calibrating clock with timestamp: {:?}, current error = {error_mills}ms",
            timestamp
        );

        self.baseline_time_and_instant
            .send_replace(Some((timestamp, instant)));
    }

    pub fn calibrated_now(&self) -> Option<Timestamp> {
        let adjusted = self.baseline_time_and_instant.borrow();
        if let Some(baseline) = *adjusted {
            Some(Self::calibrated(&baseline))
        } else {
            None
        }
    }

    pub fn now_or_uncalibrated(&self) -> Timestamp {
        self.calibrated_now().unwrap_or_else(|| local_timestamp())
    }

    pub async fn await_calibrated(&self) -> Timestamp {
        let mut rx = self.baseline_time_and_instant.subscribe();
        let b = rx.wait_for(|v| v.is_some()).await.unwrap();
        Self::calibrated(b.as_ref().unwrap())
    }

    fn calibrated((baseline_mills, instant): &(Timestamp, Instant)) -> Timestamp {
        let elapsed_mills = instant.elapsed().as_millis() as u64;
        Timestamp::from_mills(baseline_mills.as_millis() + elapsed_mills)
            .expect("Calibrated time to be NON-ZERO")
    }
}
