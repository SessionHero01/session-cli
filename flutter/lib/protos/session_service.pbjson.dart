//
//  Generated code. Do not modify.
//  source: protos/session_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use envelopeDescriptor instead')
const Envelope$json = {
  '1': 'Envelope',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.Envelope.Type', '10': 'type'},
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    {'1': 'sourceDevice', '3': 7, '4': 1, '5': 13, '10': 'sourceDevice'},
    {'1': 'timestamp', '3': 5, '4': 2, '5': 4, '10': 'timestamp'},
    {'1': 'content', '3': 8, '4': 1, '5': 12, '10': 'content'},
    {'1': 'serverTimestamp', '3': 10, '4': 1, '5': 4, '10': 'serverTimestamp'},
  ],
  '4': [Envelope_Type$json],
};

@$core.Deprecated('Use envelopeDescriptor instead')
const Envelope_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'SESSION_MESSAGE', '2': 6},
    {'1': 'CLOSED_GROUP_MESSAGE', '2': 7},
  ],
};

/// Descriptor for `Envelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List envelopeDescriptor = $convert.base64Decode(
    'CghFbnZlbG9wZRIwCgR0eXBlGAEgAigOMhwuU2Vzc2lvblByb3Rvcy5FbnZlbG9wZS5UeXBlUg'
    'R0eXBlEhYKBnNvdXJjZRgCIAEoCVIGc291cmNlEiIKDHNvdXJjZURldmljZRgHIAEoDVIMc291'
    'cmNlRGV2aWNlEhwKCXRpbWVzdGFtcBgFIAIoBFIJdGltZXN0YW1wEhgKB2NvbnRlbnQYCCABKA'
    'xSB2NvbnRlbnQSKAoPc2VydmVyVGltZXN0YW1wGAogASgEUg9zZXJ2ZXJUaW1lc3RhbXAiNQoE'
    'VHlwZRITCg9TRVNTSU9OX01FU1NBR0UQBhIYChRDTE9TRURfR1JPVVBfTUVTU0FHRRAH');

@$core.Deprecated('Use typingMessageDescriptor instead')
const TypingMessage$json = {
  '1': 'TypingMessage',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 2, '5': 4, '10': 'timestamp'},
    {'1': 'action', '3': 2, '4': 2, '5': 14, '6': '.SessionProtos.TypingMessage.Action', '10': 'action'},
  ],
  '4': [TypingMessage_Action$json],
};

@$core.Deprecated('Use typingMessageDescriptor instead')
const TypingMessage_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'STARTED', '2': 0},
    {'1': 'STOPPED', '2': 1},
  ],
};

/// Descriptor for `TypingMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List typingMessageDescriptor = $convert.base64Decode(
    'Cg1UeXBpbmdNZXNzYWdlEhwKCXRpbWVzdGFtcBgBIAIoBFIJdGltZXN0YW1wEjsKBmFjdGlvbh'
    'gCIAIoDjIjLlNlc3Npb25Qcm90b3MuVHlwaW5nTWVzc2FnZS5BY3Rpb25SBmFjdGlvbiIiCgZB'
    'Y3Rpb24SCwoHU1RBUlRFRBAAEgsKB1NUT1BQRUQQAQ==');

@$core.Deprecated('Use unsendRequestDescriptor instead')
const UnsendRequest$json = {
  '1': 'UnsendRequest',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 2, '5': 4, '10': 'timestamp'},
    {'1': 'author', '3': 2, '4': 2, '5': 9, '10': 'author'},
  ],
};

/// Descriptor for `UnsendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsendRequestDescriptor = $convert.base64Decode(
    'Cg1VbnNlbmRSZXF1ZXN0EhwKCXRpbWVzdGFtcBgBIAIoBFIJdGltZXN0YW1wEhYKBmF1dGhvch'
    'gCIAIoCVIGYXV0aG9y');

@$core.Deprecated('Use contentDescriptor instead')
const Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'dataMessage', '3': 1, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage', '10': 'dataMessage'},
    {'1': 'callMessage', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.CallMessage', '10': 'callMessage'},
    {'1': 'receiptMessage', '3': 5, '4': 1, '5': 11, '6': '.SessionProtos.ReceiptMessage', '10': 'receiptMessage'},
    {'1': 'typingMessage', '3': 6, '4': 1, '5': 11, '6': '.SessionProtos.TypingMessage', '10': 'typingMessage'},
    {'1': 'configurationMessage', '3': 7, '4': 1, '5': 11, '6': '.SessionProtos.ConfigurationMessage', '10': 'configurationMessage'},
    {'1': 'dataExtractionNotification', '3': 8, '4': 1, '5': 11, '6': '.SessionProtos.DataExtractionNotification', '10': 'dataExtractionNotification'},
    {'1': 'unsendRequest', '3': 9, '4': 1, '5': 11, '6': '.SessionProtos.UnsendRequest', '10': 'unsendRequest'},
    {'1': 'messageRequestResponse', '3': 10, '4': 1, '5': 11, '6': '.SessionProtos.MessageRequestResponse', '10': 'messageRequestResponse'},
    {'1': 'sharedConfigMessage', '3': 11, '4': 1, '5': 11, '6': '.SessionProtos.SharedConfigMessage', '10': 'sharedConfigMessage'},
    {'1': 'expirationType', '3': 12, '4': 1, '5': 14, '6': '.SessionProtos.Content.ExpirationType', '10': 'expirationType'},
    {'1': 'expirationTimer', '3': 13, '4': 1, '5': 13, '10': 'expirationTimer'},
    {'1': 'lastDisappearingMessageChangeTimestamp', '3': 14, '4': 1, '5': 4, '10': 'lastDisappearingMessageChangeTimestamp'},
  ],
  '4': [Content_ExpirationType$json],
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_ExpirationType$json = {
  '1': 'ExpirationType',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'DELETE_AFTER_READ', '2': 1},
    {'1': 'DELETE_AFTER_SEND', '2': 2},
  ],
};

