
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';

typedef ResponseFactory<Res> = Res Function(List<int> data);

enum HttpSendMethod { post, put, delete, patch }

mixin HttpServiceMixin {
  final _client = http.Client();

  Future<void> _checkResponse(http.StreamedResponse resp) async {
    if (resp.statusCode != 200) {
      final statusCode = resp.statusCode;
      final message = (await http.Response.fromStream(resp)).body;
      throw Exception(
          'Failed to perform HTTP request: $statusCode, message=$message');
    }

    final contentType = resp.headers['content-type'];

    if (contentType != 'application/protobuf') {
      throw Exception('Invalid content type: $contentType');
    }
  }

  Future<Res> httpGet<Res extends GeneratedMessage>(
      Uri uri, String? password, ResponseFactory<Res> factory) async {
    final request = http.Request('get', uri)
      ..headers['Accept'] = 'application/protobuf'
      ..headers['Authorization'] = password ?? '';
    final rawResponse = await _client.send(request);
    await _checkResponse(rawResponse);

    final resp = await http.Response.fromStream(rawResponse);
    return factory(resp.bodyBytes);
  }

  Future<Res> httpSend<Req extends GeneratedMessage, Res>(
      Uri uri,
      String? password,
      HttpSendMethod method,
      Req req,
      ResponseFactory<Res> factory) async {
    final rawResponse = await _client.send(http.Request(method.name, uri)
      ..headers['Content-Type'] = 'application/protobuf'
      ..headers['Accept'] = 'application/protobuf'
      ..headers['Authorization'] = password ?? ''
      ..bodyBytes = req.writeToBuffer());

    await _checkResponse(rawResponse);

    final resp = await http.Response.fromStream(rawResponse);
    return factory(resp.bodyBytes);
  }

  Stream<Res> performHttpGetStreaming<Res>(
      Uri uri, String? password, ResponseFactory<Res> factory) async* {
    while (true) {
      try {
        final req = http.Request('get', uri)
          ..headers['Accept'] = 'application/protobuf'
          ..headers['Authorization'] = password ?? '';

        final resp = await _client.send(req);

        await _checkResponse(resp);

        final handler = _ChunkedHandler();
        if (resp.headers['transfer-encoding'] == 'chunked') {
          await for (final chunk in resp.stream) {
            final chunks = handler.push(chunk);
            for (final chunk in chunks) {
              yield factory(chunk);
            }
          }
        } else {
          throw Exception(
              'Invalid transfer encoding. Only chunked is supported');
        }
      } catch (e) {
        print('Error: $e');
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
}

class _ChunkedHandler {
  List<int> _buffer = [];
  int? _expectingLength;

  List<List<int>> push(List<int> data) {
    if (_buffer.isEmpty) {
      _buffer = data.toList();
    } else {
      _buffer.addAll(data);
    }

    // Find all complete chunks in _buffer
    final chunks = <List<int>>[];
    List<int>? chunk;
    while ((chunk = findNextChunk()) != null) {
      chunks.add(chunk!);
    }

    return chunks;
  }

  List<int>? findNextChunk() {
    // Go through _buffer, convert the bytes before first \r\n to int, use that
    // as the length of data, continue going through _buffer until we find \r\n,
    // then make sure the data is of the length we found earlier, if so, return
    // the data, otherwise return null.

    for (int i = 0; i < _buffer.length - 1; i++) {
      if (_buffer[i] == 13 && _buffer[i + 1] == 10) {
        // \r\n
        if (_expectingLength == null) {
          // Convert bytes before \r\n to int
          var chunkLenStr = String.fromCharCodes(_buffer.sublist(0, i));
          _expectingLength = int.tryParse(chunkLenStr, radix: 16);
          if (_expectingLength == null) {
            throw Exception('Invalid chunk length: $chunkLenStr');
          }
          _buffer = _buffer.sublist(i + 2); // Remove length and \r\n
          i = -1; // Reset loop to start
        } else {
          // Check if the data length matches the length found earlier
          if (_buffer.length >= _expectingLength! + 2 &&
              _buffer[_expectingLength!] == 13 &&
              _buffer[_expectingLength! + 1] == 10) {
            final chunk = _buffer.sublist(0, _expectingLength!);
            _buffer =
                _buffer.sublist(_expectingLength! + 2); // Remove chunk and \r\n
            _expectingLength = null;
            return chunk;
          } else {
            return null; // Data length mismatch
          }
        }
      }
    }
    return null; // No complete chunk found
  }
}
