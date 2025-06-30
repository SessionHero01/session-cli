use super::decrypt::{AES_256_IV_LEN, AES_GCM_TAG_LEN};
use aes_gcm::{AeadCore, AeadInPlace, Aes256Gcm};
use anyhow::{Context, format_err};
use cipher::KeyInit;
use rand::rngs::OsRng;
use std::io::Read;

pub struct EncryptResult {
    pub cipher: Vec<u8>,
    pub key: [u8; 32],
}

pub fn encrypt_aes_gcm(
    input: &mut impl Read,
    size_hint: Option<usize>,
) -> anyhow::Result<EncryptResult> {
    let mut output = match size_hint {
        Some(s) => Vec::with_capacity(s + AES_256_IV_LEN + AES_GCM_TAG_LEN),
        None => Default::default(),
    };

    let nonce = Aes256Gcm::generate_nonce(OsRng);
    assert_eq!(nonce.len(), AES_256_IV_LEN);
    output.extend_from_slice(nonce.as_slice());

    // Read all data from the input
    input
        .read_to_end(&mut output)
        .context("Error reading input")?;

    // Encrypt the data in place
    let key = Aes256Gcm::generate_key(OsRng);
    let gcm = Aes256Gcm::new(&key);

    let tag = gcm
        .encrypt_in_place_detached(&nonce, &[], &mut output[AES_256_IV_LEN..])
        .map_err(|s| format_err!("Error encrypting data: {s:?}"))?;

    assert_eq!(AES_GCM_TAG_LEN, tag.len());

    // Append the tag to the output
    output.extend_from_slice(tag.as_slice());

    Ok(EncryptResult {
        cipher: output,
        key: key.into(),
    })
}

#[cfg(test)]
mod tests {
    use super::super::decrypt::Aes256GcmDecryptor;
    use super::*;
    use crate::files::decrypt::FileDecryptor;
    use std::io::Cursor;

    #[test]
    fn encryption_works() {
        let plaintext = b"Hello, world!";
        let result = encrypt_aes_gcm(&mut Cursor::new(plaintext), None).expect("To encrypt");

        let decrypter = Aes256GcmDecryptor { key: result.key };

        let mut actual_plaintext =
            vec![0u8; decrypter.max_plaintext_len(result.cipher.len()).unwrap()];
        let decrypted_len = decrypter
            .decrypt(&result.cipher, &mut actual_plaintext)
            .expect("Decryption failed");
        actual_plaintext.truncate(decrypted_len);

        assert_eq!(actual_plaintext, plaintext);
    }
}
