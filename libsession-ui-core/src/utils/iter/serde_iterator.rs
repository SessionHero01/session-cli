use serde::ser::SerializeSeq;
use serde::{Serialize, Serializer};
use std::cell::RefCell;

pub struct SerdeIterator<I>(RefCell<Option<I>>);

impl<I> SerdeIterator<I> {
    pub fn new(iterator: I) -> Self {
        SerdeIterator(RefCell::new(Some(iterator)))
    }
}

pub trait IteratorExt: Iterator {
    fn to_ser(self) -> SerdeIterator<Self>
    where
        Self: Sized,
    {
        SerdeIterator::new(self)
    }
}

impl<I: Iterator> IteratorExt for I {}

impl<I: Iterator> Serialize for SerdeIterator<I>
where
    I::Item: Serialize,
{
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let mut seq = serializer.serialize_seq(None)?;

        let iterator = self
            .0
            .borrow_mut()
            .take()
            .ok_or_else(|| serde::ser::Error::custom("Cannot serialize an iterator twice"))?;

        for item in iterator {
            seq.serialize_element(&item)?;
        }

        seq.end()
    }
}
