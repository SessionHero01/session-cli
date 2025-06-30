//
//  Generated code. Do not modify.
//  source: protos/network_status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getNetworkStatusRequestDescriptor instead')
const GetNetworkStatusRequest$json = {
  '1': 'GetNetworkStatusRequest',
};

/// Descriptor for `GetNetworkStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNetworkStatusRequestDescriptor = $convert.base64Decode(
    'ChdHZXROZXR3b3JrU3RhdHVzUmVxdWVzdA==');

@$core.Deprecated('Use networkPathDescriptor instead')
const NetworkPath$json = {
  '1': 'NetworkPath',
  '2': [
    {'1': 'ipv4_addresses', '3': 1, '4': 3, '5': 9, '10': 'ipv4Addresses'},
  ],
};

/// Descriptor for `NetworkPath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkPathDescriptor = $convert.base64Decode(
    'CgtOZXR3b3JrUGF0aBIlCg5pcHY0X2FkZHJlc3NlcxgBIAMoCVINaXB2NEFkZHJlc3Nlcw==');

@$core.Deprecated('Use getNetworkStatusResponseDescriptor instead')
const GetNetworkStatusResponse$json = {
  '1': 'GetNetworkStatusResponse',
  '2': [
    {'1': 'idle', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'idle'},
    {'1': 'connecting', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'connecting'},
    {'1': 'connected', '3': 3, '4': 1, '5': 11, '6': '.SessionApp.NetworkPath', '9': 0, '10': 'connected'},
    {'1': 'error', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'state'},
  ],
};

/// Descriptor for `GetNetworkStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNetworkStatusResponseDescriptor = $convert.base64Decode(
    'ChhHZXROZXR3b3JrU3RhdHVzUmVzcG9uc2USLAoEaWRsZRgBIAEoCzIWLmdvb2dsZS5wcm90b2'
    'J1Zi5FbXB0eUgAUgRpZGxlEjgKCmNvbm5lY3RpbmcYAiABKAsyFi5nb29nbGUucHJvdG9idWYu'
    'RW1wdHlIAFIKY29ubmVjdGluZxI3Cgljb25uZWN0ZWQYAyABKAsyFy5TZXNzaW9uQXBwLk5ldH'
    'dvcmtQYXRoSABSCWNvbm5lY3RlZBIWCgVlcnJvchgEIAEoCUgAUgVlcnJvckIHCgVzdGF0ZQ==');

