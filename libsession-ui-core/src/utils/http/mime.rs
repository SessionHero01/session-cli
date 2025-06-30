use http::Request;
use mime::Mime;

pub trait ContentTypeExt {
    fn get_content_type(&self) -> Option<Mime>;
    fn set_content_type(&mut self, mime: Mime) -> anyhow::Result<()>;
}

impl ContentTypeExt for http::header::HeaderMap {
    fn get_content_type(&self) -> Option<Mime> {
        self.get(http::header::CONTENT_TYPE)
            .and_then(|v| v.to_str().ok())
            .and_then(|v| v.parse().ok())
    }

    fn set_content_type(&mut self, mime: Mime) -> anyhow::Result<()> {
        self.insert(http::header::CONTENT_TYPE, mime.to_string().parse()?);
        Ok(())
    }
}

impl<B> ContentTypeExt for Request<B> {
    fn get_content_type(&self) -> Option<Mime> {
        self.headers().get_content_type()
    }

    fn set_content_type(&mut self, mime: Mime) -> anyhow::Result<()> {
        self.headers_mut().set_content_type(mime)
    }
}

impl<B> ContentTypeExt for http::Response<B> {
    fn get_content_type(&self) -> Option<Mime> {
        self.headers().get_content_type()
    }

    fn set_content_type(&mut self, mime: Mime) -> anyhow::Result<()> {
        self.headers_mut().set_content_type(mime)
    }
}
