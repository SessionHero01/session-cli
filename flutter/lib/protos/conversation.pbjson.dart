//
//  Generated code. Do not modify.
//  source: protos/conversation.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use conversationDetailsDescriptor instead')
const ConversationDetails$json = {
  '1': 'ConversationDetails',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'unread_count', '3': 3, '4': 2, '5': 5, '10': 'unreadCount'},
    {'1': 'single_avatar', '3': 4, '4': 1, '5': 11, '6': '.SessionApp.Avatar', '9': 0, '10': 'singleAvatar'},
    {'1': 'multiple_avatar', '3': 5, '4': 1, '5': 11, '6': '.SessionApp.GroupMemberAvatarList', '9': 0, '10': 'multipleAvatar'},
    {'1': 'active_community_members', '3': 6, '4': 1, '5': 5, '10': 'activeCommunityMembers'},
    {'1': 'total_group_members', '3': 7, '4': 1, '5': 5, '10': 'totalGroupMembers'},
    {'1': 'can_post_text', '3': 8, '4': 2, '5': 8, '10': 'canPostText'},
    {'1': 'can_upload', '3': 9, '4': 2, '5': 8, '10': 'canUpload'},
    {'1': 'approved', '3': 10, '4': 2, '5': 8, '10': 'approved'},
  ],
  '8': [
    {'1': 'avatar'},
  ],
};

/// Descriptor for `ConversationDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationDetailsDescriptor = $convert.base64Decode(
    'ChNDb252ZXJzYXRpb25EZXRhaWxzEg4KAmlkGAEgAigJUgJpZBISCgRuYW1lGAIgAigJUgRuYW'
    '1lEiEKDHVucmVhZF9jb3VudBgDIAIoBVILdW5yZWFkQ291bnQSOQoNc2luZ2xlX2F2YXRhchgE'
    'IAEoCzISLlNlc3Npb25BcHAuQXZhdGFySABSDHNpbmdsZUF2YXRhchJMCg9tdWx0aXBsZV9hdm'
    'F0YXIYBSABKAsyIS5TZXNzaW9uQXBwLkdyb3VwTWVtYmVyQXZhdGFyTGlzdEgAUg5tdWx0aXBs'
    'ZUF2YXRhchI4ChhhY3RpdmVfY29tbXVuaXR5X21lbWJlcnMYBiABKAVSFmFjdGl2ZUNvbW11bm'
    'l0eU1lbWJlcnMSLgoTdG90YWxfZ3JvdXBfbWVtYmVycxgHIAEoBVIRdG90YWxHcm91cE1lbWJl'
    'cnMSIgoNY2FuX3Bvc3RfdGV4dBgIIAIoCFILY2FuUG9zdFRleHQSHQoKY2FuX3VwbG9hZBgJIA'
    'IoCFIJY2FuVXBsb2FkEhoKCGFwcHJvdmVkGAogAigIUghhcHByb3ZlZEIICgZhdmF0YXI=');

@$core.Deprecated('Use getConversationDetailsRequestDescriptor instead')
const GetConversationDetailsRequest$json = {
  '1': 'GetConversationDetailsRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetConversationDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationDetailsRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRDb252ZXJzYXRpb25EZXRhaWxzUmVxdWVzdBIOCgJpZBgBIAIoCVICaWQ=');

@$core.Deprecated('Use getConversationDetailsResponseDescriptor instead')
const GetConversationDetailsResponse$json = {
  '1': 'GetConversationDetailsResponse',
  '2': [
    {'1': 'details', '3': 1, '4': 1, '5': 11, '6': '.SessionApp.ConversationDetails', '10': 'details'},
  ],
};

/// Descriptor for `GetConversationDetailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationDetailsResponseDescriptor = $convert.base64Decode(
    'Ch5HZXRDb252ZXJzYXRpb25EZXRhaWxzUmVzcG9uc2USOQoHZGV0YWlscxgBIAEoCzIfLlNlc3'
    'Npb25BcHAuQ29udmVyc2F0aW9uRGV0YWlsc1IHZGV0YWlscw==');

@$core.Deprecated('Use getConversationMessagesRequestDescriptor instead')
const GetConversationMessagesRequest$json = {
  '1': 'GetConversationMessagesRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'until', '3': 2, '4': 1, '5': 4, '10': 'until'},
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '9': 0, '10': 'limit'},
    {'1': 'after', '3': 4, '4': 1, '5': 4, '9': 0, '10': 'after'},
  ],
  '8': [
    {'1': 'earlier'},
  ],
};

/// Descriptor for `GetConversationMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationMessagesRequestDescriptor = $convert.base64Decode(
    'Ch5HZXRDb252ZXJzYXRpb25NZXNzYWdlc1JlcXVlc3QSDgoCaWQYASACKAlSAmlkEhQKBXVudG'
    'lsGAIgASgEUgV1bnRpbBIWCgVsaW1pdBgDIAEoDUgAUgVsaW1pdBIWCgVhZnRlchgEIAEoBEgA'
    'UgVhZnRlckIJCgdlYXJsaWVy');

@$core.Deprecated('Use getConversationMessagesResponseDescriptor instead')
const GetConversationMessagesResponse$json = {
  '1': 'GetConversationMessagesResponse',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.Message', '10': 'messages'},
  ],
};

/// Descriptor for `GetConversationMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationMessagesResponseDescriptor = $convert.base64Decode(
    'Ch9HZXRDb252ZXJzYXRpb25NZXNzYWdlc1Jlc3BvbnNlEi8KCG1lc3NhZ2VzGAEgAygLMhMuU2'
    'Vzc2lvbkFwcC5NZXNzYWdlUghtZXNzYWdlcw==');

