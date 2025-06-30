//
//  Generated code. Do not modify.
//  source: protos/conversation_list.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use conversationTypeDescriptor instead')
const ConversationType$json = {
  '1': 'ConversationType',
  '2': [
    {'1': 'GROUP', '2': 0},
    {'1': 'COMMUNITY', '2': 1},
    {'1': 'ONE_TO_ONE', '2': 2},
    {'1': 'NOTE_TO_SELF', '2': 3},
  ],
};

/// Descriptor for `ConversationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List conversationTypeDescriptor = $convert.base64Decode(
    'ChBDb252ZXJzYXRpb25UeXBlEgkKBUdST1VQEAASDQoJQ09NTVVOSVRZEAESDgoKT05FX1RPX0'
    '9ORRACEhAKDE5PVEVfVE9fU0VMRhAD');

@$core.Deprecated('Use conversationSummaryDescriptor instead')
const ConversationSummary$json = {
  '1': 'ConversationSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'unread_count', '3': 2, '4': 2, '5': 13, '10': 'unreadCount'},
    {'1': 'type', '3': 3, '4': 2, '5': 14, '6': '.SessionApp.ConversationType', '10': 'type'},
    {'1': 'name', '3': 4, '4': 2, '5': 9, '10': 'name'},
    {'1': 'multiple_avatar', '3': 5, '4': 1, '5': 11, '6': '.SessionApp.GroupMemberAvatarList', '9': 0, '10': 'multipleAvatar'},
    {'1': 'single_avatar', '3': 6, '4': 1, '5': 11, '6': '.SessionApp.Avatar', '9': 0, '10': 'singleAvatar'},
    {'1': 'last_message', '3': 7, '4': 1, '5': 11, '6': '.SessionApp.Message', '10': 'lastMessage'},
    {'1': 'approved', '3': 8, '4': 2, '5': 8, '10': 'approved'},
    {'1': 'mentioned_me', '3': 9, '4': 2, '5': 8, '10': 'mentionedMe'},
  ],
  '8': [
    {'1': 'avatar'},
  ],
};

/// Descriptor for `ConversationSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationSummaryDescriptor = $convert.base64Decode(
    'ChNDb252ZXJzYXRpb25TdW1tYXJ5Eg4KAmlkGAEgAigJUgJpZBIhCgx1bnJlYWRfY291bnQYAi'
    'ACKA1SC3VucmVhZENvdW50EjAKBHR5cGUYAyACKA4yHC5TZXNzaW9uQXBwLkNvbnZlcnNhdGlv'
    'blR5cGVSBHR5cGUSEgoEbmFtZRgEIAIoCVIEbmFtZRJMCg9tdWx0aXBsZV9hdmF0YXIYBSABKA'
    'syIS5TZXNzaW9uQXBwLkdyb3VwTWVtYmVyQXZhdGFyTGlzdEgAUg5tdWx0aXBsZUF2YXRhchI5'
    'Cg1zaW5nbGVfYXZhdGFyGAYgASgLMhIuU2Vzc2lvbkFwcC5BdmF0YXJIAFIMc2luZ2xlQXZhdG'
    'FyEjYKDGxhc3RfbWVzc2FnZRgHIAEoCzITLlNlc3Npb25BcHAuTWVzc2FnZVILbGFzdE1lc3Nh'
    'Z2USGgoIYXBwcm92ZWQYCCACKAhSCGFwcHJvdmVkEiEKDG1lbnRpb25lZF9tZRgJIAIoCFILbW'
    'VudGlvbmVkTWVCCAoGYXZhdGFy');

@$core.Deprecated('Use listConversationsRequestDescriptor instead')
const ListConversationsRequest$json = {
  '1': 'ListConversationsRequest',
  '2': [
    {'1': 'approved', '3': 1, '4': 1, '5': 8, '10': 'approved'},
  ],
};

/// Descriptor for `ListConversationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConversationsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0Q29udmVyc2F0aW9uc1JlcXVlc3QSGgoIYXBwcm92ZWQYASABKAhSCGFwcHJvdmVk');

@$core.Deprecated('Use listConversationsResponseDescriptor instead')
const ListConversationsResponse$json = {
  '1': 'ListConversationsResponse',
  '2': [
    {'1': 'conversations', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.ConversationSummary', '10': 'conversations'},
  ],
};

/// Descriptor for `ListConversationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConversationsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0Q29udmVyc2F0aW9uc1Jlc3BvbnNlEkUKDWNvbnZlcnNhdGlvbnMYASADKAsyHy5TZX'
    'NzaW9uQXBwLkNvbnZlcnNhdGlvblN1bW1hcnlSDWNvbnZlcnNhdGlvbnM=');

@$core.Deprecated('Use loadMoreCommunityMessagesRequestDescriptor instead')
const LoadMoreCommunityMessagesRequest$json = {
  '1': 'LoadMoreCommunityMessagesRequest',
  '2': [
    {'1': 'community_id', '3': 1, '4': 2, '5': 9, '10': 'communityId'},
  ],
};

/// Descriptor for `LoadMoreCommunityMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadMoreCommunityMessagesRequestDescriptor = $convert.base64Decode(
    'CiBMb2FkTW9yZUNvbW11bml0eU1lc3NhZ2VzUmVxdWVzdBIhCgxjb21tdW5pdHlfaWQYASACKA'
    'lSC2NvbW11bml0eUlk');

@$core.Deprecated('Use loadMoreCommunityMessagesResponseDescriptor instead')
const LoadMoreCommunityMessagesResponse$json = {
  '1': 'LoadMoreCommunityMessagesResponse',
};

/// Descriptor for `LoadMoreCommunityMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadMoreCommunityMessagesResponseDescriptor = $convert.base64Decode(
    'CiFMb2FkTW9yZUNvbW11bml0eU1lc3NhZ2VzUmVzcG9uc2U=');

