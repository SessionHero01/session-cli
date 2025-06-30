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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'session_websocket_resource.pbenum.dart';

export 'session_websocket_resource.pbenum.dart';

class WebSocketRequestMessage extends $pb.GeneratedMessage {
  factory WebSocketRequestMessage({
    $core.String? verb,
    $core.String? path,
    $core.List<$core.int>? body,
    $fixnum.Int64? id,
    $core.Iterable<$core.String>? headers,
  }) {
    final $result = create();
    if (verb != null) {
      $result.verb = verb;
    }
    if (path != null) {
      $result.path = path;
    }
    if (body != null) {
      $result.body = body;
    }
    if (id != null) {
      $result.id = id;
    }
    if (headers != null) {
      $result.headers.addAll(headers);
    }
    return $result;
  }
  WebSocketRequestMessage._() : super();
  factory WebSocketRequestMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebSocketRequestMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WebSocketRequestMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'WebSocketProtos'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'verb')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'body', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(5, _omitFieldNames ? '' : 'headers')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebSocketRequestMessage clone() => WebSocketRequestMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebSocketRequestMessage copyWith(void Function(WebSocketRequestMessage) updates) => super.copyWith((message) => updates(message as WebSocketRequestMessage)) as WebSocketRequestMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebSocketRequestMessage create() => WebSocketRequestMessage._();
  WebSocketRequestMessage createEmptyInstance() => create();
  static $pb.PbList<WebSocketRequestMessage> createRepeated() => $pb.PbList<WebSocketRequestMessage>();
  @$core.pragma('dart2js:noInline')
  static WebSocketRequestMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebSocketRequestMessage>(create);
  static WebSocketRequestMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get verb => $_getSZ(0);
  @$pb.TagNumber(1)
  set verb($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVerb() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerb() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get body => $_getN(2);
  @$pb.TagNumber(3)
  set body($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get id => $_getI64(3);
  @$pb.TagNumber(4)
  set id($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get headers => $_getList(4);
}

class WebSocketResponseMessage extends $pb.GeneratedMessage {
  factory WebSocketResponseMessage({
    $fixnum.Int64? id,
    $core.int? status,
    $core.String? message,
    $core.List<$core.int>? body,
    $core.Iterable<$core.String>? headers,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (status != null) {
      $result.status = status;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body = body;
    }
    if (headers != null) {
      $result.headers.addAll(headers);
    }
    return $result;
  }
  WebSocketResponseMessage._() : super();
  factory WebSocketResponseMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebSocketResponseMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WebSocketResponseMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'WebSocketProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'body', $pb.PbFieldType.OY)
    ..pPS(5, _omitFieldNames ? '' : 'headers')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebSocketResponseMessage clone() => WebSocketResponseMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebSocketResponseMessage copyWith(void Function(WebSocketResponseMessage) updates) => super.copyWith((message) => updates(message as WebSocketResponseMessage)) as WebSocketResponseMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebSocketResponseMessage create() => WebSocketResponseMessage._();
  WebSocketResponseMessage createEmptyInstance() => create();
  static $pb.PbList<WebSocketResponseMessage> createRepeated() => $pb.PbList<WebSocketResponseMessage>();
  @$core.pragma('dart2js:noInline')
  static WebSocketResponseMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebSocketResponseMessage>(create);
  static WebSocketResponseMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get body => $_getN(3);
  @$pb.TagNumber(4)
  set body($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBody() => $_has(3);
  @$pb.TagNumber(4)
  void clearBody() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get headers => $_getList(4);
}

class WebSocketMessage extends $pb.GeneratedMessage {
  factory WebSocketMessage({
    WebSocketMessage_Type? type,
    WebSocketRequestMessage? request,
    WebSocketResponseMessage? response,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (request != null) {
      $result.request = request;
    }
    if (response != null) {
      $result.response = response;
    }
    return $result;
  }
  WebSocketMessage._() : super();
  factory WebSocketMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WebSocketMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WebSocketMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'WebSocketProtos'), createEmptyInstance: create)
    ..e<WebSocketMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: WebSocketMessage_Type.UNKNOWN, valueOf: WebSocketMessage_Type.valueOf, enumValues: WebSocketMessage_Type.values)
    ..aOM<WebSocketRequestMessage>(2, _omitFieldNames ? '' : 'request', subBuilder: WebSocketRequestMessage.create)
    ..aOM<WebSocketResponseMessage>(3, _omitFieldNames ? '' : 'response', subBuilder: WebSocketResponseMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WebSocketMessage clone() => WebSocketMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WebSocketMessage copyWith(void Function(WebSocketMessage) updates) => super.copyWith((message) => updates(message as WebSocketMessage)) as WebSocketMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebSocketMessage create() => WebSocketMessage._();
  WebSocketMessage createEmptyInstance() => create();
  static $pb.PbList<WebSocketMessage> createRepeated() => $pb.PbList<WebSocketMessage>();
  @$core.pragma('dart2js:noInline')
  static WebSocketMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WebSocketMessage>(create);
  static WebSocketMessage? _defaultInstance;

  @$pb.TagNumber(1)
  WebSocketMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(WebSocketMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  WebSocketRequestMessage get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(WebSocketRequestMessage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => clearField(2);
  @$pb.TagNumber(2)
  WebSocketRequestMessage ensureRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  WebSocketResponseMessage get response => $_getN(2);
  @$pb.TagNumber(3)
  set response(WebSocketResponseMessage v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponse() => clearField(3);
  @$pb.TagNumber(3)
  WebSocketResponseMessage ensureResponse() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
