//
//  Generated code. Do not modify.
//  source: protos/control_messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use controlMessageDescriptor instead')
const ControlMessage$json = {
  '1': 'ControlMessage',
  '2': [
    {'1': 'message_approval_from_me', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'messageApprovalFromMe'},
    {'1': 'screenshot_taken_from_me', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'screenshotTakenFromMe'},
    {'1': 'media_saved_from_me', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'mediaSavedFromMe'},
  ],
  '8': [
    {'1': 'content'},
  ],
};

/// Descriptor for `ControlMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List controlMessageDescriptor = $convert.base64Decode(
    'Cg5Db250cm9sTWVzc2FnZRI5ChhtZXNzYWdlX2FwcHJvdmFsX2Zyb21fbWUYAiABKAhIAFIVbW'
    'Vzc2FnZUFwcHJvdmFsRnJvbU1lEjkKGHNjcmVlbnNob3RfdGFrZW5fZnJvbV9tZRgDIAEoCEgA'
    'UhVzY3JlZW5zaG90VGFrZW5Gcm9tTWUSLwoTbWVkaWFfc2F2ZWRfZnJvbV9tZRgEIAEoCEgAUh'
    'BtZWRpYVNhdmVkRnJvbU1lQgkKB2NvbnRlbnQ=');

