use std::env;
use std::path::PathBuf;

fn main() {
    let src_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    let proto_out = out_path.join("protos");
    std::fs::create_dir_all(&proto_out).unwrap();
    let workspace_root = src_dir.parent().unwrap();
    let proto_files = [
        "protos/session_service.proto",
        "protos/session_websocket_resource.proto",
        "protos/accounts.proto",
        "protos/app.proto",
        "protos/avatar.proto",
        "protos/conversation.proto",
        "protos/conversation_list.proto",
        "protos/message.proto",
        "protos/control_messages.proto",
        "protos/network_status.proto",
        "protos/contact.proto",
        "protos/file.proto",
    ]
    .map(|s| workspace_root.join(s));

    let descriptor_path = proto_out.join("descriptor.bin");

    prost_build::Config::new()
        .compile_well_known_types()
        .out_dir(&proto_out)
        .file_descriptor_set_path(&descriptor_path)
        .protoc_executable(protoc_bin_vendored::protoc_bin_path().expect("protoc not found"))
        .compile_protos(proto_files.as_slice(), &[workspace_root])
        .unwrap();

    pbjson_build::Builder::new()
        .register_descriptors(&std::fs::read(&descriptor_path).unwrap())
        .unwrap()
        .out_dir(&proto_out)
        .build(&[
            ".google",
            ".SessionApp",
            ".SessionProtos",
            ".WebSocketProtos",
        ])
        .unwrap();

    // Tell cargo to track the proto files
    for proto_file in proto_files {
        println!("cargo:rerun-if-changed={}", proto_file.display());
    }
}
