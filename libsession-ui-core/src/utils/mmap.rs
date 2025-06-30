use derive_more::AsRef;
use memmap2::Mmap;
use std::fmt::Debug;
use std::os::fd::AsRawFd;

#[derive(Debug)]
pub struct MmappedFile<T> {
    file: T,
    mmap: Mmap,
}

impl<T: AsRawFd> MmappedFile<T> {
    pub fn new(file: T) -> std::io::Result<Self> {
        let mmap = unsafe { Mmap::map(&file)? };
        Ok(Self { file, mmap })
    }

    pub fn into_inner(self) -> T {
        self.file
    }
}

impl<T> AsRef<[u8]> for MmappedFile<T> {
    fn as_ref(&self) -> &[u8] {
        &self.mmap
    }
}
