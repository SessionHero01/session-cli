//
//  Generated code. Do not modify.
//  source: protos/avatar.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use avatarDescriptor instead')
const Avatar$json = {
  '1': 'Avatar',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.SessionApp.EncryptedFile', '9': 0, '10': 'image'},
    {'1': 'community_image', '3': 2, '4': 1, '5': 11, '6': '.SessionApp.CommunityFile', '9': 0, '10': 'communityImage'},
    {'1': 'empty', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'empty'},
    {'1': 'is_moderator', '3': 4, '4': 1, '5': 8, '10': 'isModerator'},
    {'1': 'fallback_text', '3': 11, '4': 1, '5': 9, '10': 'fallbackText'},
  ],
  '8': [
    {'1': 'Image'},
  ],
};

/// Descriptor for `Avatar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List avatarDescriptor = $convert.base64Decode(
    'CgZBdmF0YXISMQoFaW1hZ2UYASABKAsyGS5TZXNzaW9uQXBwLkVuY3J5cHRlZEZpbGVIAFIFaW'
    '1hZ2USRAoPY29tbXVuaXR5X2ltYWdlGAIgASgLMhkuU2Vzc2lvbkFwcC5Db21tdW5pdHlGaWxl'
    'SABSDmNvbW11bml0eUltYWdlEi4KBWVtcHR5GAMgASgLMhYuZ29vZ2xlLnByb3RvYnVmLkVtcH'
    'R5SABSBWVtcHR5EiEKDGlzX21vZGVyYXRvchgEIAEoCFILaXNNb2RlcmF0b3ISIwoNZmFsbGJh'
    'Y2tfdGV4dBgLIAEoCVIMZmFsbGJhY2tUZXh0QgcKBUltYWdl');

@$core.Deprecated('Use groupMemberAvatarListDescriptor instead')
const GroupMemberAvatarList$json = {
  '1': 'GroupMemberAvatarList',
  '2': [
    {'1': 'avatars', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.Avatar', '10': 'avatars'},
  ],
};

/// Descriptor for `GroupMemberAvatarList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberAvatarListDescriptor = $convert.base64Decode(
    'ChVHcm91cE1lbWJlckF2YXRhckxpc3QSLAoHYXZhdGFycxgBIAMoCzISLlNlc3Npb25BcHAuQX'
    'ZhdGFyUgdhdmF0YXJz');

