//
//  Generated code. Do not modify.
//  source: protos/session_websocket_resource.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use webSocketRequestMessageDescriptor instead')
const WebSocketRequestMessage$json = {
  '1': 'WebSocketRequestMessage',
  '2': [
    {'1': 'verb', '3': 1, '4': 1, '5': 9, '10': 'verb'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'body', '3': 3, '4': 1, '5': 12, '10': 'body'},
    {'1': 'headers', '3': 5, '4': 3, '5': 9, '10': 'headers'},
    {'1': 'id', '3': 4, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `WebSocketRequestMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webSocketRequestMessageDescriptor = $convert.base64Decode(
    'ChdXZWJTb2NrZXRSZXF1ZXN0TWVzc2FnZRISCgR2ZXJiGAEgASgJUgR2ZXJiEhIKBHBhdGgYAi'
    'ABKAlSBHBhdGgSEgoEYm9keRgDIAEoDFIEYm9keRIYCgdoZWFkZXJzGAUgAygJUgdoZWFkZXJz'
    'Eg4KAmlkGAQgASgEUgJpZA==');

@$core.Deprecated('Use webSocketResponseMessageDescriptor instead')
const WebSocketResponseMessage$json = {
  '1': 'WebSocketResponseMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'status', '3': 2, '4': 1, '5': 13, '10': 'status'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'headers', '3': 5, '4': 3, '5': 9, '10': 'headers'},
    {'1': 'body', '3': 4, '4': 1, '5': 12, '10': 'body'},
  ],
};

/// Descriptor for `WebSocketResponseMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webSocketResponseMessageDescriptor = $convert.base64Decode(
    'ChhXZWJTb2NrZXRSZXNwb25zZU1lc3NhZ2USDgoCaWQYASABKARSAmlkEhYKBnN0YXR1cxgCIA'
    'EoDVIGc3RhdHVzEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2USGAoHaGVhZGVycxgFIAMoCVIH'
    'aGVhZGVycxISCgRib2R5GAQgASgMUgRib2R5');

@$core.Deprecated('Use webSocketMessageDescriptor instead')
const WebSocketMessage$json = {
  '1': 'WebSocketMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.WebSocketProtos.WebSocketMessage.Type', '10': 'type'},
    {'1': 'request', '3': 2, '4': 1, '5': 11, '6': '.WebSocketProtos.WebSocketRequestMessage', '10': 'request'},
    {'1': 'response', '3': 3, '4': 1, '5': 11, '6': '.WebSocketProtos.WebSocketResponseMessage', '10': 'response'},
  ],
  '4': [WebSocketMessage_Type$json],
};

@$core.Deprecated('Use webSocketMessageDescriptor instead')
const WebSocketMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'REQUEST', '2': 1},
    {'1': 'RESPONSE', '2': 2},
  ],
};

/// Descriptor for `WebSocketMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webSocketMessageDescriptor = $convert.base64Decode(
    'ChBXZWJTb2NrZXRNZXNzYWdlEjoKBHR5cGUYASABKA4yJi5XZWJTb2NrZXRQcm90b3MuV2ViU2'
    '9ja2V0TWVzc2FnZS5UeXBlUgR0eXBlEkIKB3JlcXVlc3QYAiABKAsyKC5XZWJTb2NrZXRQcm90'
    'b3MuV2ViU29ja2V0UmVxdWVzdE1lc3NhZ2VSB3JlcXVlc3QSRQoIcmVzcG9uc2UYAyABKAsyKS'
    '5XZWJTb2NrZXRQcm90b3MuV2ViU29ja2V0UmVzcG9uc2VNZXNzYWdlUghyZXNwb25zZSIuCgRU'
    'eXBlEgsKB1VOS05PV04QABILCgdSRVFVRVNUEAESDAoIUkVTUE9OU0UQAg==');

