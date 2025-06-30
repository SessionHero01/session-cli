use aes_gcm::{AeadInPlace, Aes256Gcm, Nonce, Tag};
use anyhow::{Context, anyhow};
use cipher::BlockDecryptMut;
use cipher::block_padding::Pkcs7;
use derive_more::Display;
use thiserror::Error;

#[derive(Error, Debug, Display)]
pub enum DecryptError {
    InvalidKey,
    Other(#[from] anyhow::Error),
}

pub trait FileDecryptor {
    fn max_plaintext_len(&self, ciphertext_len: usize) -> Result<usize, DecryptError>;
    fn decrypt(&self, input: &[u8], output: &mut [u8]) -> Result<usize, DecryptError>;
}

pub struct Aes256CbcHmacSha256Decryptor {
    pub aes_key: [u8; 32],
    pub hmac_key: [u8; 32],
}

pub struct Aes256GcmDecryptor {
    pub key: [u8; 32],
}

pub(super) const AES_256_IV_LEN: usize = 12;
pub(super) const HMAC_TAG_LEN: usize = 32;

impl FileDecryptor for Aes256CbcHmacSha256Decryptor {
    fn max_plaintext_len(&self, ciphertext_len: usize) -> Result<usize, DecryptError> {
        if ciphertext_len < AES_256_IV_LEN + HMAC_TAG_LEN {
            return Err(anyhow!(
                "Ciphertext too short, need at least {} but got {}",
                AES_256_IV_LEN + HMAC_TAG_LEN,
                ciphertext_len
            )
            .into());
        }

        Ok(ciphertext_len - AES_256_IV_LEN - HMAC_TAG_LEN)
    }

    fn decrypt(&self, input: &[u8], output: &mut [u8]) -> Result<usize, DecryptError> {
        if output.len() < self.max_plaintext_len(input.len())? {
            return Err(anyhow!("Output buffer too small").into());
        }

        let (iv_and_ciphertext, signature) = input.split_at(input.len() - HMAC_TAG_LEN);
        let (iv, ciphertext) = iv_and_ciphertext.split_at(AES_256_IV_LEN);

        // Verify the HMAC first
        use hmac::Mac;

        let mut hmac =
            hmac::Hmac::<sha2::Sha256>::new_from_slice(&self.hmac_key).context("Creating HMAC")?;

        hmac.update(iv_and_ciphertext);
        let expected_hmac = hmac.finalize().into_bytes();
        if expected_hmac.as_slice() != signature {
            return Err(DecryptError::InvalidKey);
        }

        // Decrypt the ciphertext
        use cipher::KeyIvInit;
        let crypter: cbc::Decryptor<aes::Aes256> =
            cbc::Decryptor::new_from_slices(&self.aes_key, iv).context("Creating decryptor")?;

        Ok(crypter
            .decrypt_padded_b2b_mut::<Pkcs7>(ciphertext, output)
            .map_err(|_| DecryptError::InvalidKey)?
            .len())
    }
}

pub(super) const AES_GCM_TAG_LEN: usize = 16;

impl FileDecryptor for Aes256GcmDecryptor {
    fn max_plaintext_len(&self, ciphertext_len: usize) -> Result<usize, DecryptError> {
        if ciphertext_len < AES_256_IV_LEN + AES_GCM_TAG_LEN {
            return Err(anyhow!(
                "Ciphertext too short, need at least {} but got {}",
                AES_256_IV_LEN + AES_GCM_TAG_LEN,
                ciphertext_len
            )
            .into());
        }

        Ok(ciphertext_len - AES_256_IV_LEN - AES_GCM_TAG_LEN)
    }

    fn decrypt(&self, input: &[u8], output: &mut [u8]) -> Result<usize, DecryptError> {
        let plaintext_len = self.max_plaintext_len(input.len())?;
        if output.len() < plaintext_len {
            return Err(anyhow!("Output buffer too small").into());
        }

        let (iv, ciphertext_and_tag) = input.split_at(AES_256_IV_LEN);
        let (ciphertext, tag) =
            ciphertext_and_tag.split_at(ciphertext_and_tag.len() - AES_GCM_TAG_LEN);

        let nonce = Nonce::from_slice(iv);

        use cipher::KeyInit;
        let gcm = Aes256Gcm::new_from_slice(&self.key).context("Creating GCM")?;

        // Copy ciphertext into output buffer
        (&mut output[..ciphertext.len()]).copy_from_slice(ciphertext);

        // Decrypt the ciphertext
        gcm.decrypt_in_place_detached(
            &nonce,
            b"",
            &mut output[..ciphertext.len()],
            &Tag::from_slice(tag),
        )
        .map_err(|_| DecryptError::InvalidKey)?;

        Ok(plaintext_len)
    }
}

pub fn decrypt_to(
    decryptor: &impl FileDecryptor,
    ciphertext: &[u8],
) -> Result<Vec<u8>, DecryptError> {
    let mut out = vec![0u8; decryptor.max_plaintext_len(ciphertext.len())?];

    let out_len = decryptor.decrypt(ciphertext, &mut out)?;
    out.truncate(out_len);

    Ok(out)
}
