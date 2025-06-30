//
//  Generated code. Do not modify.
//  source: protos/message.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use messageDeleteStateDescriptor instead')
const MessageDeleteState$json = {
  '1': 'MessageDeleteState',
  '2': [
    {'1': 'DELETED_LOCALLY', '2': 1},
    {'1': 'DELETED', '2': 2},
  ],
};

/// Descriptor for `MessageDeleteState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageDeleteStateDescriptor = $convert.base64Decode(
    'ChJNZXNzYWdlRGVsZXRlU3RhdGUSEwoPREVMRVRFRF9MT0NBTExZEAESCwoHREVMRVRFRBAC');

@$core.Deprecated('Use messageStateDescriptor instead')
const MessageState$json = {
  '1': 'MessageState',
  '2': [
    {'1': 'SENDING', '2': 1},
    {'1': 'SENT', '2': 2},
    {'1': 'FAILED', '2': 3},
    {'1': 'READ', '2': 4},
  ],
};

/// Descriptor for `MessageState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageStateDescriptor = $convert.base64Decode(
    'CgxNZXNzYWdlU3RhdGUSCwoHU0VORElORxABEggKBFNFTlQQAhIKCgZGQUlMRUQQAxIICgRSRU'
    'FEEAQ=');

@$core.Deprecated('Use userNameDescriptor instead')
const UserName$json = {
  '1': 'UserName',
  '2': [
    {'1': 'me', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'me'},
    {'1': 'other', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'other'},
  ],
  '8': [
    {'1': 'name'},
  ],
};

/// Descriptor for `UserName`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userNameDescriptor = $convert.base64Decode(
    'CghVc2VyTmFtZRIoCgJtZRgBIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5FbXB0eUgAUgJtZRIWCg'
    'VvdGhlchgCIAEoCUgAUgVvdGhlckIGCgRuYW1l');

@$core.Deprecated('Use attachmentContentDescriptor instead')
const AttachmentContent$json = {
  '1': 'AttachmentContent',
  '2': [
    {'1': 'file', '3': 1, '4': 1, '5': 11, '6': '.SessionApp.EncryptedFile', '9': 0, '10': 'file'},
    {'1': 'pending_attachment_id', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'pendingAttachmentId'},
    {'1': 'community_file', '3': 3, '4': 1, '5': 11, '6': '.SessionApp.CommunityFile', '9': 0, '10': 'communityFile'},
  ],
  '8': [
    {'1': 'content'},
  ],
};

/// Descriptor for `AttachmentContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachmentContentDescriptor = $convert.base64Decode(
    'ChFBdHRhY2htZW50Q29udGVudBIvCgRmaWxlGAEgASgLMhkuU2Vzc2lvbkFwcC5FbmNyeXB0ZW'
    'RGaWxlSABSBGZpbGUSNAoVcGVuZGluZ19hdHRhY2htZW50X2lkGAIgASgDSABSE3BlbmRpbmdB'
    'dHRhY2htZW50SWQSQgoOY29tbXVuaXR5X2ZpbGUYAyABKAsyGS5TZXNzaW9uQXBwLkNvbW11bm'
    'l0eUZpbGVIAFINY29tbXVuaXR5RmlsZUIJCgdjb250ZW50');

@$core.Deprecated('Use audioAttachmentDescriptor instead')
const AudioAttachment$json = {
  '1': 'AudioAttachment',
  '2': [
    {'1': 'content', '3': 1, '4': 2, '5': 11, '6': '.SessionApp.AttachmentContent', '10': 'content'},
    {'1': 'duration_mills', '3': 3, '4': 2, '5': 4, '10': 'durationMills'},
  ],
};

/// Descriptor for `AudioAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioAttachmentDescriptor = $convert.base64Decode(
    'Cg9BdWRpb0F0dGFjaG1lbnQSNwoHY29udGVudBgBIAIoCzIdLlNlc3Npb25BcHAuQXR0YWNobW'
    'VudENvbnRlbnRSB2NvbnRlbnQSJQoOZHVyYXRpb25fbWlsbHMYAyACKARSDWR1cmF0aW9uTWls'
    'bHM=');

@$core.Deprecated('Use imageAttachmentDescriptor instead')
const ImageAttachment$json = {
  '1': 'ImageAttachment',
  '2': [
    {'1': 'content', '3': 1, '4': 2, '5': 11, '6': '.SessionApp.AttachmentContent', '10': 'content'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 13, '10': 'height'},
    {'1': 'thumbnail', '3': 5, '4': 1, '5': 12, '10': 'thumbnail'},
  ],
};

