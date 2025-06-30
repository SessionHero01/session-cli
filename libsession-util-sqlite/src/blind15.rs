use libsession_util_sys::session_blind15_ids;
use rusqlite::ffi::sqlite3_vtab;
use rusqlite::types::Null;
use rusqlite::vtab::{
    parameter, Context, CreateVTab, IndexInfo, VTab, VTabConnection, VTabCursor, VTabKind, Values,
};
use rusqlite::Error::ModuleError;

#[repr(C)]
pub(super) struct Blind15Tab {
    base: sqlite3_vtab,
    session_id: String,
    server_pk: String,
}

pub struct Blind15TabCursor {
    ids: Option<[String; 2]>,
    offset: usize,
}

unsafe impl<'v> VTab<'v> for Blind15Tab {
    type Aux = ();
    type Cursor = Blind15TabCursor;

    fn connect(
        _db: &mut VTabConnection,
        _aux: Option<&Self::Aux>,
        args: &[&[u8]],
    ) -> rusqlite::Result<(String, Self)> {
        if args.len() != 2 {
            return Err(ModuleError(format!(
                "Expected 2 arguments, got {}",
                args.len()
            )));
        }

        let mut session_id = None;
        let mut server_pk = None;

        for c_slice in args {
            match parameter(c_slice)? {
                ("session_id", value) => session_id = Some(value.to_string()),
                ("server_pk", value) => server_pk = Some(value.to_string()),
                (name, _) => return Err(ModuleError(format!("Unknown parameter: {}", name))),
            }
        }

        let session_id = session_id.ok_or_else(|| ModuleError("Missing session_id".to_string()))?;
        let server_pk = server_pk.ok_or_else(|| ModuleError("Missing server_pk".to_string()))?;

        Ok((
            "CREATE TABLE x(blind15_id TEXT)".to_string(),
            Self {
                base: Default::default(),
                session_id,
                server_pk,
            },
        ))
    }

    fn best_index(&self, info: &mut IndexInfo) -> rusqlite::Result<()> {
        info.set_estimated_cost(1_000_000.0);
        Ok(())
    }

    fn open(&'v mut self) -> rusqlite::Result<Self::Cursor> {
        let mut id1_out = [0u8; 66];
        let mut id2_out = [0u8; 66];

        let result = unsafe {
            session_blind15_ids(
                self.session_id.as_ptr() as *const _,
                self.session_id.len(),
                self.server_pk.as_ptr() as *const _,
                self.server_pk.len(),
                id1_out.as_mut_ptr() as *mut _,
                id2_out.as_mut_ptr() as *mut _,
            )
        };

        if result {
            let id1 = std::str::from_utf8(id1_out.as_slice())?;
            let id2 = std::str::from_utf8(id2_out.as_slice())?;
            Ok(Blind15TabCursor {
                ids: Some([id1.to_string(), id2.to_string()]),
                offset: 0,
            })
        } else {
            Ok(Blind15TabCursor {
                ids: None,
                offset: 0,
            })
        }
    }
}

impl<'vtab> CreateVTab<'vtab> for Blind15Tab {
    const KIND: VTabKind = VTabKind::Eponymous;
}

unsafe impl VTabCursor for Blind15TabCursor {
    fn filter(
        &mut self,
        _idx_num: std::os::raw::c_int,
        _idx_str: Option<&str>,
        _args: &Values<'_>,
    ) -> rusqlite::Result<()> {
        self.offset = 0;
        Ok(())
    }

    fn next(&mut self) -> rusqlite::Result<()> {
        todo!()
    }

    fn eof(&self) -> bool {
        if let Some(ids) = self.ids.as_ref() {
            self.offset >= ids.len()
        } else {
            true
        }
    }

    fn column(&self, ctx: &mut Context, i: std::os::raw::c_int) -> rusqlite::Result<()> {
        if i < 0 || i >= 2 {
            return Err(ModuleError(format!("Invalid column index: {}", i)));
        }

        if let Some(id) = self.ids.as_ref().and_then(|ids| ids.get(i as usize)) {
            ctx.set_result(id)?;
        } else {
            ctx.set_result(&Null)?;
        }

        Ok(())
    }

    fn rowid(&self) -> rusqlite::Result<i64> {
        Ok(self.offset as i64)
    }
}
