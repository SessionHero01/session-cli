use anyhow::ensure;

use crate::key::curve25519::Curve25519PubKey;
use crate::key::ed25519::{ED25519PubKey, ED25519SecKey};
use crate::session_id::{Blind25ID, IndividualID};
use crate::{bindings, session_id::Blind15ID};

pub fn blind15_ids(
    individual_id: &IndividualID,
    server_public_key: &Curve25519PubKey,
) -> anyhow::Result<(Blind15ID, Blind15ID)> {
    let mut id1 = [0u8; 66];
    let mut id2 = [0u8; 66];
    let session_id = individual_id.as_str();
    let server_pk = server_public_key.hex();
    let r = unsafe {
        bindings::session_blind15_ids(
            session_id.as_ptr() as *const _,
            session_id.len(),
            server_pk.as_ptr() as *const _,
            server_pk.len(),
            id1.as_mut_ptr() as *mut _,
            id2.as_mut_ptr() as *mut _,
        )
    };

    ensure!(r, "Failed to generate blind 15 IDs");

    let id1 = std::str::from_utf8(id1.as_slice())?;
    let id2 = std::str::from_utf8(id2.as_slice())?;

    Ok((id1.parse()?, id2.parse()?))
}

pub fn blind15_key_pair(
    user_key: &ED25519SecKey,
    server_public_key: &Curve25519PubKey,
) -> anyhow::Result<(Blind15ID, [u8; 32])> {
    let mut pub_key = [0u8; 32];
    let mut sec_key = [0u8; 32];
    let r = unsafe {
        bindings::session_blind15_key_pair(
            user_key.as_ptr(),
            server_public_key.as_ptr(),
            pub_key.as_mut_ptr(),
            sec_key.as_mut_ptr(),
        )
    };

    ensure!(r, "Failed to generate blind 15 key pair");

    Ok((ED25519PubKey::from(pub_key).into(), sec_key))
}

pub fn blind25_id(
    individual_id: &IndividualID,
    server_public_key: &Curve25519PubKey,
) -> anyhow::Result<Blind25ID> {
    let mut id = [0u8; 66];
    let session_id = individual_id.as_str();
    let server_pk = server_public_key.hex();

    let r = unsafe {
        bindings::session_blind25_id(
            session_id.as_ptr() as *const _,
            session_id.len(),
            server_pk.as_ptr() as *const _,
            server_pk.len(),
            id.as_mut_ptr() as *mut _,
        )
    };

    ensure!(r, "Failed to generate blind 25 ID");

    let id = std::str::from_utf8(id.as_slice())?;

    Ok(id.parse()?)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{identity::Identity, key::curve25519::gen_pair, key::ed25519};

    #[test]
    fn blinded_ids_works() {
        let identity: Identity = Identity::new(ed25519::gen_pair());
        let (server_pub_key, _) = gen_pair();

        let (id1, id2) = blind15_ids(identity.individual_id(), &server_pub_key)
            .expect("To generate blinded IDs");

        println!("ID1 = {id1}, ID2 = {id2}");

        let id =
            blind25_id(identity.individual_id(), &server_pub_key).expect("To generate blinded ID");
        println!("ID = {id}");
    }
}
