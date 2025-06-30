#[allow(
    dead_code,
    non_snake_case,
    non_camel_case_types,
    unused_variables,
    non_upper_case_globals,
    improper_ctypes
)]
mod bindings {
    include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
}

// #[cfg(not(target_os = "android"))]
extern crate link_cplusplus;

pub use bindings::*;