/// Descriptor for `Content`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDescriptor = $convert.base64Decode(
    'CgdDb250ZW50EjwKC2RhdGFNZXNzYWdlGAEgASgLMhouU2Vzc2lvblByb3Rvcy5EYXRhTWVzc2'
    'FnZVILZGF0YU1lc3NhZ2USPAoLY2FsbE1lc3NhZ2UYAyABKAsyGi5TZXNzaW9uUHJvdG9zLkNh'
    'bGxNZXNzYWdlUgtjYWxsTWVzc2FnZRJFCg5yZWNlaXB0TWVzc2FnZRgFIAEoCzIdLlNlc3Npb2'
    '5Qcm90b3MuUmVjZWlwdE1lc3NhZ2VSDnJlY2VpcHRNZXNzYWdlEkIKDXR5cGluZ01lc3NhZ2UY'
    'BiABKAsyHC5TZXNzaW9uUHJvdG9zLlR5cGluZ01lc3NhZ2VSDXR5cGluZ01lc3NhZ2USVwoUY2'
    '9uZmlndXJhdGlvbk1lc3NhZ2UYByABKAsyIy5TZXNzaW9uUHJvdG9zLkNvbmZpZ3VyYXRpb25N'
    'ZXNzYWdlUhRjb25maWd1cmF0aW9uTWVzc2FnZRJpChpkYXRhRXh0cmFjdGlvbk5vdGlmaWNhdG'
    'lvbhgIIAEoCzIpLlNlc3Npb25Qcm90b3MuRGF0YUV4dHJhY3Rpb25Ob3RpZmljYXRpb25SGmRh'
    'dGFFeHRyYWN0aW9uTm90aWZpY2F0aW9uEkIKDXVuc2VuZFJlcXVlc3QYCSABKAsyHC5TZXNzaW'
    '9uUHJvdG9zLlVuc2VuZFJlcXVlc3RSDXVuc2VuZFJlcXVlc3QSXQoWbWVzc2FnZVJlcXVlc3RS'
    'ZXNwb25zZRgKIAEoCzIlLlNlc3Npb25Qcm90b3MuTWVzc2FnZVJlcXVlc3RSZXNwb25zZVIWbW'
    'Vzc2FnZVJlcXVlc3RSZXNwb25zZRJUChNzaGFyZWRDb25maWdNZXNzYWdlGAsgASgLMiIuU2Vz'
    'c2lvblByb3Rvcy5TaGFyZWRDb25maWdNZXNzYWdlUhNzaGFyZWRDb25maWdNZXNzYWdlEk0KDm'
    'V4cGlyYXRpb25UeXBlGAwgASgOMiUuU2Vzc2lvblByb3Rvcy5Db250ZW50LkV4cGlyYXRpb25U'
    'eXBlUg5leHBpcmF0aW9uVHlwZRIoCg9leHBpcmF0aW9uVGltZXIYDSABKA1SD2V4cGlyYXRpb2'
    '5UaW1lchJWCiZsYXN0RGlzYXBwZWFyaW5nTWVzc2FnZUNoYW5nZVRpbWVzdGFtcBgOIAEoBFIm'
    'bGFzdERpc2FwcGVhcmluZ01lc3NhZ2VDaGFuZ2VUaW1lc3RhbXAiSwoORXhwaXJhdGlvblR5cG'
    'USCwoHVU5LTk9XThAAEhUKEURFTEVURV9BRlRFUl9SRUFEEAESFQoRREVMRVRFX0FGVEVSX1NF'
    'TkQQAg==');

@$core.Deprecated('Use keyPairDescriptor instead')
const KeyPair$json = {
  '1': 'KeyPair',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'privateKey', '3': 2, '4': 2, '5': 12, '10': 'privateKey'},
  ],
};

/// Descriptor for `KeyPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keyPairDescriptor = $convert.base64Decode(
    'CgdLZXlQYWlyEhwKCXB1YmxpY0tleRgBIAIoDFIJcHVibGljS2V5Eh4KCnByaXZhdGVLZXkYAi'
    'ACKAxSCnByaXZhdGVLZXk=');

@$core.Deprecated('Use dataExtractionNotificationDescriptor instead')
const DataExtractionNotification$json = {
  '1': 'DataExtractionNotification',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.DataExtractionNotification.Type', '10': 'type'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 4, '10': 'timestamp'},
  ],
  '4': [DataExtractionNotification_Type$json],
};

@$core.Deprecated('Use dataExtractionNotificationDescriptor instead')
const DataExtractionNotification_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'SCREENSHOT', '2': 1},
    {'1': 'MEDIA_SAVED', '2': 2},
  ],
};

