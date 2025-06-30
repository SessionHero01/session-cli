//
//  Generated code. Do not modify.
//  source: protos/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use encryptedFileDescriptor instead')
const EncryptedFile$json = {
  '1': 'EncryptedFile',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'key', '3': 2, '4': 2, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `EncryptedFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encryptedFileDescriptor = $convert.base64Decode(
    'Cg1FbmNyeXB0ZWRGaWxlEhAKA3VybBgBIAIoCVIDdXJsEhAKA2tleRgCIAIoCVIDa2V5');

@$core.Deprecated('Use communityFileDescriptor instead')
const CommunityFile$json = {
  '1': 'CommunityFile',
  '2': [
    {'1': 'community_url', '3': 1, '4': 2, '5': 9, '10': 'communityUrl'},
    {'1': 'community_file_id', '3': 2, '4': 2, '5': 3, '10': 'communityFileId'},
  ],
};

/// Descriptor for `CommunityFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityFileDescriptor = $convert.base64Decode(
    'Cg1Db21tdW5pdHlGaWxlEiMKDWNvbW11bml0eV91cmwYASACKAlSDGNvbW11bml0eVVybBIqCh'
    'Fjb21tdW5pdHlfZmlsZV9pZBgCIAIoA1IPY29tbXVuaXR5RmlsZUlk');

@$core.Deprecated('Use trimFileCacheRequestDescriptor instead')
const TrimFileCacheRequest$json = {
  '1': 'TrimFileCacheRequest',
  '2': [
    {'1': 'keep_default', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'keepDefault'},
    {'1': 'keep_days', '3': 2, '4': 1, '5': 13, '9': 0, '10': 'keepDays'},
  ],
  '8': [
    {'1': 'keep'},
  ],
};

/// Descriptor for `TrimFileCacheRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trimFileCacheRequestDescriptor = $convert.base64Decode(
    'ChRUcmltRmlsZUNhY2hlUmVxdWVzdBI7CgxrZWVwX2RlZmF1bHQYASABKAsyFi5nb29nbGUucH'
    'JvdG9idWYuRW1wdHlIAFILa2VlcERlZmF1bHQSHQoJa2VlcF9kYXlzGAIgASgNSABSCGtlZXBE'
    'YXlzQgYKBGtlZXA=');

@$core.Deprecated('Use trimFileCacheResponseDescriptor instead')
const TrimFileCacheResponse$json = {
  '1': 'TrimFileCacheResponse',
  '2': [
    {'1': 'num_deleted', '3': 1, '4': 2, '5': 13, '10': 'numDeleted'},
  ],
};

/// Descriptor for `TrimFileCacheResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trimFileCacheResponseDescriptor = $convert.base64Decode(
    'ChVUcmltRmlsZUNhY2hlUmVzcG9uc2USHwoLbnVtX2RlbGV0ZWQYASACKA1SCm51bURlbGV0ZW'
    'Q=');

