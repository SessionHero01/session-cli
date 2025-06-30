use std::borrow::Cow;
use url::Url;

pub trait UrlExt {
    fn path_and_query(&self) -> Cow<str>;
}

impl UrlExt for Url {
    fn path_and_query(&self) -> Cow<str> {
        if let Some(query) = self.query() {
            Cow::Owned(format!("{}?{}", self.path(), query))
        } else {
            Cow::Borrowed(self.path())
        }
    }
}
