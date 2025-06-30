mod blind15;

use libsession_util_sys::session_blind25_id;
use rusqlite::functions::{Context, FunctionFlags};
use rusqlite::vtab::read_only_module;
use rusqlite::{ffi, Connection};
use std::ffi::{c_char, c_int};

#[no_mangle]
pub unsafe extern "C" fn sqlite3_extension_init(
    db: *mut ffi::sqlite3,
    pz_err_msg: *mut *mut c_char,
    p_api: *mut ffi::sqlite3_api_routines,
) -> c_int {
    Connection::extension_init2(db, pz_err_msg, p_api, |c| extension_init(&c))
}

pub fn extension_init(db: &Connection) -> rusqlite::Result<bool> {
    db.create_module(
        "blind15_ids",
        read_only_module::<blind15::Blind15Tab>(),
        None,
    )?;

    db.create_scalar_function(
        "blind25_id",
        2,
        FunctionFlags::SQLITE_DETERMINISTIC,
        blind25_id,
    )?;

    Ok(true)
}

fn blind25_id(ctx: &Context) -> rusqlite::Result<Option<String>> {
    let session_id = ctx.get::<String>(0)?;
    let server_pk = ctx.get::<String>(1)?;

    let mut id_out = vec![0u8; 66];

    let result = unsafe {
        session_blind25_id(
            session_id.as_ptr() as *const _,
            session_id.len(),
            server_pk.as_ptr() as *const _,
            server_pk.len(),
            id_out.as_mut_ptr() as *mut _,
        )
    };

    if !result {
        Ok(None)
    } else {
        Ok(Some(String::from_utf8(id_out).map_err(|e| e.utf8_error())?))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn blind15_ids_works() {
        let db = Connection::open_in_memory().unwrap();
        extension_init(&db).unwrap();

        let mut stmt = db.prepare("SELECT * FROM blind15_ids").unwrap();
        let mut rows = stmt.query([]).unwrap();

        let row = rows.next().unwrap().unwrap();
        let id1: String = row.get(0).unwrap();
        let id2: String = row.get(1).unwrap();

        assert_eq!(id1.len(), 65);
        assert_eq!(id2.len(), 65);
    }
}