/// Descriptor for `ImageAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageAttachmentDescriptor = $convert.base64Decode(
    'Cg9JbWFnZUF0dGFjaG1lbnQSNwoHY29udGVudBgBIAIoCzIdLlNlc3Npb25BcHAuQXR0YWNobW'
    'VudENvbnRlbnRSB2NvbnRlbnQSFAoFd2lkdGgYAyABKA1SBXdpZHRoEhYKBmhlaWdodBgEIAEo'
    'DVIGaGVpZ2h0EhwKCXRodW1ibmFpbBgFIAEoDFIJdGh1bWJuYWls');

@$core.Deprecated('Use imageAttachmentsDescriptor instead')
const ImageAttachments$json = {
  '1': 'ImageAttachments',
  '2': [
    {'1': 'images', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.ImageAttachment', '10': 'images'},
  ],
};

/// Descriptor for `ImageAttachments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageAttachmentsDescriptor = $convert.base64Decode(
    'ChBJbWFnZUF0dGFjaG1lbnRzEjMKBmltYWdlcxgBIAMoCzIbLlNlc3Npb25BcHAuSW1hZ2VBdH'
    'RhY2htZW50UgZpbWFnZXM=');

@$core.Deprecated('Use videoAttachmentDescriptor instead')
const VideoAttachment$json = {
  '1': 'VideoAttachment',
  '2': [
    {'1': 'content', '3': 1, '4': 2, '5': 11, '6': '.SessionApp.AttachmentContent', '10': 'content'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 13, '10': 'height'},
    {'1': 'duration_mills', '3': 5, '4': 1, '5': 4, '10': 'durationMills'},
    {'1': 'thumbnail', '3': 6, '4': 1, '5': 12, '10': 'thumbnail'},
  ],
};

/// Descriptor for `VideoAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoAttachmentDescriptor = $convert.base64Decode(
    'Cg9WaWRlb0F0dGFjaG1lbnQSNwoHY29udGVudBgBIAIoCzIdLlNlc3Npb25BcHAuQXR0YWNobW'
    'VudENvbnRlbnRSB2NvbnRlbnQSFAoFd2lkdGgYAyABKA1SBXdpZHRoEhYKBmhlaWdodBgEIAEo'
    'DVIGaGVpZ2h0EiUKDmR1cmF0aW9uX21pbGxzGAUgASgEUg1kdXJhdGlvbk1pbGxzEhwKCXRodW'
    '1ibmFpbBgGIAEoDFIJdGh1bWJuYWls');

@$core.Deprecated('Use videoAttachmentsDescriptor instead')
const VideoAttachments$json = {
  '1': 'VideoAttachments',
  '2': [
    {'1': 'videos', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.VideoAttachment', '10': 'videos'},
  ],
};

/// Descriptor for `VideoAttachments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoAttachmentsDescriptor = $convert.base64Decode(
    'ChBWaWRlb0F0dGFjaG1lbnRzEjMKBnZpZGVvcxgBIAMoCzIbLlNlc3Npb25BcHAuVmlkZW9BdH'
    'RhY2htZW50UgZ2aWRlb3M=');

@$core.Deprecated('Use fileAttachmentDescriptor instead')
const FileAttachment$json = {
  '1': 'FileAttachment',
  '2': [
    {'1': 'content', '3': 1, '4': 2, '5': 11, '6': '.SessionApp.AttachmentContent', '10': 'content'},
    {'1': 'file_name', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'size', '3': 4, '4': 1, '5': 13, '10': 'size'},
    {'1': 'thumbnail', '3': 5, '4': 1, '5': 12, '10': 'thumbnail'},
    {'1': 'content_type', '3': 6, '4': 1, '5': 9, '10': 'contentType'},
  ],
};

/// Descriptor for `FileAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileAttachmentDescriptor = $convert.base64Decode(
    'Cg5GaWxlQXR0YWNobWVudBI3Cgdjb250ZW50GAEgAigLMh0uU2Vzc2lvbkFwcC5BdHRhY2htZW'
    '50Q29udGVudFIHY29udGVudBIbCglmaWxlX25hbWUYAyABKAlSCGZpbGVOYW1lEhIKBHNpemUY'
    'BCABKA1SBHNpemUSHAoJdGh1bWJuYWlsGAUgASgMUgl0aHVtYm5haWwSIQoMY29udGVudF90eX'
    'BlGAYgASgJUgtjb250ZW50VHlwZQ==');

@$core.Deprecated('Use fileAttachmentsDescriptor instead')
const FileAttachments$json = {
  '1': 'FileAttachments',
  '2': [
    {'1': 'files', '3': 1, '4': 3, '5': 11, '6': '.SessionApp.FileAttachment', '10': 'files'},
  ],
};

/// Descriptor for `FileAttachments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileAttachmentsDescriptor = $convert.base64Decode(
    'Cg9GaWxlQXR0YWNobWVudHMSMAoFZmlsZXMYASADKAsyGi5TZXNzaW9uQXBwLkZpbGVBdHRhY2'
    'htZW50UgVmaWxlcw==');

