//
//  Generated code. Do not modify.
//  source: protos/contact.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use contactItemDescriptor instead')
const ContactItem$json = {
  '1': 'ContactItem',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'avatar', '3': 3, '4': 2, '5': 11, '6': '.SessionApp.Avatar', '10': 'avatar'},
  ],
};

/// Descriptor for `ContactItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactItemDescriptor = $convert.base64Decode(
    'CgtDb250YWN0SXRlbRIOCgJpZBgBIAIoCVICaWQSEgoEbmFtZRgCIAIoCVIEbmFtZRIqCgZhdm'
    'F0YXIYAyACKAsyEi5TZXNzaW9uQXBwLkF2YXRhclIGYXZhdGFy');

@$core.Deprecated('Use listContactsRequestDescriptor instead')
const ListContactsRequest$json = {
  '1': 'ListContactsRequest',
  '2': [
    {'1': 'search_query', '3': 1, '4': 1, '5': 9, '10': 'searchQuery'},
  ],
};

/// Descriptor for `ListContactsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContactsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q29udGFjdHNSZXF1ZXN0EiEKDHNlYXJjaF9xdWVyeRgBIAEoCVILc2VhcmNoUXVlcn'
    'k=');

@$core.Deprecated('Use listContactsResponseDescriptor instead')
const ListContactsResponse$json = {
  '1': 'ListContactsResponse',
  '2': [
    {'1': 'contacts', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.ContactItem', '10': 'contacts'},
  ],
};

/// Descriptor for `ListContactsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContactsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0Q29udGFjdHNSZXNwb25zZRIzCghjb250YWN0cxgBIAMoCzIXLlNlc3Npb25BcHAuQ2'
    '9udGFjdEl0ZW1SCGNvbnRhY3Rz');

