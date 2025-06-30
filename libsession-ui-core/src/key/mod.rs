pub mod curve25519;
pub mod ed25519;

mod macros;

use macros::define_key_type;

pub trait Key: AsRef<[u8]> {
    const LEN: usize;
}
