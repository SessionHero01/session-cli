//
//  Generated code. Do not modify.
//  source: protos/accounts.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use listAccountsRequestDescriptor instead')
const ListAccountsRequest$json = {
  '1': 'ListAccountsRequest',
};

/// Descriptor for `ListAccountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QWNjb3VudHNSZXF1ZXN0');

@$core.Deprecated('Use listAccountsResponseDescriptor instead')
const ListAccountsResponse$json = {
  '1': 'ListAccountsResponse',
  '2': [
    {'1': 'accounts', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.ListAccountsResponse.Account', '10': 'accounts'},
  ],
  '3': [ListAccountsResponse_Account$json],
};

@$core.Deprecated('Use listAccountsResponseDescriptor instead')
const ListAccountsResponse_Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'session_id', '3': 1, '4': 2, '5': 9, '10': 'sessionId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'avatar_image', '3': 3, '4': 1, '5': 12, '10': 'avatarImage'},
  ],
};

/// Descriptor for `ListAccountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QWNjb3VudHNSZXNwb25zZRJECghhY2NvdW50cxgBIAMoCzIoLlNlc3Npb25BcHAuTG'
    'lzdEFjY291bnRzUmVzcG9uc2UuQWNjb3VudFIIYWNjb3VudHMaXwoHQWNjb3VudBIdCgpzZXNz'
    'aW9uX2lkGAEgAigJUglzZXNzaW9uSWQSEgoEbmFtZRgCIAIoCVIEbmFtZRIhCgxhdmF0YXJfaW'
    '1hZ2UYAyABKAxSC2F2YXRhckltYWdl');

@$core.Deprecated('Use loggedInResponseDescriptor instead')
const LoggedInResponse$json = {
  '1': 'LoggedInResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 2, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LoggedInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loggedInResponseDescriptor = $convert.base64Decode(
    'ChBMb2dnZWRJblJlc3BvbnNlEh0KCnNlc3Npb25faWQYASACKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use createAccountRequestDescriptor instead')
const CreateAccountRequest$json = {
  '1': 'CreateAccountRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'db_password', '3': 2, '4': 1, '5': 9, '10': 'dbPassword'},
  ],
};

/// Descriptor for `CreateAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAccountRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVBY2NvdW50UmVxdWVzdBISCgRuYW1lGAEgAigJUgRuYW1lEh8KC2RiX3Bhc3N3b3'
    'JkGAIgASgJUgpkYlBhc3N3b3Jk');

@$core.Deprecated('Use restoreAccountRequestDescriptor instead')
const RestoreAccountRequest$json = {
  '1': 'RestoreAccountRequest',
  '2': [
    {'1': 'mnemonic', '3': 1, '4': 2, '5': 9, '10': 'mnemonic'},
    {'1': 'db_password', '3': 2, '4': 1, '5': 9, '10': 'dbPassword'},
  ],
};

/// Descriptor for `RestoreAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreAccountRequestDescriptor = $convert.base64Decode(
    'ChVSZXN0b3JlQWNjb3VudFJlcXVlc3QSGgoIbW5lbW9uaWMYASACKAlSCG1uZW1vbmljEh8KC2'
    'RiX3Bhc3N3b3JkGAIgASgJUgpkYlBhc3N3b3Jk');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 2, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0Eh0KCnNlc3Npb25faWQYASACKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode(
    'Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use deleteAccountRequestDescriptor instead')
const DeleteAccountRequest$json = {
  '1': 'DeleteAccountRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 2, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `DeleteAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVBY2NvdW50UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgAigJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use deleteAccountResponseDescriptor instead')
const DeleteAccountResponse$json = {
  '1': 'DeleteAccountResponse',
};

/// Descriptor for `DeleteAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVBY2NvdW50UmVzcG9uc2U=');