/// Descriptor for `DataExtractionNotification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataExtractionNotificationDescriptor = $convert.base64Decode(
    'ChpEYXRhRXh0cmFjdGlvbk5vdGlmaWNhdGlvbhJCCgR0eXBlGAEgAigOMi4uU2Vzc2lvblByb3'
    'Rvcy5EYXRhRXh0cmFjdGlvbk5vdGlmaWNhdGlvbi5UeXBlUgR0eXBlEhwKCXRpbWVzdGFtcBgC'
    'IAEoBFIJdGltZXN0YW1wIicKBFR5cGUSDgoKU0NSRUVOU0hPVBABEg8KC01FRElBX1NBVkVEEA'
    'I=');

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage$json = {
  '1': 'DataMessage',
  '2': [
    {'1': 'body', '3': 1, '4': 1, '5': 9, '10': 'body'},
    {'1': 'attachments', '3': 2, '4': 3, '5': 11, '6': '.SessionProtos.AttachmentPointer', '10': 'attachments'},
    {'1': 'flags', '3': 4, '4': 1, '5': 13, '10': 'flags'},
    {'1': 'expireTimer', '3': 5, '4': 1, '5': 13, '10': 'expireTimer'},
    {'1': 'profileKey', '3': 6, '4': 1, '5': 12, '10': 'profileKey'},
    {'1': 'timestamp', '3': 7, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'quote', '3': 8, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.Quote', '10': 'quote'},
    {'1': 'preview', '3': 10, '4': 3, '5': 11, '6': '.SessionProtos.DataMessage.Preview', '10': 'preview'},
    {'1': 'reaction', '3': 11, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.Reaction', '10': 'reaction'},
    {'1': 'profile', '3': 101, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.LokiProfile', '10': 'profile'},
    {'1': 'openGroupInvitation', '3': 102, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.OpenGroupInvitation', '10': 'openGroupInvitation'},
    {'1': 'closedGroupControlMessage', '3': 104, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.ClosedGroupControlMessage', '10': 'closedGroupControlMessage'},
    {'1': 'syncTarget', '3': 105, '4': 1, '5': 9, '10': 'syncTarget'},
    {'1': 'blocksCommunityMessageRequests', '3': 106, '4': 1, '5': 8, '10': 'blocksCommunityMessageRequests'},
    {'1': 'groupUpdateMessage', '3': 120, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateMessage', '10': 'groupUpdateMessage'},
  ],
  '3': [DataMessage_Quote$json, DataMessage_Preview$json, DataMessage_LokiProfile$json, DataMessage_OpenGroupInvitation$json, DataMessage_GroupUpdateMessage$json, DataMessage_GroupUpdateInviteMessage$json, DataMessage_GroupUpdateDeleteMessage$json, DataMessage_GroupUpdatePromoteMessage$json, DataMessage_GroupUpdateInfoChangeMessage$json, DataMessage_GroupUpdateMemberChangeMessage$json, DataMessage_GroupUpdateMemberLeftMessage$json, DataMessage_GroupUpdateInviteResponseMessage$json, DataMessage_GroupUpdateDeleteMemberContentMessage$json, DataMessage_GroupUpdateMemberLeftNotificationMessage$json, DataMessage_ClosedGroupControlMessage$json, DataMessage_Reaction$json],
  '4': [DataMessage_Flags$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Quote$json = {
  '1': 'Quote',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
    {'1': 'author', '3': 2, '4': 2, '5': 9, '10': 'author'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'attachments', '3': 4, '4': 3, '5': 11, '6': '.SessionProtos.DataMessage.Quote.QuotedAttachment', '10': 'attachments'},
  ],
  '3': [DataMessage_Quote_QuotedAttachment$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Quote_QuotedAttachment$json = {
  '1': 'QuotedAttachment',
  '2': [
    {'1': 'contentType', '3': 1, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'fileName', '3': 2, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'thumbnail', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.AttachmentPointer', '10': 'thumbnail'},
    {'1': 'flags', '3': 4, '4': 1, '5': 13, '10': 'flags'},
  ],
  '4': [DataMessage_Quote_QuotedAttachment_Flags$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Quote_QuotedAttachment_Flags$json = {
  '1': 'Flags',
  '2': [
    {'1': 'VOICE_MESSAGE', '2': 1},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Preview$json = {
  '1': 'Preview',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'image', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.AttachmentPointer', '10': 'image'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_LokiProfile$json = {
  '1': 'LokiProfile',
  '2': [
    {'1': 'displayName', '3': 1, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'profilePicture', '3': 2, '4': 1, '5': 9, '10': 'profilePicture'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_OpenGroupInvitation$json = {
  '1': 'OpenGroupInvitation',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'name', '3': 3, '4': 2, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateMessage$json = {
  '1': 'GroupUpdateMessage',
  '2': [
    {'1': 'inviteMessage', '3': 1, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateInviteMessage', '10': 'inviteMessage'},
    {'1': 'infoChangeMessage', '3': 2, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateInfoChangeMessage', '10': 'infoChangeMessage'},
    {'1': 'memberChangeMessage', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateMemberChangeMessage', '10': 'memberChangeMessage'},
    {'1': 'promoteMessage', '3': 4, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdatePromoteMessage', '10': 'promoteMessage'},
    {'1': 'memberLeftMessage', '3': 5, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateMemberLeftMessage', '10': 'memberLeftMessage'},
    {'1': 'inviteResponse', '3': 6, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateInviteResponseMessage', '10': 'inviteResponse'},
    {'1': 'deleteMemberContent', '3': 7, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateDeleteMemberContentMessage', '10': 'deleteMemberContent'},
    {'1': 'memberLeftNotificationMessage', '3': 8, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.GroupUpdateMemberLeftNotificationMessage', '10': 'memberLeftNotificationMessage'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateInviteMessage$json = {
  '1': 'GroupUpdateInviteMessage',
  '2': [
    {'1': 'groupSessionId', '3': 1, '4': 2, '5': 9, '10': 'groupSessionId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'memberAuthData', '3': 3, '4': 2, '5': 12, '10': 'memberAuthData'},
    {'1': 'adminSignature', '3': 4, '4': 2, '5': 12, '10': 'adminSignature'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateDeleteMessage$json = {
  '1': 'GroupUpdateDeleteMessage',
  '2': [
    {'1': 'memberSessionIds', '3': 1, '4': 3, '5': 9, '10': 'memberSessionIds'},
    {'1': 'adminSignature', '3': 2, '4': 2, '5': 12, '10': 'adminSignature'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdatePromoteMessage$json = {
  '1': 'GroupUpdatePromoteMessage',
  '2': [
    {'1': 'groupIdentitySeed', '3': 1, '4': 2, '5': 12, '10': 'groupIdentitySeed'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateInfoChangeMessage$json = {
  '1': 'GroupUpdateInfoChangeMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.DataMessage.GroupUpdateInfoChangeMessage.Type', '10': 'type'},
    {'1': 'updatedName', '3': 2, '4': 1, '5': 9, '10': 'updatedName'},
    {'1': 'updatedExpiration', '3': 3, '4': 1, '5': 13, '10': 'updatedExpiration'},
    {'1': 'adminSignature', '3': 4, '4': 2, '5': 12, '10': 'adminSignature'},
  ],
  '4': [DataMessage_GroupUpdateInfoChangeMessage_Type$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateInfoChangeMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'NAME', '2': 1},
    {'1': 'AVATAR', '2': 2},
    {'1': 'DISAPPEARING_MESSAGES', '2': 3},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateMemberChangeMessage$json = {
  '1': 'GroupUpdateMemberChangeMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.DataMessage.GroupUpdateMemberChangeMessage.Type', '10': 'type'},
    {'1': 'memberSessionIds', '3': 2, '4': 3, '5': 9, '10': 'memberSessionIds'},
    {'1': 'historyShared', '3': 3, '4': 1, '5': 8, '10': 'historyShared'},
    {'1': 'adminSignature', '3': 4, '4': 2, '5': 12, '10': 'adminSignature'},
  ],
  '4': [DataMessage_GroupUpdateMemberChangeMessage_Type$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateMemberChangeMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'ADDED', '2': 1},
    {'1': 'REMOVED', '2': 2},
    {'1': 'PROMOTED', '2': 3},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateMemberLeftMessage$json = {
  '1': 'GroupUpdateMemberLeftMessage',
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateInviteResponseMessage$json = {
  '1': 'GroupUpdateInviteResponseMessage',
  '2': [
    {'1': 'isApproved', '3': 1, '4': 2, '5': 8, '10': 'isApproved'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateDeleteMemberContentMessage$json = {
  '1': 'GroupUpdateDeleteMemberContentMessage',
  '2': [
    {'1': 'memberSessionIds', '3': 1, '4': 3, '5': 9, '10': 'memberSessionIds'},
    {'1': 'messageHashes', '3': 2, '4': 3, '5': 9, '10': 'messageHashes'},
    {'1': 'adminSignature', '3': 3, '4': 1, '5': 12, '10': 'adminSignature'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_GroupUpdateMemberLeftNotificationMessage$json = {
  '1': 'GroupUpdateMemberLeftNotificationMessage',
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_ClosedGroupControlMessage$json = {
  '1': 'ClosedGroupControlMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.DataMessage.ClosedGroupControlMessage.Type', '10': 'type'},
    {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'encryptionKeyPair', '3': 4, '4': 1, '5': 11, '6': '.SessionProtos.KeyPair', '10': 'encryptionKeyPair'},
    {'1': 'members', '3': 5, '4': 3, '5': 12, '10': 'members'},
    {'1': 'admins', '3': 6, '4': 3, '5': 12, '10': 'admins'},
    {'1': 'wrappers', '3': 7, '4': 3, '5': 11, '6': '.SessionProtos.DataMessage.ClosedGroupControlMessage.KeyPairWrapper', '10': 'wrappers'},
    {'1': 'expirationTimer', '3': 8, '4': 1, '5': 13, '10': 'expirationTimer'},
    {'1': 'memberPrivateKey', '3': 9, '4': 1, '5': 12, '10': 'memberPrivateKey'},
    {'1': 'privateKey', '3': 10, '4': 1, '5': 12, '10': 'privateKey'},
  ],
  '3': [DataMessage_ClosedGroupControlMessage_KeyPairWrapper$json],
  '4': [DataMessage_ClosedGroupControlMessage_Type$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_ClosedGroupControlMessage_KeyPairWrapper$json = {
  '1': 'KeyPairWrapper',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'encryptedKeyPair', '3': 2, '4': 2, '5': 12, '10': 'encryptedKeyPair'},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_ClosedGroupControlMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'NEW', '2': 1},
    {'1': 'ENCRYPTION_KEY_PAIR', '2': 3},
    {'1': 'NAME_CHANGE', '2': 4},
    {'1': 'MEMBERS_ADDED', '2': 5},
    {'1': 'MEMBERS_REMOVED', '2': 6},
    {'1': 'MEMBER_LEFT', '2': 7},
    {'1': 'INVITE', '2': 9},
    {'1': 'PROMOTE', '2': 10},
    {'1': 'DELETE_GROUP', '2': 11},
    {'1': 'DELETE_MESSAGES', '2': 12},
    {'1': 'DELETE_ATTACHMENTS', '2': 13},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Reaction$json = {
  '1': 'Reaction',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
    {'1': 'author', '3': 2, '4': 2, '5': 9, '10': 'author'},
    {'1': 'emoji', '3': 3, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'action', '3': 4, '4': 2, '5': 14, '6': '.SessionProtos.DataMessage.Reaction.Action', '10': 'action'},
  ],
  '4': [DataMessage_Reaction_Action$json],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Reaction_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'REACT', '2': 0},
    {'1': 'REMOVE', '2': 1},
  ],
};

@$core.Deprecated('Use dataMessageDescriptor instead')
const DataMessage_Flags$json = {
  '1': 'Flags',
  '2': [
    {'1': 'EXPIRATION_TIMER_UPDATE', '2': 2},
  ],
};

/// Descriptor for `DataMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataMessageDescriptor = $convert.base64Decode(
    'CgtEYXRhTWVzc2FnZRISCgRib2R5GAEgASgJUgRib2R5EkIKC2F0dGFjaG1lbnRzGAIgAygLMi'
    'AuU2Vzc2lvblByb3Rvcy5BdHRhY2htZW50UG9pbnRlclILYXR0YWNobWVudHMSFAoFZmxhZ3MY'
    'BCABKA1SBWZsYWdzEiAKC2V4cGlyZVRpbWVyGAUgASgNUgtleHBpcmVUaW1lchIeCgpwcm9maW'
    'xlS2V5GAYgASgMUgpwcm9maWxlS2V5EhwKCXRpbWVzdGFtcBgHIAEoBFIJdGltZXN0YW1wEjYK'
    'BXF1b3RlGAggASgLMiAuU2Vzc2lvblByb3Rvcy5EYXRhTWVzc2FnZS5RdW90ZVIFcXVvdGUSPA'
    'oHcHJldmlldxgKIAMoCzIiLlNlc3Npb25Qcm90b3MuRGF0YU1lc3NhZ2UuUHJldmlld1IHcHJl'
    'dmlldxI/CghyZWFjdGlvbhgLIAEoCzIjLlNlc3Npb25Qcm90b3MuRGF0YU1lc3NhZ2UuUmVhY3'
    'Rpb25SCHJlYWN0aW9uEkAKB3Byb2ZpbGUYZSABKAsyJi5TZXNzaW9uUHJvdG9zLkRhdGFNZXNz'
    'YWdlLkxva2lQcm9maWxlUgdwcm9maWxlEmAKE29wZW5Hcm91cEludml0YXRpb24YZiABKAsyLi'
    '5TZXNzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLk9wZW5Hcm91cEludml0YXRpb25SE29wZW5Hcm91'
    'cEludml0YXRpb24ScgoZY2xvc2VkR3JvdXBDb250cm9sTWVzc2FnZRhoIAEoCzI0LlNlc3Npb2'
    '5Qcm90b3MuRGF0YU1lc3NhZ2UuQ2xvc2VkR3JvdXBDb250cm9sTWVzc2FnZVIZY2xvc2VkR3Jv'
    'dXBDb250cm9sTWVzc2FnZRIeCgpzeW5jVGFyZ2V0GGkgASgJUgpzeW5jVGFyZ2V0EkYKHmJsb2'
    'Nrc0NvbW11bml0eU1lc3NhZ2VSZXF1ZXN0cxhqIAEoCFIeYmxvY2tzQ29tbXVuaXR5TWVzc2Fn'
    'ZVJlcXVlc3RzEl0KEmdyb3VwVXBkYXRlTWVzc2FnZRh4IAEoCzItLlNlc3Npb25Qcm90b3MuRG'
    'F0YU1lc3NhZ2UuR3JvdXBVcGRhdGVNZXNzYWdlUhJncm91cFVwZGF0ZU1lc3NhZ2Ua3QIKBVF1'
    'b3RlEg4KAmlkGAEgAigEUgJpZBIWCgZhdXRob3IYAiACKAlSBmF1dGhvchISCgR0ZXh0GAMgAS'
    'gJUgR0ZXh0ElMKC2F0dGFjaG1lbnRzGAQgAygLMjEuU2Vzc2lvblByb3Rvcy5EYXRhTWVzc2Fn'
    'ZS5RdW90ZS5RdW90ZWRBdHRhY2htZW50UgthdHRhY2htZW50cxrCAQoQUXVvdGVkQXR0YWNobW'
    'VudBIgCgtjb250ZW50VHlwZRgBIAEoCVILY29udGVudFR5cGUSGgoIZmlsZU5hbWUYAiABKAlS'
    'CGZpbGVOYW1lEj4KCXRodW1ibmFpbBgDIAEoCzIgLlNlc3Npb25Qcm90b3MuQXR0YWNobWVudF'
    'BvaW50ZXJSCXRodW1ibmFpbBIUCgVmbGFncxgEIAEoDVIFZmxhZ3MiGgoFRmxhZ3MSEQoNVk9J'
    'Q0VfTUVTU0FHRRABGmkKB1ByZXZpZXcSEAoDdXJsGAEgAigJUgN1cmwSFAoFdGl0bGUYAiABKA'
    'lSBXRpdGxlEjYKBWltYWdlGAMgASgLMiAuU2Vzc2lvblByb3Rvcy5BdHRhY2htZW50UG9pbnRl'
    'clIFaW1hZ2UaVwoLTG9raVByb2ZpbGUSIAoLZGlzcGxheU5hbWUYASABKAlSC2Rpc3BsYXlOYW'
    '1lEiYKDnByb2ZpbGVQaWN0dXJlGAIgASgJUg5wcm9maWxlUGljdHVyZRo7ChNPcGVuR3JvdXBJ'
    'bnZpdGF0aW9uEhAKA3VybBgBIAIoCVIDdXJsEhIKBG5hbWUYAyACKAlSBG5hbWUa7QYKEkdyb3'
    'VwVXBkYXRlTWVzc2FnZRJZCg1pbnZpdGVNZXNzYWdlGAEgASgLMjMuU2Vzc2lvblByb3Rvcy5E'
    'YXRhTWVzc2FnZS5Hcm91cFVwZGF0ZUludml0ZU1lc3NhZ2VSDWludml0ZU1lc3NhZ2USZQoRaW'
    '5mb0NoYW5nZU1lc3NhZ2UYAiABKAsyNy5TZXNzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLkdyb3Vw'
    'VXBkYXRlSW5mb0NoYW5nZU1lc3NhZ2VSEWluZm9DaGFuZ2VNZXNzYWdlEmsKE21lbWJlckNoYW'
    '5nZU1lc3NhZ2UYAyABKAsyOS5TZXNzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLkdyb3VwVXBkYXRl'
    'TWVtYmVyQ2hhbmdlTWVzc2FnZVITbWVtYmVyQ2hhbmdlTWVzc2FnZRJcCg5wcm9tb3RlTWVzc2'
    'FnZRgEIAEoCzI0LlNlc3Npb25Qcm90b3MuRGF0YU1lc3NhZ2UuR3JvdXBVcGRhdGVQcm9tb3Rl'
    'TWVzc2FnZVIOcHJvbW90ZU1lc3NhZ2USZQoRbWVtYmVyTGVmdE1lc3NhZ2UYBSABKAsyNy5TZX'
    'NzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLkdyb3VwVXBkYXRlTWVtYmVyTGVmdE1lc3NhZ2VSEW1l'
    'bWJlckxlZnRNZXNzYWdlEmMKDmludml0ZVJlc3BvbnNlGAYgASgLMjsuU2Vzc2lvblByb3Rvcy'
    '5EYXRhTWVzc2FnZS5Hcm91cFVwZGF0ZUludml0ZVJlc3BvbnNlTWVzc2FnZVIOaW52aXRlUmVz'
    'cG9uc2UScgoTZGVsZXRlTWVtYmVyQ29udGVudBgHIAEoCzJALlNlc3Npb25Qcm90b3MuRGF0YU'
    '1lc3NhZ2UuR3JvdXBVcGRhdGVEZWxldGVNZW1iZXJDb250ZW50TWVzc2FnZVITZGVsZXRlTWVt'
    'YmVyQ29udGVudBKJAQodbWVtYmVyTGVmdE5vdGlmaWNhdGlvbk1lc3NhZ2UYCCABKAsyQy5TZX'
    'NzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLkdyb3VwVXBkYXRlTWVtYmVyTGVmdE5vdGlmaWNhdGlv'
    'bk1lc3NhZ2VSHW1lbWJlckxlZnROb3RpZmljYXRpb25NZXNzYWdlGqYBChhHcm91cFVwZGF0ZU'
    'ludml0ZU1lc3NhZ2USJgoOZ3JvdXBTZXNzaW9uSWQYASACKAlSDmdyb3VwU2Vzc2lvbklkEhIK'
    'BG5hbWUYAiACKAlSBG5hbWUSJgoObWVtYmVyQXV0aERhdGEYAyACKAxSDm1lbWJlckF1dGhEYX'
    'RhEiYKDmFkbWluU2lnbmF0dXJlGAQgAigMUg5hZG1pblNpZ25hdHVyZRpuChhHcm91cFVwZGF0'
    'ZURlbGV0ZU1lc3NhZ2USKgoQbWVtYmVyU2Vzc2lvbklkcxgBIAMoCVIQbWVtYmVyU2Vzc2lvbk'
    'lkcxImCg5hZG1pblNpZ25hdHVyZRgCIAIoDFIOYWRtaW5TaWduYXR1cmUaXQoZR3JvdXBVcGRh'
    'dGVQcm9tb3RlTWVzc2FnZRIsChFncm91cElkZW50aXR5U2VlZBgBIAIoDFIRZ3JvdXBJZGVudG'
    'l0eVNlZWQSEgoEbmFtZRgCIAIoCVIEbmFtZRqhAgocR3JvdXBVcGRhdGVJbmZvQ2hhbmdlTWVz'
    'c2FnZRJQCgR0eXBlGAEgAigOMjwuU2Vzc2lvblByb3Rvcy5EYXRhTWVzc2FnZS5Hcm91cFVwZG'
    'F0ZUluZm9DaGFuZ2VNZXNzYWdlLlR5cGVSBHR5cGUSIAoLdXBkYXRlZE5hbWUYAiABKAlSC3Vw'
    'ZGF0ZWROYW1lEiwKEXVwZGF0ZWRFeHBpcmF0aW9uGAMgASgNUhF1cGRhdGVkRXhwaXJhdGlvbh'
    'ImCg5hZG1pblNpZ25hdHVyZRgEIAIoDFIOYWRtaW5TaWduYXR1cmUiNwoEVHlwZRIICgROQU1F'
    'EAESCgoGQVZBVEFSEAISGQoVRElTQVBQRUFSSU5HX01FU1NBR0VTEAManAIKHkdyb3VwVXBkYX'
    'RlTWVtYmVyQ2hhbmdlTWVzc2FnZRJSCgR0eXBlGAEgAigOMj4uU2Vzc2lvblByb3Rvcy5EYXRh'
    'TWVzc2FnZS5Hcm91cFVwZGF0ZU1lbWJlckNoYW5nZU1lc3NhZ2UuVHlwZVIEdHlwZRIqChBtZW'
    '1iZXJTZXNzaW9uSWRzGAIgAygJUhBtZW1iZXJTZXNzaW9uSWRzEiQKDWhpc3RvcnlTaGFyZWQY'
    'AyABKAhSDWhpc3RvcnlTaGFyZWQSJgoOYWRtaW5TaWduYXR1cmUYBCACKAxSDmFkbWluU2lnbm'
    'F0dXJlIiwKBFR5cGUSCQoFQURERUQQARILCgdSRU1PVkVEEAISDAoIUFJPTU9URUQQAxoeChxH'
    'cm91cFVwZGF0ZU1lbWJlckxlZnRNZXNzYWdlGkIKIEdyb3VwVXBkYXRlSW52aXRlUmVzcG9uc2'
    'VNZXNzYWdlEh4KCmlzQXBwcm92ZWQYASACKAhSCmlzQXBwcm92ZWQaoQEKJUdyb3VwVXBkYXRl'
    'RGVsZXRlTWVtYmVyQ29udGVudE1lc3NhZ2USKgoQbWVtYmVyU2Vzc2lvbklkcxgBIAMoCVIQbW'
    'VtYmVyU2Vzc2lvbklkcxIkCg1tZXNzYWdlSGFzaGVzGAIgAygJUg1tZXNzYWdlSGFzaGVzEiYK'
    'DmFkbWluU2lnbmF0dXJlGAMgASgMUg5hZG1pblNpZ25hdHVyZRoqCihHcm91cFVwZGF0ZU1lbW'
    'JlckxlZnROb3RpZmljYXRpb25NZXNzYWdlGpQGChlDbG9zZWRHcm91cENvbnRyb2xNZXNzYWdl'
    'Ek0KBHR5cGUYASACKA4yOS5TZXNzaW9uUHJvdG9zLkRhdGFNZXNzYWdlLkNsb3NlZEdyb3VwQ2'
    '9udHJvbE1lc3NhZ2UuVHlwZVIEdHlwZRIcCglwdWJsaWNLZXkYAiABKAxSCXB1YmxpY0tleRIS'
    'CgRuYW1lGAMgASgJUgRuYW1lEkQKEWVuY3J5cHRpb25LZXlQYWlyGAQgASgLMhYuU2Vzc2lvbl'
    'Byb3Rvcy5LZXlQYWlyUhFlbmNyeXB0aW9uS2V5UGFpchIYCgdtZW1iZXJzGAUgAygMUgdtZW1i'
    'ZXJzEhYKBmFkbWlucxgGIAMoDFIGYWRtaW5zEl8KCHdyYXBwZXJzGAcgAygLMkMuU2Vzc2lvbl'
    'Byb3Rvcy5EYXRhTWVzc2FnZS5DbG9zZWRHcm91cENvbnRyb2xNZXNzYWdlLktleVBhaXJXcmFw'
    'cGVyUgh3cmFwcGVycxIoCg9leHBpcmF0aW9uVGltZXIYCCABKA1SD2V4cGlyYXRpb25UaW1lch'
    'IqChBtZW1iZXJQcml2YXRlS2V5GAkgASgMUhBtZW1iZXJQcml2YXRlS2V5Eh4KCnByaXZhdGVL'
    'ZXkYCiABKAxSCnByaXZhdGVLZXkaWgoOS2V5UGFpcldyYXBwZXISHAoJcHVibGljS2V5GAEgAi'
    'gMUglwdWJsaWNLZXkSKgoQZW5jcnlwdGVkS2V5UGFpchgCIAIoDFIQZW5jcnlwdGVkS2V5UGFp'
    'ciLKAQoEVHlwZRIHCgNORVcQARIXChNFTkNSWVBUSU9OX0tFWV9QQUlSEAMSDwoLTkFNRV9DSE'
    'FOR0UQBBIRCg1NRU1CRVJTX0FEREVEEAUSEwoPTUVNQkVSU19SRU1PVkVEEAYSDwoLTUVNQkVS'
    'X0xFRlQQBxIKCgZJTlZJVEUQCRILCgdQUk9NT1RFEAoSEAoMREVMRVRFX0dST1VQEAsSEwoPRE'
    'VMRVRFX01FU1NBR0VTEAwSFgoSREVMRVRFX0FUVEFDSE1FTlRTEA0arQEKCFJlYWN0aW9uEg4K'
    'AmlkGAEgAigEUgJpZBIWCgZhdXRob3IYAiACKAlSBmF1dGhvchIUCgVlbW9qaRgDIAEoCVIFZW'
    '1vamkSQgoGYWN0aW9uGAQgAigOMiouU2Vzc2lvblByb3Rvcy5EYXRhTWVzc2FnZS5SZWFjdGlv'
    'bi5BY3Rpb25SBmFjdGlvbiIfCgZBY3Rpb24SCQoFUkVBQ1QQABIKCgZSRU1PVkUQASIkCgVGbG'
    'FncxIbChdFWFBJUkFUSU9OX1RJTUVSX1VQREFURRAC');

@$core.Deprecated('Use groupDeleteMessageDescriptor instead')
const GroupDeleteMessage$json = {
  '1': 'GroupDeleteMessage',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'lastEncryptionKey', '3': 2, '4': 2, '5': 12, '10': 'lastEncryptionKey'},
  ],
};

/// Descriptor for `GroupDeleteMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupDeleteMessageDescriptor = $convert.base64Decode(
    'ChJHcm91cERlbGV0ZU1lc3NhZ2USHAoJcHVibGljS2V5GAEgAigMUglwdWJsaWNLZXkSLAoRbG'
    'FzdEVuY3J5cHRpb25LZXkYAiACKAxSEWxhc3RFbmNyeXB0aW9uS2V5');

@$core.Deprecated('Use groupMemberLeftMessageDescriptor instead')
const GroupMemberLeftMessage$json = {
  '1': 'GroupMemberLeftMessage',
};

/// Descriptor for `GroupMemberLeftMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberLeftMessageDescriptor = $convert.base64Decode(
    'ChZHcm91cE1lbWJlckxlZnRNZXNzYWdl');

@$core.Deprecated('Use groupInviteMessageDescriptor instead')
const GroupInviteMessage$json = {
  '1': 'GroupInviteMessage',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'memberPrivateKey', '3': 3, '4': 2, '5': 12, '10': 'memberPrivateKey'},
  ],
};

/// Descriptor for `GroupInviteMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInviteMessageDescriptor = $convert.base64Decode(
    'ChJHcm91cEludml0ZU1lc3NhZ2USHAoJcHVibGljS2V5GAEgAigMUglwdWJsaWNLZXkSEgoEbm'
    'FtZRgCIAIoCVIEbmFtZRIqChBtZW1iZXJQcml2YXRlS2V5GAMgAigMUhBtZW1iZXJQcml2YXRl'
    'S2V5');

@$core.Deprecated('Use groupPromoteMessageDescriptor instead')
const GroupPromoteMessage$json = {
  '1': 'GroupPromoteMessage',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'encryptedPrivateKey', '3': 2, '4': 2, '5': 12, '10': 'encryptedPrivateKey'},
  ],
};

/// Descriptor for `GroupPromoteMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupPromoteMessageDescriptor = $convert.base64Decode(
    'ChNHcm91cFByb21vdGVNZXNzYWdlEhwKCXB1YmxpY0tleRgBIAIoDFIJcHVibGljS2V5EjAKE2'
    'VuY3J5cHRlZFByaXZhdGVLZXkYAiACKAxSE2VuY3J5cHRlZFByaXZhdGVLZXk=');

@$core.Deprecated('Use callMessageDescriptor instead')
const CallMessage$json = {
  '1': 'CallMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.CallMessage.Type', '10': 'type'},
    {'1': 'sdps', '3': 2, '4': 3, '5': 9, '10': 'sdps'},
    {'1': 'sdpMLineIndexes', '3': 3, '4': 3, '5': 13, '10': 'sdpMLineIndexes'},
    {'1': 'sdpMids', '3': 4, '4': 3, '5': 9, '10': 'sdpMids'},
    {'1': 'uuid', '3': 5, '4': 2, '5': 9, '10': 'uuid'},
  ],
  '4': [CallMessage_Type$json],
};

@$core.Deprecated('Use callMessageDescriptor instead')
const CallMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'PRE_OFFER', '2': 6},
    {'1': 'OFFER', '2': 1},
    {'1': 'ANSWER', '2': 2},
    {'1': 'PROVISIONAL_ANSWER', '2': 3},
    {'1': 'ICE_CANDIDATES', '2': 4},
    {'1': 'END_CALL', '2': 5},
  ],
};

/// Descriptor for `CallMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMessageDescriptor = $convert.base64Decode(
    'CgtDYWxsTWVzc2FnZRIzCgR0eXBlGAEgAigOMh8uU2Vzc2lvblByb3Rvcy5DYWxsTWVzc2FnZS'
    '5UeXBlUgR0eXBlEhIKBHNkcHMYAiADKAlSBHNkcHMSKAoPc2RwTUxpbmVJbmRleGVzGAMgAygN'
    'Ug9zZHBNTGluZUluZGV4ZXMSGAoHc2RwTWlkcxgEIAMoCVIHc2RwTWlkcxISCgR1dWlkGAUgAi'
    'gJUgR1dWlkImYKBFR5cGUSDQoJUFJFX09GRkVSEAYSCQoFT0ZGRVIQARIKCgZBTlNXRVIQAhIW'
    'ChJQUk9WSVNJT05BTF9BTlNXRVIQAxISCg5JQ0VfQ0FORElEQVRFUxAEEgwKCEVORF9DQUxMEA'
    'U=');

@$core.Deprecated('Use configurationMessageDescriptor instead')
const ConfigurationMessage$json = {
  '1': 'ConfigurationMessage',
  '2': [
    {'1': 'closedGroups', '3': 1, '4': 3, '5': 11, '6': '.SessionProtos.ConfigurationMessage.ClosedGroup', '10': 'closedGroups'},
    {'1': 'openGroups', '3': 2, '4': 3, '5': 9, '10': 'openGroups'},
    {'1': 'displayName', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'profilePicture', '3': 4, '4': 1, '5': 9, '10': 'profilePicture'},
    {'1': 'profileKey', '3': 5, '4': 1, '5': 12, '10': 'profileKey'},
    {'1': 'contacts', '3': 6, '4': 3, '5': 11, '6': '.SessionProtos.ConfigurationMessage.Contact', '10': 'contacts'},
  ],
  '3': [ConfigurationMessage_ClosedGroup$json, ConfigurationMessage_Contact$json],
};

@$core.Deprecated('Use configurationMessageDescriptor instead')
const ConfigurationMessage_ClosedGroup$json = {
  '1': 'ClosedGroup',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'encryptionKeyPair', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.KeyPair', '10': 'encryptionKeyPair'},
    {'1': 'members', '3': 4, '4': 3, '5': 12, '10': 'members'},
    {'1': 'admins', '3': 5, '4': 3, '5': 12, '10': 'admins'},
    {'1': 'expirationTimer', '3': 6, '4': 1, '5': 13, '10': 'expirationTimer'},
  ],
};

@$core.Deprecated('Use configurationMessageDescriptor instead')
const ConfigurationMessage_Contact$json = {
  '1': 'Contact',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 2, '5': 12, '10': 'publicKey'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'profilePicture', '3': 3, '4': 1, '5': 9, '10': 'profilePicture'},
    {'1': 'profileKey', '3': 4, '4': 1, '5': 12, '10': 'profileKey'},
    {'1': 'isApproved', '3': 5, '4': 1, '5': 8, '10': 'isApproved'},
    {'1': 'isBlocked', '3': 6, '4': 1, '5': 8, '10': 'isBlocked'},
    {'1': 'didApproveMe', '3': 7, '4': 1, '5': 8, '10': 'didApproveMe'},
  ],
};

/// Descriptor for `ConfigurationMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configurationMessageDescriptor = $convert.base64Decode(
    'ChRDb25maWd1cmF0aW9uTWVzc2FnZRJTCgxjbG9zZWRHcm91cHMYASADKAsyLy5TZXNzaW9uUH'
    'JvdG9zLkNvbmZpZ3VyYXRpb25NZXNzYWdlLkNsb3NlZEdyb3VwUgxjbG9zZWRHcm91cHMSHgoK'
    'b3Blbkdyb3VwcxgCIAMoCVIKb3Blbkdyb3VwcxIgCgtkaXNwbGF5TmFtZRgDIAEoCVILZGlzcG'
    'xheU5hbWUSJgoOcHJvZmlsZVBpY3R1cmUYBCABKAlSDnByb2ZpbGVQaWN0dXJlEh4KCnByb2Zp'
    'bGVLZXkYBSABKAxSCnByb2ZpbGVLZXkSRwoIY29udGFjdHMYBiADKAsyKy5TZXNzaW9uUHJvdG'
    '9zLkNvbmZpZ3VyYXRpb25NZXNzYWdlLkNvbnRhY3RSCGNvbnRhY3RzGuEBCgtDbG9zZWRHcm91'
    'cBIcCglwdWJsaWNLZXkYASABKAxSCXB1YmxpY0tleRISCgRuYW1lGAIgASgJUgRuYW1lEkQKEW'
    'VuY3J5cHRpb25LZXlQYWlyGAMgASgLMhYuU2Vzc2lvblByb3Rvcy5LZXlQYWlyUhFlbmNyeXB0'
    'aW9uS2V5UGFpchIYCgdtZW1iZXJzGAQgAygMUgdtZW1iZXJzEhYKBmFkbWlucxgFIAMoDFIGYW'
    'RtaW5zEigKD2V4cGlyYXRpb25UaW1lchgGIAEoDVIPZXhwaXJhdGlvblRpbWVyGuUBCgdDb250'
    'YWN0EhwKCXB1YmxpY0tleRgBIAIoDFIJcHVibGljS2V5EhIKBG5hbWUYAiACKAlSBG5hbWUSJg'
    'oOcHJvZmlsZVBpY3R1cmUYAyABKAlSDnByb2ZpbGVQaWN0dXJlEh4KCnByb2ZpbGVLZXkYBCAB'
    'KAxSCnByb2ZpbGVLZXkSHgoKaXNBcHByb3ZlZBgFIAEoCFIKaXNBcHByb3ZlZBIcCglpc0Jsb2'
    'NrZWQYBiABKAhSCWlzQmxvY2tlZBIiCgxkaWRBcHByb3ZlTWUYByABKAhSDGRpZEFwcHJvdmVN'
    'ZQ==');

@$core.Deprecated('Use messageRequestResponseDescriptor instead')
const MessageRequestResponse$json = {
  '1': 'MessageRequestResponse',
  '2': [
    {'1': 'isApproved', '3': 1, '4': 2, '5': 8, '10': 'isApproved'},
    {'1': 'profileKey', '3': 2, '4': 1, '5': 12, '10': 'profileKey'},
    {'1': 'profile', '3': 3, '4': 1, '5': 11, '6': '.SessionProtos.DataMessage.LokiProfile', '10': 'profile'},
  ],
};

/// Descriptor for `MessageRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageRequestResponseDescriptor = $convert.base64Decode(
    'ChZNZXNzYWdlUmVxdWVzdFJlc3BvbnNlEh4KCmlzQXBwcm92ZWQYASACKAhSCmlzQXBwcm92ZW'
    'QSHgoKcHJvZmlsZUtleRgCIAEoDFIKcHJvZmlsZUtleRJACgdwcm9maWxlGAMgASgLMiYuU2Vz'
    'c2lvblByb3Rvcy5EYXRhTWVzc2FnZS5Mb2tpUHJvZmlsZVIHcHJvZmlsZQ==');

@$core.Deprecated('Use sharedConfigMessageDescriptor instead')
const SharedConfigMessage$json = {
  '1': 'SharedConfigMessage',
  '2': [
    {'1': 'kind', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.SharedConfigMessage.Kind', '10': 'kind'},
    {'1': 'seqno', '3': 2, '4': 2, '5': 3, '10': 'seqno'},
    {'1': 'data', '3': 3, '4': 2, '5': 12, '10': 'data'},
  ],
  '4': [SharedConfigMessage_Kind$json],
};

@$core.Deprecated('Use sharedConfigMessageDescriptor instead')
const SharedConfigMessage_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'USER_PROFILE', '2': 1},
    {'1': 'CONTACTS', '2': 2},
    {'1': 'CONVO_INFO_VOLATILE', '2': 3},
    {'1': 'GROUPS', '2': 4},
    {'1': 'CLOSED_GROUP_INFO', '2': 5},
    {'1': 'CLOSED_GROUP_MEMBERS', '2': 6},
    {'1': 'ENCRYPTION_KEYS', '2': 7},
  ],
};

/// Descriptor for `SharedConfigMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sharedConfigMessageDescriptor = $convert.base64Decode(
    'ChNTaGFyZWRDb25maWdNZXNzYWdlEjsKBGtpbmQYASACKA4yJy5TZXNzaW9uUHJvdG9zLlNoYX'
    'JlZENvbmZpZ01lc3NhZ2UuS2luZFIEa2luZBIUCgVzZXFubxgCIAIoA1IFc2Vxbm8SEgoEZGF0'
    'YRgDIAIoDFIEZGF0YSKRAQoES2luZBIQCgxVU0VSX1BST0ZJTEUQARIMCghDT05UQUNUUxACEh'
    'cKE0NPTlZPX0lORk9fVk9MQVRJTEUQAxIKCgZHUk9VUFMQBBIVChFDTE9TRURfR1JPVVBfSU5G'
    'TxAFEhgKFENMT1NFRF9HUk9VUF9NRU1CRVJTEAYSEwoPRU5DUllQVElPTl9LRVlTEAc=');

@$core.Deprecated('Use receiptMessageDescriptor instead')
const ReceiptMessage$json = {
  '1': 'ReceiptMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.SessionProtos.ReceiptMessage.Type', '10': 'type'},
    {'1': 'timestamp', '3': 2, '4': 3, '5': 4, '10': 'timestamp'},
  ],
  '4': [ReceiptMessage_Type$json],
};

@$core.Deprecated('Use receiptMessageDescriptor instead')
const ReceiptMessage_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'DELIVERY', '2': 0},
    {'1': 'READ', '2': 1},
  ],
};

/// Descriptor for `ReceiptMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiptMessageDescriptor = $convert.base64Decode(
    'Cg5SZWNlaXB0TWVzc2FnZRI2CgR0eXBlGAEgAigOMiIuU2Vzc2lvblByb3Rvcy5SZWNlaXB0TW'
    'Vzc2FnZS5UeXBlUgR0eXBlEhwKCXRpbWVzdGFtcBgCIAMoBFIJdGltZXN0YW1wIh4KBFR5cGUS'
    'DAoIREVMSVZFUlkQABIICgRSRUFEEAE=');

@$core.Deprecated('Use attachmentPointerDescriptor instead')
const AttachmentPointer$json = {
  '1': 'AttachmentPointer',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 6, '10': 'id'},
    {'1': 'contentType', '3': 2, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'key', '3': 3, '4': 1, '5': 12, '10': 'key'},
    {'1': 'size', '3': 4, '4': 1, '5': 13, '10': 'size'},
    {'1': 'thumbnail', '3': 5, '4': 1, '5': 12, '10': 'thumbnail'},
    {'1': 'digest', '3': 6, '4': 1, '5': 12, '10': 'digest'},
    {'1': 'fileName', '3': 7, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'flags', '3': 8, '4': 1, '5': 13, '10': 'flags'},
    {'1': 'width', '3': 9, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 10, '4': 1, '5': 13, '10': 'height'},
    {'1': 'caption', '3': 11, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'url', '3': 101, '4': 1, '5': 9, '10': 'url'},
  ],
  '4': [AttachmentPointer_Flags$json],
};

@$core.Deprecated('Use attachmentPointerDescriptor instead')
const AttachmentPointer_Flags$json = {
  '1': 'Flags',
  '2': [
    {'1': 'VOICE_MESSAGE', '2': 1},
  ],
};

/// Descriptor for `AttachmentPointer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachmentPointerDescriptor = $convert.base64Decode(
    'ChFBdHRhY2htZW50UG9pbnRlchIOCgJpZBgBIAIoBlICaWQSIAoLY29udGVudFR5cGUYAiABKA'
    'lSC2NvbnRlbnRUeXBlEhAKA2tleRgDIAEoDFIDa2V5EhIKBHNpemUYBCABKA1SBHNpemUSHAoJ'
    'dGh1bWJuYWlsGAUgASgMUgl0aHVtYm5haWwSFgoGZGlnZXN0GAYgASgMUgZkaWdlc3QSGgoIZm'
    'lsZU5hbWUYByABKAlSCGZpbGVOYW1lEhQKBWZsYWdzGAggASgNUgVmbGFncxIUCgV3aWR0aBgJ'
    'IAEoDVIFd2lkdGgSFgoGaGVpZ2h0GAogASgNUgZoZWlnaHQSGAoHY2FwdGlvbhgLIAEoCVIHY2'
    'FwdGlvbhIQCgN1cmwYZSABKAlSA3VybCIaCgVGbGFncxIRCg1WT0lDRV9NRVNTQUdFEAE=');

