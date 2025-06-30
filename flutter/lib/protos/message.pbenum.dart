//
//  Generated code. Do not modify.
//  source: protos/message.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MessageDeleteState extends $pb.ProtobufEnum {
  static const MessageDeleteState DELETED_LOCALLY = MessageDeleteState._(1, _omitEnumNames ? '' : 'DELETED_LOCALLY');
  static const MessageDeleteState DELETED = MessageDeleteState._(2, _omitEnumNames ? '' : 'DELETED');

  static const $core.List<MessageDeleteState> values = <MessageDeleteState> [
    DELETED_LOCALLY,
    DELETED,
  ];

  static final $core.Map<$core.int, MessageDeleteState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageDeleteState? valueOf($core.int value) => _byValue[value];

  const MessageDeleteState._($core.int v, $core.String n) : super(v, n);
}

class MessageState extends $pb.ProtobufEnum {
  static const MessageState SENDING = MessageState._(1, _omitEnumNames ? '' : 'SENDING');
  static const MessageState SENT = MessageState._(2, _omitEnumNames ? '' : 'SENT');
  static const MessageState FAILED = MessageState._(3, _omitEnumNames ? '' : 'FAILED');
  static const MessageState READ = MessageState._(4, _omitEnumNames ? '' : 'READ');

  static const $core.List<MessageState> values = <MessageState> [
    SENDING,
    SENT,
    FAILED,
    READ,
  ];

  static final $core.Map<$core.int, MessageState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageState? valueOf($core.int value) => _byValue[value];

  const MessageState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
