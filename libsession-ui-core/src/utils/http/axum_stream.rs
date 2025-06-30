use crate::utils::http::axum_extractor::ResponseContentType;
use anyhow::Context;
use axum::body::HttpBody;
use bytes::Bytes;
use futures_core::Stream;
use http_body::Frame;
use pin_project_lite::pin_project;
use prost::Message;
use serde::Serialize;
use std::pin::Pin;
use std::task::{ready, Poll};

enum FrameState {
    Idle,
    HeaderSent { data: Bytes },
    DataSent,
}

pin_project! {
    pub struct StreamingBody<S>  {
        #[pin]
        stream: S,
        content_type: ResponseContentType,
        frame_state: FrameState,
    }
}

impl<S> StreamingBody<S> {
    pub fn new(stream: S, content_type: ResponseContentType) -> Self {
        Self {
            stream,
            content_type,
            frame_state: FrameState::Idle,
        }
    }
}

impl<T, S> HttpBody for StreamingBody<S>
where
    S: Stream<Item = anyhow::Result<T>>,
    T: Serialize + Message + 'static,
{
    type Data = Bytes;
    type Error = anyhow::Error;

    fn poll_frame(
        self: Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> Poll<Option<Result<Frame<Self::Data>, Self::Error>>> {
        let mut this = self.project();

        match this.frame_state {
            FrameState::Idle => {}
            FrameState::HeaderSent { data } => {
                // Len header is sent, send data frame
                let data = data.clone();
                *this.frame_state = FrameState::DataSent;
                cx.waker().wake_by_ref();
                return Poll::Ready(Some(Ok(Frame::data(data))));
            }
            FrameState::DataSent => {
                // Data frame is sent, send CRLF frame
                *this.frame_state = FrameState::Idle;
                cx.waker().wake_by_ref();
                return Poll::Ready(Some(Ok(Frame::data(Bytes::from_static(b"\r\n")))));
            }
        };

        let content_type = this.content_type;

        let serializer = move |item: T| -> anyhow::Result<Vec<u8>> {
            match *content_type {
                ResponseContentType::Protobuf => Ok(item.encode_to_vec()),
                ResponseContentType::Json => serde_json::to_vec(&item).context("Encoding JSON"),
            }
        };

        let Some(item) = ready!(this.stream.as_mut().poll_next(cx)) else {
            return Poll::Ready(None);
        };

        match item.and_then(serializer) {
            Ok(buf) => {
                let len_frame = format!("{:X}\r\n", buf.len()).into_bytes();
                *this.frame_state = FrameState::HeaderSent { data: buf.into() };
                cx.waker().wake_by_ref();
                Poll::Ready(Some(Ok(Frame::data(len_frame.into()))))
            }
            Err(e) => Poll::Ready(Some(Err(e))),
        }
    }
}
