use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum NotifyMode {
    Defaulted,
    All,
    Disabled,
    MentionsOnly,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum ExpiryMode {
    None,
    AfterSend,
    AfterRead,
}
