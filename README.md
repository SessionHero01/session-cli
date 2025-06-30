This app is composed of two main parts:
* The web server that serves the HTTP API to the UI clients
* The Flutter UI client

## Dependencies for the web server
* [Rust](https://rustup.rs/)
* cmake, it must be present in your PATH
* A working C++ compiler that is detectable by cmake

## Dependencies for the Flutter UI client
* [Flutter](https://flutter.dev/)

## Quick start

### To start a web server

In the project root directory, run:
```bash
cargo run --bin session-cli -- run-global-server -l 127.0.0.1:4001 --data_dir DIRECTORY_TO_STORE_DATA
```

### To start the Flutter UI client

In the `flutter` directory, run:
```bash
flutter run
```