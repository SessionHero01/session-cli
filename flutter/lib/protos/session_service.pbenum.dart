//
//  Generated code. Do not modify.
//  source: protos/session_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Envelope_Type extends $pb.ProtobufEnum {
  static const Envelope_Type SESSION_MESSAGE = Envelope_Type._(6, _omitEnumNames ? '' : 'SESSION_MESSAGE');
  static const Envelope_Type CLOSED_GROUP_MESSAGE = Envelope_Type._(7, _omitEnumNames ? '' : 'CLOSED_GROUP_MESSAGE');

  static const $core.List<Envelope_Type> values = <Envelope_Type> [
    SESSION_MESSAGE,
    CLOSED_GROUP_MESSAGE,
  ];

  static final $core.Map<$core.int, Envelope_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Envelope_Type? valueOf($core.int value) => _byValue[value];

  const Envelope_Type._($core.int v, $core.String n) : super(v, n);
}

class TypingMessage_Action extends $pb.ProtobufEnum {
  static const TypingMessage_Action STARTED = TypingMessage_Action._(0, _omitEnumNames ? '' : 'STARTED');
  static const TypingMessage_Action STOPPED = TypingMessage_Action._(1, _omitEnumNames ? '' : 'STOPPED');

  static const $core.List<TypingMessage_Action> values = <TypingMessage_Action> [
    STARTED,
    STOPPED,
  ];

  static final $core.Map<$core.int, TypingMessage_Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TypingMessage_Action? valueOf($core.int value) => _byValue[value];

  const TypingMessage_Action._($core.int v, $core.String n) : super(v, n);
}

class Content_ExpirationType extends $pb.ProtobufEnum {
  static const Content_ExpirationType UNKNOWN = Content_ExpirationType._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const Content_ExpirationType DELETE_AFTER_READ = Content_ExpirationType._(1, _omitEnumNames ? '' : 'DELETE_AFTER_READ');
  static const Content_ExpirationType DELETE_AFTER_SEND = Content_ExpirationType._(2, _omitEnumNames ? '' : 'DELETE_AFTER_SEND');

  static const $core.List<Content_ExpirationType> values = <Content_ExpirationType> [
    UNKNOWN,
    DELETE_AFTER_READ,
    DELETE_AFTER_SEND,
  ];

  static final $core.Map<$core.int, Content_ExpirationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Content_ExpirationType? valueOf($core.int value) => _byValue[value];

  const Content_ExpirationType._($core.int v, $core.String n) : super(v, n);
}

class DataExtractionNotification_Type extends $pb.ProtobufEnum {
  static const DataExtractionNotification_Type SCREENSHOT = DataExtractionNotification_Type._(1, _omitEnumNames ? '' : 'SCREENSHOT');
  static const DataExtractionNotification_Type MEDIA_SAVED = DataExtractionNotification_Type._(2, _omitEnumNames ? '' : 'MEDIA_SAVED');

  static const $core.List<DataExtractionNotification_Type> values = <DataExtractionNotification_Type> [
    SCREENSHOT,
    MEDIA_SAVED,
  ];

  static final $core.Map<$core.int, DataExtractionNotification_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataExtractionNotification_Type? valueOf($core.int value) => _byValue[value];

