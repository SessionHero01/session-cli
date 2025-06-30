//
//  Generated code. Do not modify.
//  source: protos/session_websocket_resource.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class WebSocketMessage_Type extends $pb.ProtobufEnum {
  static const WebSocketMessage_Type UNKNOWN = WebSocketMessage_Type._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const WebSocketMessage_Type REQUEST = WebSocketMessage_Type._(1, _omitEnumNames ? '' : 'REQUEST');
  static const WebSocketMessage_Type RESPONSE = WebSocketMessage_Type._(2, _omitEnumNames ? '' : 'RESPONSE');

  static const $core.List<WebSocketMessage_Type> values = <WebSocketMessage_Type> [
    UNKNOWN,
    REQUEST,
    RESPONSE,
  ];

  static final $core.Map<$core.int, WebSocketMessage_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WebSocketMessage_Type? valueOf($core.int value) => _byValue[value];

  const WebSocketMessage_Type._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