@$core.Deprecated('Use messageContentDescriptor instead')
const MessageContent$json = {
  '1': 'MessageContent',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'text'},
    {'1': 'voice', '3': 2, '4': 1, '5': 11, '6': '.SessionApp.AudioAttachment', '9': 0, '10': 'voice'},
    {'1': 'images', '3': 3, '4': 1, '5': 11, '6': '.SessionApp.ImageAttachments', '9': 0, '10': 'images'},
    {'1': 'videos', '3': 4, '4': 1, '5': 11, '6': '.SessionApp.VideoAttachments', '9': 0, '10': 'videos'},
    {'1': 'files', '3': 5, '4': 1, '5': 11, '6': '.SessionApp.FileAttachments', '9': 0, '10': 'files'},
    {'1': 'full', '3': 6, '4': 1, '5': 11, '6': '.SessionApp.MessageContent.Full', '9': 0, '10': 'full'},
    {'1': 'deleted', '3': 7, '4': 1, '5': 14, '6': '.SessionApp.MessageDeleteState', '9': 0, '10': 'deleted'},
    {'1': 'mentions', '3': 10, '4': 3, '5': 11, '6': '.SessionApp.MessageContent.MentionsEntry', '10': 'mentions'},
  ],
  '3': [MessageContent_Full$json, MessageContent_MentionsEntry$json],
  '8': [
    {'1': 'content'},
  ],
};

@$core.Deprecated('Use messageContentDescriptor instead')
const MessageContent_Full$json = {
  '1': 'Full',
  '2': [
    {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
    {'1': 'images', '3': 3, '4': 1, '5': 11, '6': '.SessionApp.ImageAttachments', '9': 0, '10': 'images'},
    {'1': 'videos', '3': 4, '4': 1, '5': 11, '6': '.SessionApp.VideoAttachments', '9': 0, '10': 'videos'},
    {'1': 'files', '3': 5, '4': 1, '5': 11, '6': '.SessionApp.FileAttachments', '9': 0, '10': 'files'},
  ],
  '8': [
    {'1': 'attachments'},
  ],
};

@$core.Deprecated('Use messageContentDescriptor instead')
const MessageContent_MentionsEntry$json = {
  '1': 'MentionsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.SessionApp.UserName', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MessageContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageContentDescriptor = $convert.base64Decode(
    'Cg5NZXNzYWdlQ29udGVudBIUCgR0ZXh0GAEgASgJSABSBHRleHQSMwoFdm9pY2UYAiABKAsyGy'
    '5TZXNzaW9uQXBwLkF1ZGlvQXR0YWNobWVudEgAUgV2b2ljZRI2CgZpbWFnZXMYAyABKAsyHC5T'
    'ZXNzaW9uQXBwLkltYWdlQXR0YWNobWVudHNIAFIGaW1hZ2VzEjYKBnZpZGVvcxgEIAEoCzIcLl'
    'Nlc3Npb25BcHAuVmlkZW9BdHRhY2htZW50c0gAUgZ2aWRlb3MSMwoFZmlsZXMYBSABKAsyGy5T'
    'ZXNzaW9uQXBwLkZpbGVBdHRhY2htZW50c0gAUgVmaWxlcxI1CgRmdWxsGAYgASgLMh8uU2Vzc2'
    'lvbkFwcC5NZXNzYWdlQ29udGVudC5GdWxsSABSBGZ1bGwSOgoHZGVsZXRlZBgHIAEoDjIeLlNl'
    'c3Npb25BcHAuTWVzc2FnZURlbGV0ZVN0YXRlSABSB2RlbGV0ZWQSRAoIbWVudGlvbnMYCiADKA'
    'syKC5TZXNzaW9uQXBwLk1lc3NhZ2VDb250ZW50Lk1lbnRpb25zRW50cnlSCG1lbnRpb25zGs4B'
    'CgRGdWxsEhIKBHRleHQYASACKAlSBHRleHQSNgoGaW1hZ2VzGAMgASgLMhwuU2Vzc2lvbkFwcC'
    '5JbWFnZUF0dGFjaG1lbnRzSABSBmltYWdlcxI2CgZ2aWRlb3MYBCABKAsyHC5TZXNzaW9uQXBw'
    'LlZpZGVvQXR0YWNobWVudHNIAFIGdmlkZW9zEjMKBWZpbGVzGAUgASgLMhsuU2Vzc2lvbkFwcC'
    '5GaWxlQXR0YWNobWVudHNIAFIFZmlsZXNCDQoLYXR0YWNobWVudHMaUQoNTWVudGlvbnNFbnRy'
    'eRIQCgNrZXkYASABKAlSA2tleRIqCgV2YWx1ZRgCIAEoCzIULlNlc3Npb25BcHAuVXNlck5hbW'
    'VSBXZhbHVlOgI4AUIJCgdjb250ZW50');

@$core.Deprecated('Use quotedMessageDescriptor instead')
const QuotedMessage$json = {
  '1': 'QuotedMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'author', '3': 2, '4': 2, '5': 9, '10': 'author'},
    {'1': 'content', '3': 3, '4': 2, '5': 11, '6': '.SessionApp.MessageContent', '10': 'content'},
  ],
};

/// Descriptor for `QuotedMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quotedMessageDescriptor = $convert.base64Decode(
    'Cg1RdW90ZWRNZXNzYWdlEg4KAmlkGAEgAigJUgJpZBIWCgZhdXRob3IYAiACKAlSBmF1dGhvch'
    'I0Cgdjb250ZW50GAMgAigLMhouU2Vzc2lvbkFwcC5NZXNzYWdlQ29udGVudFIHY29udGVudA==');