  const DataExtractionNotification_Type._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_Flags extends $pb.ProtobufEnum {
  static const DataMessage_Flags EXPIRATION_TIMER_UPDATE = DataMessage_Flags._(2, _omitEnumNames ? '' : 'EXPIRATION_TIMER_UPDATE');

  static const $core.List<DataMessage_Flags> values = <DataMessage_Flags> [
    EXPIRATION_TIMER_UPDATE,
  ];

  static final $core.Map<$core.int, DataMessage_Flags> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_Flags? valueOf($core.int value) => _byValue[value];

  const DataMessage_Flags._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_Quote_QuotedAttachment_Flags extends $pb.ProtobufEnum {
  static const DataMessage_Quote_QuotedAttachment_Flags VOICE_MESSAGE = DataMessage_Quote_QuotedAttachment_Flags._(1, _omitEnumNames ? '' : 'VOICE_MESSAGE');

  static const $core.List<DataMessage_Quote_QuotedAttachment_Flags> values = <DataMessage_Quote_QuotedAttachment_Flags> [
    VOICE_MESSAGE,
  ];

  static final $core.Map<$core.int, DataMessage_Quote_QuotedAttachment_Flags> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_Quote_QuotedAttachment_Flags? valueOf($core.int value) => _byValue[value];

  const DataMessage_Quote_QuotedAttachment_Flags._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_GroupUpdateInfoChangeMessage_Type extends $pb.ProtobufEnum {
  static const DataMessage_GroupUpdateInfoChangeMessage_Type NAME = DataMessage_GroupUpdateInfoChangeMessage_Type._(1, _omitEnumNames ? '' : 'NAME');
  static const DataMessage_GroupUpdateInfoChangeMessage_Type AVATAR = DataMessage_GroupUpdateInfoChangeMessage_Type._(2, _omitEnumNames ? '' : 'AVATAR');
  static const DataMessage_GroupUpdateInfoChangeMessage_Type DISAPPEARING_MESSAGES = DataMessage_GroupUpdateInfoChangeMessage_Type._(3, _omitEnumNames ? '' : 'DISAPPEARING_MESSAGES');

  static const $core.List<DataMessage_GroupUpdateInfoChangeMessage_Type> values = <DataMessage_GroupUpdateInfoChangeMessage_Type> [
    NAME,
    AVATAR,
    DISAPPEARING_MESSAGES,
  ];

  static final $core.Map<$core.int, DataMessage_GroupUpdateInfoChangeMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_GroupUpdateInfoChangeMessage_Type? valueOf($core.int value) => _byValue[value];

  const DataMessage_GroupUpdateInfoChangeMessage_Type._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_GroupUpdateMemberChangeMessage_Type extends $pb.ProtobufEnum {
  static const DataMessage_GroupUpdateMemberChangeMessage_Type ADDED = DataMessage_GroupUpdateMemberChangeMessage_Type._(1, _omitEnumNames ? '' : 'ADDED');
  static const DataMessage_GroupUpdateMemberChangeMessage_Type REMOVED = DataMessage_GroupUpdateMemberChangeMessage_Type._(2, _omitEnumNames ? '' : 'REMOVED');
  static const DataMessage_GroupUpdateMemberChangeMessage_Type PROMOTED = DataMessage_GroupUpdateMemberChangeMessage_Type._(3, _omitEnumNames ? '' : 'PROMOTED');

  static const $core.List<DataMessage_GroupUpdateMemberChangeMessage_Type> values = <DataMessage_GroupUpdateMemberChangeMessage_Type> [
    ADDED,
    REMOVED,
    PROMOTED,
  ];

  static final $core.Map<$core.int, DataMessage_GroupUpdateMemberChangeMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_GroupUpdateMemberChangeMessage_Type? valueOf($core.int value) => _byValue[value];

  const DataMessage_GroupUpdateMemberChangeMessage_Type._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_ClosedGroupControlMessage_Type extends $pb.ProtobufEnum {
  static const DataMessage_ClosedGroupControlMessage_Type NEW = DataMessage_ClosedGroupControlMessage_Type._(1, _omitEnumNames ? '' : 'NEW');
  static const DataMessage_ClosedGroupControlMessage_Type ENCRYPTION_KEY_PAIR = DataMessage_ClosedGroupControlMessage_Type._(3, _omitEnumNames ? '' : 'ENCRYPTION_KEY_PAIR');
  static const DataMessage_ClosedGroupControlMessage_Type NAME_CHANGE = DataMessage_ClosedGroupControlMessage_Type._(4, _omitEnumNames ? '' : 'NAME_CHANGE');
  static const DataMessage_ClosedGroupControlMessage_Type MEMBERS_ADDED = DataMessage_ClosedGroupControlMessage_Type._(5, _omitEnumNames ? '' : 'MEMBERS_ADDED');
  static const DataMessage_ClosedGroupControlMessage_Type MEMBERS_REMOVED = DataMessage_ClosedGroupControlMessage_Type._(6, _omitEnumNames ? '' : 'MEMBERS_REMOVED');
  static const DataMessage_ClosedGroupControlMessage_Type MEMBER_LEFT = DataMessage_ClosedGroupControlMessage_Type._(7, _omitEnumNames ? '' : 'MEMBER_LEFT');
  static const DataMessage_ClosedGroupControlMessage_Type INVITE = DataMessage_ClosedGroupControlMessage_Type._(9, _omitEnumNames ? '' : 'INVITE');
  static const DataMessage_ClosedGroupControlMessage_Type PROMOTE = DataMessage_ClosedGroupControlMessage_Type._(10, _omitEnumNames ? '' : 'PROMOTE');
  static const DataMessage_ClosedGroupControlMessage_Type DELETE_GROUP = DataMessage_ClosedGroupControlMessage_Type._(11, _omitEnumNames ? '' : 'DELETE_GROUP');
  static const DataMessage_ClosedGroupControlMessage_Type DELETE_MESSAGES = DataMessage_ClosedGroupControlMessage_Type._(12, _omitEnumNames ? '' : 'DELETE_MESSAGES');
  static const DataMessage_ClosedGroupControlMessage_Type DELETE_ATTACHMENTS = DataMessage_ClosedGroupControlMessage_Type._(13, _omitEnumNames ? '' : 'DELETE_ATTACHMENTS');

  static const $core.List<DataMessage_ClosedGroupControlMessage_Type> values = <DataMessage_ClosedGroupControlMessage_Type> [
    NEW,
    ENCRYPTION_KEY_PAIR,
    NAME_CHANGE,
    MEMBERS_ADDED,
    MEMBERS_REMOVED,
    MEMBER_LEFT,
    INVITE,
    PROMOTE,
    DELETE_GROUP,
    DELETE_MESSAGES,
    DELETE_ATTACHMENTS,
  ];

  static final $core.Map<$core.int, DataMessage_ClosedGroupControlMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_ClosedGroupControlMessage_Type? valueOf($core.int value) => _byValue[value];

  const DataMessage_ClosedGroupControlMessage_Type._($core.int v, $core.String n) : super(v, n);
}

class DataMessage_Reaction_Action extends $pb.ProtobufEnum {
  static const DataMessage_Reaction_Action REACT = DataMessage_Reaction_Action._(0, _omitEnumNames ? '' : 'REACT');
  static const DataMessage_Reaction_Action REMOVE = DataMessage_Reaction_Action._(1, _omitEnumNames ? '' : 'REMOVE');

  static const $core.List<DataMessage_Reaction_Action> values = <DataMessage_Reaction_Action> [
    REACT,
    REMOVE,
  ];

  static final $core.Map<$core.int, DataMessage_Reaction_Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DataMessage_Reaction_Action? valueOf($core.int value) => _byValue[value];

  const DataMessage_Reaction_Action._($core.int v, $core.String n) : super(v, n);
}

class CallMessage_Type extends $pb.ProtobufEnum {
  static const CallMessage_Type PRE_OFFER = CallMessage_Type._(6, _omitEnumNames ? '' : 'PRE_OFFER');
  static const CallMessage_Type OFFER = CallMessage_Type._(1, _omitEnumNames ? '' : 'OFFER');
  static const CallMessage_Type ANSWER = CallMessage_Type._(2, _omitEnumNames ? '' : 'ANSWER');
  static const CallMessage_Type PROVISIONAL_ANSWER = CallMessage_Type._(3, _omitEnumNames ? '' : 'PROVISIONAL_ANSWER');
  static const CallMessage_Type ICE_CANDIDATES = CallMessage_Type._(4, _omitEnumNames ? '' : 'ICE_CANDIDATES');
  static const CallMessage_Type END_CALL = CallMessage_Type._(5, _omitEnumNames ? '' : 'END_CALL');

  static const $core.List<CallMessage_Type> values = <CallMessage_Type> [
    PRE_OFFER,
    OFFER,
    ANSWER,
    PROVISIONAL_ANSWER,
    ICE_CANDIDATES,
    END_CALL,
  ];

  static final $core.Map<$core.int, CallMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CallMessage_Type? valueOf($core.int value) => _byValue[value];

  const CallMessage_Type._($core.int v, $core.String n) : super(v, n);
}

class SharedConfigMessage_Kind extends $pb.ProtobufEnum {
  static const SharedConfigMessage_Kind USER_PROFILE = SharedConfigMessage_Kind._(1, _omitEnumNames ? '' : 'USER_PROFILE');
  static const SharedConfigMessage_Kind CONTACTS = SharedConfigMessage_Kind._(2, _omitEnumNames ? '' : 'CONTACTS');
  static const SharedConfigMessage_Kind CONVO_INFO_VOLATILE = SharedConfigMessage_Kind._(3, _omitEnumNames ? '' : 'CONVO_INFO_VOLATILE');
  static const SharedConfigMessage_Kind GROUPS = SharedConfigMessage_Kind._(4, _omitEnumNames ? '' : 'GROUPS');
  static const SharedConfigMessage_Kind CLOSED_GROUP_INFO = SharedConfigMessage_Kind._(5, _omitEnumNames ? '' : 'CLOSED_GROUP_INFO');
  static const SharedConfigMessage_Kind CLOSED_GROUP_MEMBERS = SharedConfigMessage_Kind._(6, _omitEnumNames ? '' : 'CLOSED_GROUP_MEMBERS');
  static const SharedConfigMessage_Kind ENCRYPTION_KEYS = SharedConfigMessage_Kind._(7, _omitEnumNames ? '' : 'ENCRYPTION_KEYS');

  static const $core.List<SharedConfigMessage_Kind> values = <SharedConfigMessage_Kind> [
    USER_PROFILE,
    CONTACTS,
    CONVO_INFO_VOLATILE,
    GROUPS,
    CLOSED_GROUP_INFO,
    CLOSED_GROUP_MEMBERS,
    ENCRYPTION_KEYS,
  ];

  static final $core.Map<$core.int, SharedConfigMessage_Kind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SharedConfigMessage_Kind? valueOf($core.int value) => _byValue[value];

  const SharedConfigMessage_Kind._($core.int v, $core.String n) : super(v, n);
}

class ReceiptMessage_Type extends $pb.ProtobufEnum {
  static const ReceiptMessage_Type DELIVERY = ReceiptMessage_Type._(0, _omitEnumNames ? '' : 'DELIVERY');
  static const ReceiptMessage_Type READ = ReceiptMessage_Type._(1, _omitEnumNames ? '' : 'READ');

  static const $core.List<ReceiptMessage_Type> values = <ReceiptMessage_Type> [
    DELIVERY,
    READ,
  ];

  static final $core.Map<$core.int, ReceiptMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReceiptMessage_Type? valueOf($core.int value) => _byValue[value];

  const ReceiptMessage_Type._($core.int v, $core.String n) : super(v, n);
}

class AttachmentPointer_Flags extends $pb.ProtobufEnum {
  static const AttachmentPointer_Flags VOICE_MESSAGE = AttachmentPointer_Flags._(1, _omitEnumNames ? '' : 'VOICE_MESSAGE');

  static const $core.List<AttachmentPointer_Flags> values = <AttachmentPointer_Flags> [
    VOICE_MESSAGE,
  ];

  static final $core.Map<$core.int, AttachmentPointer_Flags> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AttachmentPointer_Flags? valueOf($core.int value) => _byValue[value];

  const AttachmentPointer_Flags._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
