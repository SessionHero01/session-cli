import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef GetGlobalServiceNativeFunc = ffi.Uint16 Function(
  ffi.Pointer<ffi.Uint8> pskData,
  ffi.Size pskDataLen,
  ffi.Pointer<ffi.Uint8> dataPathData,
  ffi.Size dataPathDataLen,
  ffi.Pointer<ffi.Uint8> errorData,
  ffi.Size errorDataLen,
);

typedef GetGlobalServiceFunc = int Function(
  ffi.Pointer<ffi.Uint8> pskData,
  int pskDataLen,
  ffi.Pointer<ffi.Uint8> dataPathData,
  int dataPathDataLen,
  ffi.Pointer<ffi.Uint8> errorData,
  int errorDataLen,
);

class SessionUiLibrary {
  late final GetGlobalServiceFunc _getGlobalServicePort;

  static final SessionUiLibrary instance = SessionUiLibrary._();

  SessionUiLibrary._() {
    final ffi.DynamicLibrary library;

    if (Platform.isWindows) {
      library = ffi.DynamicLibrary.open('session_ui.dll');
    } else if (Platform.isIOS || Platform.isMacOS) {
      library = ffi.DynamicLibrary.open('libsession_ui.dylib');
    } else {
      library = ffi.DynamicLibrary.open('libsession_ui.so');
    }

    _getGlobalServicePort = library
        .lookup<ffi.NativeFunction<GetGlobalServiceNativeFunc>>(
            'global_service_shared_get_port')
        .asFunction();
  }

  Uri getSharedGlobalServiceUri(String dataDirString) {
    final dataDir =
        dataDirString.toNativeUtf8(allocator: calloc).cast<ffi.Uint8>();

    // Allocate 512 bytes to store error messages
    const errorLen = 512;
    final errorData = calloc<ffi.Uint8>(errorLen);
    try {
      final port = _getGlobalServicePort(
        ffi.Pointer.fromAddress(0),
        0,
        dataDir,
        dataDirString.length,
        errorData,
        errorLen,
      );

      if (port == 0) {
        throw Exception(errorData.cast<Utf8>().toDartString());
      }

      return Uri.parse('http://127.0.0.1:$port');
    } finally {
      calloc.free(errorData);
      calloc.free(dataDir);
    }
  }
}