@$core.Deprecated('Use messageReactionDescriptor instead')
const MessageReaction$json = {
  '1': 'MessageReaction',
  '2': [
    {'1': 'emoji', '3': 1, '4': 2, '5': 9, '10': 'emoji'},
    {'1': 'count', '3': 2, '4': 2, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `MessageReaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageReactionDescriptor = $convert.base64Decode(
    'Cg9NZXNzYWdlUmVhY3Rpb24SFAoFZW1vamkYASACKAlSBWVtb2ppEhQKBWNvdW50GAIgAigNUg'
    'Vjb3VudA==');

@$core.Deprecated('Use regularMessageDescriptor instead')
const RegularMessage$json = {
  '1': 'RegularMessage',
  '2': [
    {'1': 'author_id', '3': 2, '4': 2, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 3, '4': 2, '5': 11, '6': '.SessionApp.UserName', '10': 'authorName'},
    {'1': 'author_avatar', '3': 4, '4': 2, '5': 11, '6': '.SessionApp.Avatar', '10': 'authorAvatar'},
    {'1': 'content', '3': 7, '4': 2, '5': 11, '6': '.SessionApp.MessageContent', '10': 'content'},
    {'1': 'quoted_message', '3': 9, '4': 1, '5': 11, '6': '.SessionApp.QuotedMessage', '10': 'quotedMessage'},
    {'1': 'state', '3': 11, '4': 1, '5': 14, '6': '.SessionApp.MessageState', '10': 'state'},
  ],
};

/// Descriptor for `RegularMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List regularMessageDescriptor = $convert.base64Decode(
    'Cg5SZWd1bGFyTWVzc2FnZRIbCglhdXRob3JfaWQYAiACKAlSCGF1dGhvcklkEjUKC2F1dGhvcl'
    '9uYW1lGAMgAigLMhQuU2Vzc2lvbkFwcC5Vc2VyTmFtZVIKYXV0aG9yTmFtZRI3Cg1hdXRob3Jf'
    'YXZhdGFyGAQgAigLMhIuU2Vzc2lvbkFwcC5BdmF0YXJSDGF1dGhvckF2YXRhchI0Cgdjb250ZW'
    '50GAcgAigLMhouU2Vzc2lvbkFwcC5NZXNzYWdlQ29udGVudFIHY29udGVudBJACg5xdW90ZWRf'
    'bWVzc2FnZRgJIAEoCzIZLlNlc3Npb25BcHAuUXVvdGVkTWVzc2FnZVINcXVvdGVkTWVzc2FnZR'
    'IuCgVzdGF0ZRgLIAEoDjIYLlNlc3Npb25BcHAuTWVzc2FnZVN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 2, '5': 4, '10': 'createdAt'},
    {'1': 'reactions', '3': 3, '4': 3, '5': 11, '6': '.SessionApp.MessageReaction', '10': 'reactions'},
    {'1': 'regular', '3': 10, '4': 1, '5': 11, '6': '.SessionApp.RegularMessage', '9': 0, '10': 'regular'},
    {'1': 'control', '3': 20, '4': 1, '5': 11, '6': '.SessionApp.ControlMessage', '9': 0, '10': 'control'},
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgAigJUgJpZBIdCgpjcmVhdGVkX2F0GAIgAigEUgljcmVhdGVkQX'
    'QSOQoJcmVhY3Rpb25zGAMgAygLMhsuU2Vzc2lvbkFwcC5NZXNzYWdlUmVhY3Rpb25SCXJlYWN0'
    'aW9ucxI2CgdyZWd1bGFyGAogASgLMhouU2Vzc2lvbkFwcC5SZWd1bGFyTWVzc2FnZUgAUgdyZW'
    'd1bGFyEjYKB2NvbnRyb2wYFCABKAsyGi5TZXNzaW9uQXBwLkNvbnRyb2xNZXNzYWdlSABSB2Nv'
    'bnRyb2xCBgoEYm9keQ==');

