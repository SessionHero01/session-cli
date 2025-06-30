use std::collections::HashSet;
use std::env;
use std::path::{Path, PathBuf};

struct CMakeLib {
    search_path: String,
    lib_name: &'static str,
}

impl CMakeLib {
    pub fn new(search_path: &str, lib_name: &'static str) -> Self {
        Self {
            search_path: search_path.to_string(),
            lib_name,
        }
    }
}

fn main() {
    let src_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let build_target = env::var("TARGET").unwrap();
    let mut config = cmake::Config::new(&src_dir);

    let out_dir = src_dir
        .join(format!("cmake-rust-build-{}", env::var("PROFILE").unwrap()))
        .join(build_target);
    let build_dir = out_dir.join("build");

    match env::var("CARGO_CFG_TARGET_OS")
        .as_ref()
        .map(|s| s.as_str())
        .unwrap()
    {
        "ios" => {
            let platform = match (
                env::var("CARGO_CFG_TARGET_ABI")
                    .as_ref()
                    .map(String::as_str)
                    .unwrap(),
                env::var("CARGO_CFG_TARGET_ARCH")
                    .as_ref()
                    .map(String::as_str)
                    .unwrap(),
            ) {
                ("sim", "aarch64") => "SIMULATORARM64",
                ("sim", "x86_64") => "SIMULATOR64",
                ("", "aarch64") => "OS64",
                (abi, arch) => panic!("Unknown iOS ABI: {abi} and ARCH: {arch}"),
            };

            config
                .define(
                    "CMAKE_TOOLCHAIN_FILE",
                    src_dir
                        .join("libsession-util/external/ios-cmake/ios.toolchain.cmake")
                        .to_str()
                        .unwrap(),
                )
                .define("PLATFORM", platform)
                .define("DEPLOYMENT_TARGET", "13")
                .define("ENABLE_BITCODE", "OFF")
                .define("ENABLE_VISIBILITY", "ON")
                .define("LOCAL_MIRROR", "https://oxen.rocks/deps");
        }

        "macos" => {
            let arch = match env::var("CARGO_CFG_TARGET_ARCH").unwrap().as_str() {
                "aarch64" => "arm64",
                "x86_64" => "x86_64",
                s => panic!("Unsupported macOS architecture: {s}"),
            };
            config
                .define("CMAKE_SYSTEM_NAME", "Darwin")
                .define("ARCH_TRIPLET", format!("{arch}-apple-darwin16"))
                .define("CMAKE_OSX_ARCHITECTURES", arch);
        }

        "android" => {
            let ndk_dir = env::var("ANDROID_NDK_HOME").expect("ANDROID_NDK_HOME not set");

            let abi =
                env::var("CARGO_NDK_ANDROID_TARGET").expect("CARGO_NDK_ANDROID_TARGET not set");
            let api =
                env::var("CARGO_NDK_ANDROID_PLATFORM").expect("CARGO_NDK_ANDROID_PLATFORM not set");

            let sysroot_libs_path =
                PathBuf::from(env::var_os("CARGO_NDK_SYSROOT_LIBS_PATH").unwrap());

            if let Ok(output_path) = env::var("CARGO_NDK_OUTPUT_PATH") {
                let lib_path = sysroot_libs_path.join("libc++_shared.so");
                let dest_file = Path::new(&output_path).join(&abi).join("libc++_shared.so");
                std::fs::create_dir_all(dest_file.parent().unwrap()).unwrap();
                std::fs::copy(lib_path, dest_file).unwrap();
            }

            // // Must tell rust where to find the final linking
            // println!(
            //     "cargo:rustc-link-search=native={}",
            //     sysroot_libs_path.display()
            // );
            //
            // println!("cargo:rustc-link-lib=static=c++_static");
            println!("cargo:rustc-link-lib=unwind");

            // Tell cmake where to find compiler_rt.builtins.a
            let clang_rt_builtin = glob::glob(&format!(
                "{ndk_dir}/toolchains/llvm/prebuilt/*/lib/clang/*/lib/linux",
            ))
            .unwrap()
            .next()
            .expect("Unable to find libclang_rt.builtins.a")
            .unwrap();

            let builtin_arch = match abi.as_str() {
                "armeabi-v7a" => "arm",
                "arm64-v8a" => "aarch64",
                "x86" => "i686",
                "x86_64" => "x86_64",
                _ => panic!("Unknown ABI: {}", abi),
            };

            println!(
                "cargo:rustc-link-search=native={}",
                clang_rt_builtin.display()
            );
            println!("cargo:rustc-link-lib=static=clang_rt.builtins-{builtin_arch}-android",);

            config
                .define(
                    "CMAKE_TOOLCHAIN_FILE",
                    format!("{ndk_dir}/build/cmake/android.toolchain.cmake"),
                )
                .define("ANDROID_ABI", abi)
                .define("ANDROID_STL", "c++_shared")
                .define("ANDROID_PLATFORM", format!("android-{api}"));
        }

        _ => {}
    }

    config
        .define(
            "ENABLE_QUIC_NETWORKING",
            env::var("CARGO_FEATURE_QUIC").ok().map_or("OFF", |_| "ON"),
        )
        .define("STATIC_BUNDLE", "ON")
        .define("BUILD_STATIC_DEPS", "ON")
        .define("BUILD_SHARED_LIBS", "OFF")
        .define("STATIC_LIBSTD", "ON")
        .define("SPDLOG_BUILD_PIC", "ON")
        .define("WITH_TESTS", "OFF")
        .define("USE_LTO", "OFF")
        .define("OXEN_LOGGING_FMT_HEADER_ONLY", "ON")
        .define("OXEN_LOGGING_SPDLOG_HEADER_ONLY", "ON")
        .define("OXEN_LOGGING_FORCE_SUBMODULES", "ON")
        .define("CFLAGS", "-std=gnu17")
        .define("LOCAL_MIRROR", "https://oxen.rocks/deps")
        .env("CMAKE_BUILD_PARALLEL_LEVEL", "4")
        .always_configure(true)
        .out_dir(&out_dir)
        .build_target("session-native-bundle")
        .build();

    let cmake_libraries = &[
        CMakeLib::new("libsession-util-ext", "session-util-ext"),
        CMakeLib::new("libsession-util", "session-util"),
    ];

    // Tell Cargo where to search for our libraries
    let search_paths = cmake_libraries
        .iter()
        .map(|lib| build_dir.join(&lib.search_path))
        .collect::<HashSet<_>>();

    for path in search_paths {
        println!("cargo:rustc-link-search=native={}", path.display());
    }

    // Tell cargo what libraries we are linking against
    for lib in cmake_libraries.iter().map(|lib| lib.lib_name) {
        println!("cargo:rustc-link-lib=static={lib}");
    }

    let mut builder = bindgen::Builder::default().wrap_unsafe_ops(true);

    if let Ok(sysroot) = env::var("CARGO_NDK_SYSROOT_PATH") {
        builder = builder.clang_arg(format!("--sysroot={sysroot}"));
    }

    if env::var("CARGO_FEATURE_QUIC").is_ok() {
        builder = builder.header("session-quic.h");
    }

    let bindings = builder
        .detect_include_paths(true)
        .clang_arg("-Ilibsession-util/include")
        // The input header we would like to generate
        // bindings for.
        .header("session.h")
        .derive_eq(true)
        // Tell cargo to invalidate the built crate whenever any of the
        // included header files changed.
        .parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
        // Finish the builder and generate the bindings.
        .generate()
        // Unwrap the Result and panic on failure.
        .expect("Unable to generate bindings");

    // Write the bindings to the $OUT_DIR/bindings.rs file.
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
