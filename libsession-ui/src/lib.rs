#![recursion_limit = "256"]

extern crate core;

mod ffi {
    use anyhow::Context;
    use session_ui_core::create_global_service;
    use std::ffi::c_void;
    use std::net::SocketAddr;
    use std::path::PathBuf;
    use std::sync::OnceLock;
    use std::sync::atomic::{AtomicBool, Ordering};
    use tokio::runtime::{Builder, Runtime};
    use tokio::task::JoinSet;

    struct GlobalServiceState {
        _runtime: Runtime,
        _join_set: JoinSet<std::io::Result<()>>,
        listen: SocketAddr,
    }

    static INITIALISED_TRACING: AtomicBool = AtomicBool::new(false);

    impl GlobalServiceState {
        fn new(
            _psk_data: *const u8,
            _psk_data_len: usize,
            data_dir: *const u8,
            data_dir_len: usize,
        ) -> anyhow::Result<Self> {
            if !INITIALISED_TRACING.swap(true, Ordering::Acquire) {
                #[cfg(target_os = "android")]
                paranoid_android::init(env!("CARGO_PKG_NAME"));

                let subscriber = tracing_subscriber::fmt()
                    .with_ansi(cfg!(not(target_os = "android")))
                    // Use a more compact, abbreviated log format
                    .compact()
                    // Display source code file paths
                    .with_file(true)
                    // Display source code line numbers
                    .with_line_number(true)
                    // Display the thread ID an event was recorded on
                    .with_thread_ids(true)
                    // Don't display the event's target (module path)
                    .with_target(false)
                    // Build the subscriber
                    .finish();

                let _ = tracing::subscriber::set_global_default(subscriber);
            }

            let runtime = Builder::new_multi_thread()
                .worker_threads(2)
                .enable_all()
                .build()
                .context("Error init tokio runtime")?;
            let _guard = runtime.enter();

            let data_dir =
                std::str::from_utf8(unsafe { std::slice::from_raw_parts(data_dir, data_dir_len) })
                    .context("Error converting data directory to string")?;

            let data_dir = PathBuf::from(data_dir);

            tracing::info!("Creating data file directory: {}", data_dir.display());

            let (join_set, addr) = create_global_service(&[], "127.0.0.1:0", data_dir)?;
            Ok(GlobalServiceState {
                _runtime: runtime,
                listen: addr,
                _join_set: join_set,
            })
        }
    }

    fn write_error(e: &anyhow::Error, out: *mut u8, out_len: usize) {
        if out != std::ptr::null_mut() && out_len > 0 {
            let msg = e.to_string();
            let len = std::cmp::min(msg.len(), out_len);
            let err_buf = unsafe { std::slice::from_raw_parts_mut(out, out_len) };
            (&mut err_buf[..len]).copy_from_slice(&msg.as_bytes()[..len]);
            // Make sure the buffer is null-terminated
            err_buf[out_len - 1] = 0;
        }
    }

    static SHARED_INSTANCE: OnceLock<anyhow::Result<GlobalServiceState>> = OnceLock::new();

    #[unsafe(no_mangle)]
    extern "C" fn global_service_shared_get_port(
        _psk_data: *const u8,
        _psk_data_len: usize,
        data_dir: *const u8,
        data_dir_len: usize,
        err_buf: *mut u8,
        err_buf_len: usize,
    ) -> u16 {
        let shared = SHARED_INSTANCE.get_or_init(|| {
            GlobalServiceState::new(_psk_data, _psk_data_len, data_dir, data_dir_len)
        });

        match shared {
            Ok(state) => state.listen.port(),
            Err(e) => {
                write_error(e, err_buf, err_buf_len);
                0
            }
        }
    }

    #[unsafe(no_mangle)]
    extern "C" fn global_service_create(
        psk_data: *const u8,
        psk_data_len: usize,
        data_dir: *const u8,
        data_dir_len: usize,
        err_buf: *mut u8,
        err_buf_len: usize,
    ) -> *const c_void {
        match GlobalServiceState::new(psk_data, psk_data_len, data_dir, data_dir_len) {
            Ok(state) => unsafe { std::mem::transmute(Box::leak(Box::new(state))) },
            Err(e) => {
                write_error(&e, err_buf, err_buf_len);
                std::ptr::null()
            }
        }
    }

    #[unsafe(no_mangle)]
    extern "C" fn global_service_get_port(ptr: *const c_void) -> u16 {
        let state: &GlobalServiceState = unsafe { std::mem::transmute(ptr) };
        state.listen.port()
    }

    #[unsafe(no_mangle)]
    extern "C" fn global_service_destroy(ptr: *const c_void) {
        let _instance = unsafe { Box::<GlobalServiceState>::from_raw(ptr as *mut _) };
    }
}
