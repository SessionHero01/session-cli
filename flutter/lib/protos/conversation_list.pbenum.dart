//
//  Generated code. Do not modify.
//  source: protos/conversation_list.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ConversationType extends $pb.ProtobufEnum {
  static const ConversationType GROUP = ConversationType._(0, _omitEnumNames ? '' : 'GROUP');
  static const ConversationType COMMUNITY = ConversationType._(1, _omitEnumNames ? '' : 'COMMUNITY');
  static const ConversationType ONE_TO_ONE = ConversationType._(2, _omitEnumNames ? '' : 'ONE_TO_ONE');
  static const ConversationType NOTE_TO_SELF = ConversationType._(3, _omitEnumNames ? '' : 'NOTE_TO_SELF');

  static const $core.List<ConversationType> values = <ConversationType> [
    GROUP,
    COMMUNITY,
    ONE_TO_ONE,
    NOTE_TO_SELF,
  ];

  static final $core.Map<$core.int, ConversationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConversationType? valueOf($core.int value) => _byValue[value];

  const ConversationType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
