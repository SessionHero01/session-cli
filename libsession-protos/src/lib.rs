pub mod google {
    pub mod protobuf {
        include!(concat!(env!("OUT_DIR"), "/protos/google.protobuf.rs"));
        include!(concat!(env!("OUT_DIR"), "/protos/google.protobuf.serde.rs"));
    }
}

pub mod protos {
    pub mod session {
        include!(concat!(env!("OUT_DIR"), "/protos/session_protos.rs"));
        include!(concat!(env!("OUT_DIR"), "/protos/session_protos.serde.rs"));
        include!(concat!(env!("OUT_DIR"), "/protos/web_socket_protos.rs"));
        include!(concat!(
            env!("OUT_DIR"),
            "/protos/web_socket_protos.serde.rs"
        ));
    }

    include!(concat!(env!("OUT_DIR"), "/protos/session_app.rs"));
    include!(concat!(env!("OUT_DIR"), "/protos/session_app.serde.rs"));
}
