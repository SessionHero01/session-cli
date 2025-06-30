use crate::key::curve25519::Curve25519PubKey;

pub struct FileServerPublicKey<'a> {
    pub host: &'a str,
    pub pub_key_hex: &'a str,
}

pub const FILE_SERVER_PUB_KEYS: &[FileServerPublicKey<'static>] = &[FileServerPublicKey {
    host: "filev2.getsession.org",
    pub_key_hex: "da21e1d886c6fbaea313f75298bd64aab03a97ce985b46bb2dad9f2089c8ee59",
}];

pub fn find_file_server_pub_key(host: &str) -> Option<Curve25519PubKey> {
    FILE_SERVER_PUB_KEYS
        .iter()
        .find(|key| key.host.eq_ignore_ascii_case(host))
        .map(|key| Curve25519PubKey::from_hex(key.pub_key_hex).expect("Valid public key"))
}
