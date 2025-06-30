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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'session_service.pbenum.dart';

export 'session_service.pbenum.dart';

class Envelope extends $pb.GeneratedMessage {
  factory Envelope({
    Envelope_Type? type,
    $core.String? source,
    $fixnum.Int64? timestamp,
    $core.int? sourceDevice,
    $core.List<$core.int>? content,
    $fixnum.Int64? serverTimestamp,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (source != null) {
      $result.source = source;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (sourceDevice != null) {
      $result.sourceDevice = sourceDevice;
    }
    if (content != null) {
      $result.content = content;
    }
    if (serverTimestamp != null) {
      $result.serverTimestamp = serverTimestamp;
    }
    return $result;
  }
  Envelope._() : super();
  factory Envelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Envelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Envelope', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<Envelope_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: Envelope_Type.SESSION_MESSAGE, valueOf: Envelope_Type.valueOf, enumValues: Envelope_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'sourceDevice', $pb.PbFieldType.OU3, protoName: 'sourceDevice')
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(10, _omitFieldNames ? '' : 'serverTimestamp', $pb.PbFieldType.OU6, protoName: 'serverTimestamp', defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Envelope clone() => Envelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Envelope copyWith(void Function(Envelope) updates) => super.copyWith((message) => updates(message as Envelope)) as Envelope;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Envelope create() => Envelope._();
  Envelope createEmptyInstance() => create();
  static $pb.PbList<Envelope> createRepeated() => $pb.PbList<Envelope>();
  @$core.pragma('dart2js:noInline')
  static Envelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Envelope>(create);
  static Envelope? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  Envelope_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Envelope_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => clearField(2);

  /// @required
  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);

  @$pb.TagNumber(7)
  $core.int get sourceDevice => $_getIZ(3);
  @$pb.TagNumber(7)
  set sourceDevice($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(7)
  $core.bool hasSourceDevice() => $_has(3);
  @$pb.TagNumber(7)
  void clearSourceDevice() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get content => $_getN(4);
  @$pb.TagNumber(8)
  set content($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(8)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(8)
  void clearContent() => clearField(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get serverTimestamp => $_getI64(5);
  @$pb.TagNumber(10)
  set serverTimestamp($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(10)
  $core.bool hasServerTimestamp() => $_has(5);
  @$pb.TagNumber(10)
  void clearServerTimestamp() => clearField(10);
}

class TypingMessage extends $pb.GeneratedMessage {
  factory TypingMessage({
    $fixnum.Int64? timestamp,
    TypingMessage_Action? action,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (action != null) {
      $result.action = action;
    }
    return $result;
  }
  TypingMessage._() : super();
  factory TypingMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TypingMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TypingMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<TypingMessage_Action>(2, _omitFieldNames ? '' : 'action', $pb.PbFieldType.QE, defaultOrMaker: TypingMessage_Action.STARTED, valueOf: TypingMessage_Action.valueOf, enumValues: TypingMessage_Action.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TypingMessage clone() => TypingMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TypingMessage copyWith(void Function(TypingMessage) updates) => super.copyWith((message) => updates(message as TypingMessage)) as TypingMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TypingMessage create() => TypingMessage._();
  TypingMessage createEmptyInstance() => create();
  static $pb.PbList<TypingMessage> createRepeated() => $pb.PbList<TypingMessage>();
  @$core.pragma('dart2js:noInline')
  static TypingMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TypingMessage>(create);
  static TypingMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  TypingMessage_Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(TypingMessage_Action v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);
}

class UnsendRequest extends $pb.GeneratedMessage {
  factory UnsendRequest({
    $fixnum.Int64? timestamp,
    $core.String? author,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (author != null) {
      $result.author = author;
    }
    return $result;
  }
  UnsendRequest._() : super();
  factory UnsendRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnsendRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnsendRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'author')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnsendRequest clone() => UnsendRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnsendRequest copyWith(void Function(UnsendRequest) updates) => super.copyWith((message) => updates(message as UnsendRequest)) as UnsendRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnsendRequest create() => UnsendRequest._();
  UnsendRequest createEmptyInstance() => create();
  static $pb.PbList<UnsendRequest> createRepeated() => $pb.PbList<UnsendRequest>();
  @$core.pragma('dart2js:noInline')
  static UnsendRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnsendRequest>(create);
  static UnsendRequest? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);
}

class Content extends $pb.GeneratedMessage {
  factory Content({
    DataMessage? dataMessage,
    CallMessage? callMessage,
    ReceiptMessage? receiptMessage,
    TypingMessage? typingMessage,
    ConfigurationMessage? configurationMessage,
    DataExtractionNotification? dataExtractionNotification,
    UnsendRequest? unsendRequest,
    MessageRequestResponse? messageRequestResponse,
    SharedConfigMessage? sharedConfigMessage,
    Content_ExpirationType? expirationType,
    $core.int? expirationTimer,
    $fixnum.Int64? lastDisappearingMessageChangeTimestamp,
  }) {
    final $result = create();
    if (dataMessage != null) {
      $result.dataMessage = dataMessage;
    }
    if (callMessage != null) {
      $result.callMessage = callMessage;
    }
    if (receiptMessage != null) {
      $result.receiptMessage = receiptMessage;
    }
    if (typingMessage != null) {
      $result.typingMessage = typingMessage;
    }
    if (configurationMessage != null) {
      $result.configurationMessage = configurationMessage;
    }
    if (dataExtractionNotification != null) {
      $result.dataExtractionNotification = dataExtractionNotification;
    }
    if (unsendRequest != null) {
      $result.unsendRequest = unsendRequest;
    }
    if (messageRequestResponse != null) {
      $result.messageRequestResponse = messageRequestResponse;
    }
    if (sharedConfigMessage != null) {
      $result.sharedConfigMessage = sharedConfigMessage;
    }
    if (expirationType != null) {
      $result.expirationType = expirationType;
    }
    if (expirationTimer != null) {
      $result.expirationTimer = expirationTimer;
    }
    if (lastDisappearingMessageChangeTimestamp != null) {
      $result.lastDisappearingMessageChangeTimestamp = lastDisappearingMessageChangeTimestamp;
    }
    return $result;
  }
  Content._() : super();
  factory Content.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Content.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Content', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aOM<DataMessage>(1, _omitFieldNames ? '' : 'dataMessage', protoName: 'dataMessage', subBuilder: DataMessage.create)
    ..aOM<CallMessage>(3, _omitFieldNames ? '' : 'callMessage', protoName: 'callMessage', subBuilder: CallMessage.create)
    ..aOM<ReceiptMessage>(5, _omitFieldNames ? '' : 'receiptMessage', protoName: 'receiptMessage', subBuilder: ReceiptMessage.create)
    ..aOM<TypingMessage>(6, _omitFieldNames ? '' : 'typingMessage', protoName: 'typingMessage', subBuilder: TypingMessage.create)
    ..aOM<ConfigurationMessage>(7, _omitFieldNames ? '' : 'configurationMessage', protoName: 'configurationMessage', subBuilder: ConfigurationMessage.create)
    ..aOM<DataExtractionNotification>(8, _omitFieldNames ? '' : 'dataExtractionNotification', protoName: 'dataExtractionNotification', subBuilder: DataExtractionNotification.create)
    ..aOM<UnsendRequest>(9, _omitFieldNames ? '' : 'unsendRequest', protoName: 'unsendRequest', subBuilder: UnsendRequest.create)
    ..aOM<MessageRequestResponse>(10, _omitFieldNames ? '' : 'messageRequestResponse', protoName: 'messageRequestResponse', subBuilder: MessageRequestResponse.create)
    ..aOM<SharedConfigMessage>(11, _omitFieldNames ? '' : 'sharedConfigMessage', protoName: 'sharedConfigMessage', subBuilder: SharedConfigMessage.create)
    ..e<Content_ExpirationType>(12, _omitFieldNames ? '' : 'expirationType', $pb.PbFieldType.OE, protoName: 'expirationType', defaultOrMaker: Content_ExpirationType.UNKNOWN, valueOf: Content_ExpirationType.valueOf, enumValues: Content_ExpirationType.values)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'expirationTimer', $pb.PbFieldType.OU3, protoName: 'expirationTimer')
    ..a<$fixnum.Int64>(14, _omitFieldNames ? '' : 'lastDisappearingMessageChangeTimestamp', $pb.PbFieldType.OU6, protoName: 'lastDisappearingMessageChangeTimestamp', defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Content clone() => Content()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Content copyWith(void Function(Content) updates) => super.copyWith((message) => updates(message as Content)) as Content;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Content create() => Content._();
  Content createEmptyInstance() => create();
  static $pb.PbList<Content> createRepeated() => $pb.PbList<Content>();
  @$core.pragma('dart2js:noInline')
  static Content getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Content>(create);
  static Content? _defaultInstance;

  @$pb.TagNumber(1)
  DataMessage get dataMessage => $_getN(0);
  @$pb.TagNumber(1)
  set dataMessage(DataMessage v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDataMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearDataMessage() => clearField(1);
  @$pb.TagNumber(1)
  DataMessage ensureDataMessage() => $_ensure(0);

  @$pb.TagNumber(3)
  CallMessage get callMessage => $_getN(1);
  @$pb.TagNumber(3)
  set callMessage(CallMessage v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCallMessage() => $_has(1);
  @$pb.TagNumber(3)
  void clearCallMessage() => clearField(3);
  @$pb.TagNumber(3)
  CallMessage ensureCallMessage() => $_ensure(1);

  @$pb.TagNumber(5)
  ReceiptMessage get receiptMessage => $_getN(2);
  @$pb.TagNumber(5)
  set receiptMessage(ReceiptMessage v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasReceiptMessage() => $_has(2);
  @$pb.TagNumber(5)
  void clearReceiptMessage() => clearField(5);
  @$pb.TagNumber(5)
  ReceiptMessage ensureReceiptMessage() => $_ensure(2);

  @$pb.TagNumber(6)
  TypingMessage get typingMessage => $_getN(3);
  @$pb.TagNumber(6)
  set typingMessage(TypingMessage v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTypingMessage() => $_has(3);
  @$pb.TagNumber(6)
  void clearTypingMessage() => clearField(6);
  @$pb.TagNumber(6)
  TypingMessage ensureTypingMessage() => $_ensure(3);

  @$pb.TagNumber(7)
  ConfigurationMessage get configurationMessage => $_getN(4);
  @$pb.TagNumber(7)
  set configurationMessage(ConfigurationMessage v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasConfigurationMessage() => $_has(4);
  @$pb.TagNumber(7)
  void clearConfigurationMessage() => clearField(7);
  @$pb.TagNumber(7)
  ConfigurationMessage ensureConfigurationMessage() => $_ensure(4);

  @$pb.TagNumber(8)
  DataExtractionNotification get dataExtractionNotification => $_getN(5);
  @$pb.TagNumber(8)
  set dataExtractionNotification(DataExtractionNotification v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasDataExtractionNotification() => $_has(5);
  @$pb.TagNumber(8)
  void clearDataExtractionNotification() => clearField(8);
  @$pb.TagNumber(8)
  DataExtractionNotification ensureDataExtractionNotification() => $_ensure(5);

  @$pb.TagNumber(9)
  UnsendRequest get unsendRequest => $_getN(6);
  @$pb.TagNumber(9)
  set unsendRequest(UnsendRequest v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasUnsendRequest() => $_has(6);
  @$pb.TagNumber(9)
  void clearUnsendRequest() => clearField(9);
  @$pb.TagNumber(9)
  UnsendRequest ensureUnsendRequest() => $_ensure(6);

  @$pb.TagNumber(10)
  MessageRequestResponse get messageRequestResponse => $_getN(7);
  @$pb.TagNumber(10)
  set messageRequestResponse(MessageRequestResponse v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasMessageRequestResponse() => $_has(7);
  @$pb.TagNumber(10)
  void clearMessageRequestResponse() => clearField(10);
  @$pb.TagNumber(10)
  MessageRequestResponse ensureMessageRequestResponse() => $_ensure(7);

  @$pb.TagNumber(11)
  SharedConfigMessage get sharedConfigMessage => $_getN(8);
  @$pb.TagNumber(11)
  set sharedConfigMessage(SharedConfigMessage v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasSharedConfigMessage() => $_has(8);
  @$pb.TagNumber(11)
  void clearSharedConfigMessage() => clearField(11);
  @$pb.TagNumber(11)
  SharedConfigMessage ensureSharedConfigMessage() => $_ensure(8);

  @$pb.TagNumber(12)
  Content_ExpirationType get expirationType => $_getN(9);
  @$pb.TagNumber(12)
  set expirationType(Content_ExpirationType v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasExpirationType() => $_has(9);
  @$pb.TagNumber(12)
  void clearExpirationType() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get expirationTimer => $_getIZ(10);
  @$pb.TagNumber(13)
  set expirationTimer($core.int v) { $_setUnsignedInt32(10, v); }
  @$pb.TagNumber(13)
  $core.bool hasExpirationTimer() => $_has(10);
  @$pb.TagNumber(13)
  void clearExpirationTimer() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get lastDisappearingMessageChangeTimestamp => $_getI64(11);
  @$pb.TagNumber(14)
  set lastDisappearingMessageChangeTimestamp($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(14)
  $core.bool hasLastDisappearingMessageChangeTimestamp() => $_has(11);
  @$pb.TagNumber(14)
  void clearLastDisappearingMessageChangeTimestamp() => clearField(14);
}

class KeyPair extends $pb.GeneratedMessage {
  factory KeyPair({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? privateKey,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (privateKey != null) {
      $result.privateKey = privateKey;
    }
    return $result;
  }
  KeyPair._() : super();
  factory KeyPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KeyPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KeyPair', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'privateKey', $pb.PbFieldType.QY, protoName: 'privateKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KeyPair clone() => KeyPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KeyPair copyWith(void Function(KeyPair) updates) => super.copyWith((message) => updates(message as KeyPair)) as KeyPair;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyPair create() => KeyPair._();
  KeyPair createEmptyInstance() => create();
  static $pb.PbList<KeyPair> createRepeated() => $pb.PbList<KeyPair>();
  @$core.pragma('dart2js:noInline')
  static KeyPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KeyPair>(create);
  static KeyPair? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.List<$core.int> get privateKey => $_getN(1);
  @$pb.TagNumber(2)
  set privateKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrivateKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivateKey() => clearField(2);
}

class DataExtractionNotification extends $pb.GeneratedMessage {
  factory DataExtractionNotification({
    DataExtractionNotification_Type? type,
    $fixnum.Int64? timestamp,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  DataExtractionNotification._() : super();
  factory DataExtractionNotification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataExtractionNotification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataExtractionNotification', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<DataExtractionNotification_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: DataExtractionNotification_Type.SCREENSHOT, valueOf: DataExtractionNotification_Type.valueOf, enumValues: DataExtractionNotification_Type.values)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataExtractionNotification clone() => DataExtractionNotification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataExtractionNotification copyWith(void Function(DataExtractionNotification) updates) => super.copyWith((message) => updates(message as DataExtractionNotification)) as DataExtractionNotification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataExtractionNotification create() => DataExtractionNotification._();
  DataExtractionNotification createEmptyInstance() => create();
  static $pb.PbList<DataExtractionNotification> createRepeated() => $pb.PbList<DataExtractionNotification>();
  @$core.pragma('dart2js:noInline')
  static DataExtractionNotification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataExtractionNotification>(create);
  static DataExtractionNotification? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  DataExtractionNotification_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DataExtractionNotification_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);
}

class DataMessage_Quote_QuotedAttachment extends $pb.GeneratedMessage {
  factory DataMessage_Quote_QuotedAttachment({
    $core.String? contentType,
    $core.String? fileName,
    AttachmentPointer? thumbnail,
    $core.int? flags,
  }) {
    final $result = create();
    if (contentType != null) {
      $result.contentType = contentType;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (thumbnail != null) {
      $result.thumbnail = thumbnail;
    }
    if (flags != null) {
      $result.flags = flags;
    }
    return $result;
  }
  DataMessage_Quote_QuotedAttachment._() : super();
  factory DataMessage_Quote_QuotedAttachment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_Quote_QuotedAttachment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.Quote.QuotedAttachment', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..aOS(2, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..aOM<AttachmentPointer>(3, _omitFieldNames ? '' : 'thumbnail', subBuilder: AttachmentPointer.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'flags', $pb.PbFieldType.OU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_Quote_QuotedAttachment clone() => DataMessage_Quote_QuotedAttachment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_Quote_QuotedAttachment copyWith(void Function(DataMessage_Quote_QuotedAttachment) updates) => super.copyWith((message) => updates(message as DataMessage_Quote_QuotedAttachment)) as DataMessage_Quote_QuotedAttachment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_Quote_QuotedAttachment create() => DataMessage_Quote_QuotedAttachment._();
  DataMessage_Quote_QuotedAttachment createEmptyInstance() => create();
  static $pb.PbList<DataMessage_Quote_QuotedAttachment> createRepeated() => $pb.PbList<DataMessage_Quote_QuotedAttachment>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_Quote_QuotedAttachment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_Quote_QuotedAttachment>(create);
  static DataMessage_Quote_QuotedAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contentType => $_getSZ(0);
  @$pb.TagNumber(1)
  set contentType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContentType() => $_has(0);
  @$pb.TagNumber(1)
  void clearContentType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileName() => clearField(2);

  @$pb.TagNumber(3)
  AttachmentPointer get thumbnail => $_getN(2);
  @$pb.TagNumber(3)
  set thumbnail(AttachmentPointer v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasThumbnail() => $_has(2);
  @$pb.TagNumber(3)
  void clearThumbnail() => clearField(3);
  @$pb.TagNumber(3)
  AttachmentPointer ensureThumbnail() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get flags => $_getIZ(3);
  @$pb.TagNumber(4)
  set flags($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFlags() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlags() => clearField(4);
}

class DataMessage_Quote extends $pb.GeneratedMessage {
  factory DataMessage_Quote({
    $fixnum.Int64? id,
    $core.String? author,
    $core.String? text,
    $core.Iterable<DataMessage_Quote_QuotedAttachment>? attachments,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (author != null) {
      $result.author = author;
    }
    if (text != null) {
      $result.text = text;
    }
    if (attachments != null) {
      $result.attachments.addAll(attachments);
    }
    return $result;
  }
  DataMessage_Quote._() : super();
  factory DataMessage_Quote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_Quote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.Quote', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'author')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..pc<DataMessage_Quote_QuotedAttachment>(4, _omitFieldNames ? '' : 'attachments', $pb.PbFieldType.PM, subBuilder: DataMessage_Quote_QuotedAttachment.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_Quote clone() => DataMessage_Quote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_Quote copyWith(void Function(DataMessage_Quote) updates) => super.copyWith((message) => updates(message as DataMessage_Quote)) as DataMessage_Quote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_Quote create() => DataMessage_Quote._();
  DataMessage_Quote createEmptyInstance() => create();
  static $pb.PbList<DataMessage_Quote> createRepeated() => $pb.PbList<DataMessage_Quote>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_Quote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_Quote>(create);
  static DataMessage_Quote? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<DataMessage_Quote_QuotedAttachment> get attachments => $_getList(3);
}

class DataMessage_Preview extends $pb.GeneratedMessage {
  factory DataMessage_Preview({
    $core.String? url,
    $core.String? title,
    AttachmentPointer? image,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (title != null) {
      $result.title = title;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  DataMessage_Preview._() : super();
  factory DataMessage_Preview.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_Preview.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.Preview', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<AttachmentPointer>(3, _omitFieldNames ? '' : 'image', subBuilder: AttachmentPointer.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_Preview clone() => DataMessage_Preview()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_Preview copyWith(void Function(DataMessage_Preview) updates) => super.copyWith((message) => updates(message as DataMessage_Preview)) as DataMessage_Preview;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_Preview create() => DataMessage_Preview._();
  DataMessage_Preview createEmptyInstance() => create();
  static $pb.PbList<DataMessage_Preview> createRepeated() => $pb.PbList<DataMessage_Preview>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_Preview getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_Preview>(create);
  static DataMessage_Preview? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  AttachmentPointer get image => $_getN(2);
  @$pb.TagNumber(3)
  set image(AttachmentPointer v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => clearField(3);
  @$pb.TagNumber(3)
  AttachmentPointer ensureImage() => $_ensure(2);
}

class DataMessage_LokiProfile extends $pb.GeneratedMessage {
  factory DataMessage_LokiProfile({
    $core.String? displayName,
    $core.String? profilePicture,
  }) {
    final $result = create();
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (profilePicture != null) {
      $result.profilePicture = profilePicture;
    }
    return $result;
  }
  DataMessage_LokiProfile._() : super();
  factory DataMessage_LokiProfile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_LokiProfile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.LokiProfile', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(2, _omitFieldNames ? '' : 'profilePicture', protoName: 'profilePicture')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_LokiProfile clone() => DataMessage_LokiProfile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_LokiProfile copyWith(void Function(DataMessage_LokiProfile) updates) => super.copyWith((message) => updates(message as DataMessage_LokiProfile)) as DataMessage_LokiProfile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_LokiProfile create() => DataMessage_LokiProfile._();
  DataMessage_LokiProfile createEmptyInstance() => create();
  static $pb.PbList<DataMessage_LokiProfile> createRepeated() => $pb.PbList<DataMessage_LokiProfile>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_LokiProfile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_LokiProfile>(create);
  static DataMessage_LokiProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get displayName => $_getSZ(0);
  @$pb.TagNumber(1)
  set displayName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDisplayName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get profilePicture => $_getSZ(1);
  @$pb.TagNumber(2)
  set profilePicture($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfilePicture() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfilePicture() => clearField(2);
}

class DataMessage_OpenGroupInvitation extends $pb.GeneratedMessage {
  factory DataMessage_OpenGroupInvitation({
    $core.String? url,
    $core.String? name,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  DataMessage_OpenGroupInvitation._() : super();
  factory DataMessage_OpenGroupInvitation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_OpenGroupInvitation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.OpenGroupInvitation', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'url')
    ..aQS(3, _omitFieldNames ? '' : 'name')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_OpenGroupInvitation clone() => DataMessage_OpenGroupInvitation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_OpenGroupInvitation copyWith(void Function(DataMessage_OpenGroupInvitation) updates) => super.copyWith((message) => updates(message as DataMessage_OpenGroupInvitation)) as DataMessage_OpenGroupInvitation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_OpenGroupInvitation create() => DataMessage_OpenGroupInvitation._();
  DataMessage_OpenGroupInvitation createEmptyInstance() => create();
  static $pb.PbList<DataMessage_OpenGroupInvitation> createRepeated() => $pb.PbList<DataMessage_OpenGroupInvitation>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_OpenGroupInvitation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_OpenGroupInvitation>(create);
  static DataMessage_OpenGroupInvitation? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  /// @required
  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);
}

/// New closed group update messages
class DataMessage_GroupUpdateMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateMessage({
    DataMessage_GroupUpdateInviteMessage? inviteMessage,
    DataMessage_GroupUpdateInfoChangeMessage? infoChangeMessage,
    DataMessage_GroupUpdateMemberChangeMessage? memberChangeMessage,
    DataMessage_GroupUpdatePromoteMessage? promoteMessage,
    DataMessage_GroupUpdateMemberLeftMessage? memberLeftMessage,
    DataMessage_GroupUpdateInviteResponseMessage? inviteResponse,
    DataMessage_GroupUpdateDeleteMemberContentMessage? deleteMemberContent,
    DataMessage_GroupUpdateMemberLeftNotificationMessage? memberLeftNotificationMessage,
  }) {
    final $result = create();
    if (inviteMessage != null) {
      $result.inviteMessage = inviteMessage;
    }
    if (infoChangeMessage != null) {
      $result.infoChangeMessage = infoChangeMessage;
    }
    if (memberChangeMessage != null) {
      $result.memberChangeMessage = memberChangeMessage;
    }
    if (promoteMessage != null) {
      $result.promoteMessage = promoteMessage;
    }
    if (memberLeftMessage != null) {
      $result.memberLeftMessage = memberLeftMessage;
    }
    if (inviteResponse != null) {
      $result.inviteResponse = inviteResponse;
    }
    if (deleteMemberContent != null) {
      $result.deleteMemberContent = deleteMemberContent;
    }
    if (memberLeftNotificationMessage != null) {
      $result.memberLeftNotificationMessage = memberLeftNotificationMessage;
    }
    return $result;
  }
  DataMessage_GroupUpdateMessage._() : super();
  factory DataMessage_GroupUpdateMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aOM<DataMessage_GroupUpdateInviteMessage>(1, _omitFieldNames ? '' : 'inviteMessage', protoName: 'inviteMessage', subBuilder: DataMessage_GroupUpdateInviteMessage.create)
    ..aOM<DataMessage_GroupUpdateInfoChangeMessage>(2, _omitFieldNames ? '' : 'infoChangeMessage', protoName: 'infoChangeMessage', subBuilder: DataMessage_GroupUpdateInfoChangeMessage.create)
    ..aOM<DataMessage_GroupUpdateMemberChangeMessage>(3, _omitFieldNames ? '' : 'memberChangeMessage', protoName: 'memberChangeMessage', subBuilder: DataMessage_GroupUpdateMemberChangeMessage.create)
    ..aOM<DataMessage_GroupUpdatePromoteMessage>(4, _omitFieldNames ? '' : 'promoteMessage', protoName: 'promoteMessage', subBuilder: DataMessage_GroupUpdatePromoteMessage.create)
    ..aOM<DataMessage_GroupUpdateMemberLeftMessage>(5, _omitFieldNames ? '' : 'memberLeftMessage', protoName: 'memberLeftMessage', subBuilder: DataMessage_GroupUpdateMemberLeftMessage.create)
    ..aOM<DataMessage_GroupUpdateInviteResponseMessage>(6, _omitFieldNames ? '' : 'inviteResponse', protoName: 'inviteResponse', subBuilder: DataMessage_GroupUpdateInviteResponseMessage.create)
    ..aOM<DataMessage_GroupUpdateDeleteMemberContentMessage>(7, _omitFieldNames ? '' : 'deleteMemberContent', protoName: 'deleteMemberContent', subBuilder: DataMessage_GroupUpdateDeleteMemberContentMessage.create)
    ..aOM<DataMessage_GroupUpdateMemberLeftNotificationMessage>(8, _omitFieldNames ? '' : 'memberLeftNotificationMessage', protoName: 'memberLeftNotificationMessage', subBuilder: DataMessage_GroupUpdateMemberLeftNotificationMessage.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMessage clone() => DataMessage_GroupUpdateMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMessage copyWith(void Function(DataMessage_GroupUpdateMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateMessage)) as DataMessage_GroupUpdateMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMessage create() => DataMessage_GroupUpdateMessage._();
  DataMessage_GroupUpdateMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateMessage>(create);
  static DataMessage_GroupUpdateMessage? _defaultInstance;

  @$pb.TagNumber(1)
  DataMessage_GroupUpdateInviteMessage get inviteMessage => $_getN(0);
  @$pb.TagNumber(1)
  set inviteMessage(DataMessage_GroupUpdateInviteMessage v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInviteMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearInviteMessage() => clearField(1);
  @$pb.TagNumber(1)
  DataMessage_GroupUpdateInviteMessage ensureInviteMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  DataMessage_GroupUpdateInfoChangeMessage get infoChangeMessage => $_getN(1);
  @$pb.TagNumber(2)
  set infoChangeMessage(DataMessage_GroupUpdateInfoChangeMessage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasInfoChangeMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearInfoChangeMessage() => clearField(2);
  @$pb.TagNumber(2)
  DataMessage_GroupUpdateInfoChangeMessage ensureInfoChangeMessage() => $_ensure(1);

  @$pb.TagNumber(3)
  DataMessage_GroupUpdateMemberChangeMessage get memberChangeMessage => $_getN(2);
  @$pb.TagNumber(3)
  set memberChangeMessage(DataMessage_GroupUpdateMemberChangeMessage v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMemberChangeMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemberChangeMessage() => clearField(3);
  @$pb.TagNumber(3)
  DataMessage_GroupUpdateMemberChangeMessage ensureMemberChangeMessage() => $_ensure(2);

  @$pb.TagNumber(4)
  DataMessage_GroupUpdatePromoteMessage get promoteMessage => $_getN(3);
  @$pb.TagNumber(4)
  set promoteMessage(DataMessage_GroupUpdatePromoteMessage v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPromoteMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPromoteMessage() => clearField(4);
  @$pb.TagNumber(4)
  DataMessage_GroupUpdatePromoteMessage ensurePromoteMessage() => $_ensure(3);

  @$pb.TagNumber(5)
  DataMessage_GroupUpdateMemberLeftMessage get memberLeftMessage => $_getN(4);
  @$pb.TagNumber(5)
  set memberLeftMessage(DataMessage_GroupUpdateMemberLeftMessage v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMemberLeftMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMemberLeftMessage() => clearField(5);
  @$pb.TagNumber(5)
  DataMessage_GroupUpdateMemberLeftMessage ensureMemberLeftMessage() => $_ensure(4);

  @$pb.TagNumber(6)
  DataMessage_GroupUpdateInviteResponseMessage get inviteResponse => $_getN(5);
  @$pb.TagNumber(6)
  set inviteResponse(DataMessage_GroupUpdateInviteResponseMessage v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasInviteResponse() => $_has(5);
  @$pb.TagNumber(6)
  void clearInviteResponse() => clearField(6);
  @$pb.TagNumber(6)
  DataMessage_GroupUpdateInviteResponseMessage ensureInviteResponse() => $_ensure(5);

  @$pb.TagNumber(7)
  DataMessage_GroupUpdateDeleteMemberContentMessage get deleteMemberContent => $_getN(6);
  @$pb.TagNumber(7)
  set deleteMemberContent(DataMessage_GroupUpdateDeleteMemberContentMessage v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasDeleteMemberContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeleteMemberContent() => clearField(7);
  @$pb.TagNumber(7)
  DataMessage_GroupUpdateDeleteMemberContentMessage ensureDeleteMemberContent() => $_ensure(6);

  @$pb.TagNumber(8)
  DataMessage_GroupUpdateMemberLeftNotificationMessage get memberLeftNotificationMessage => $_getN(7);
  @$pb.TagNumber(8)
  set memberLeftNotificationMessage(DataMessage_GroupUpdateMemberLeftNotificationMessage v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasMemberLeftNotificationMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMemberLeftNotificationMessage() => clearField(8);
  @$pb.TagNumber(8)
  DataMessage_GroupUpdateMemberLeftNotificationMessage ensureMemberLeftNotificationMessage() => $_ensure(7);
}

/// New closed groups
class DataMessage_GroupUpdateInviteMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateInviteMessage({
    $core.String? groupSessionId,
    $core.String? name,
    $core.List<$core.int>? memberAuthData,
    $core.List<$core.int>? adminSignature,
  }) {
    final $result = create();
    if (groupSessionId != null) {
      $result.groupSessionId = groupSessionId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (memberAuthData != null) {
      $result.memberAuthData = memberAuthData;
    }
    if (adminSignature != null) {
      $result.adminSignature = adminSignature;
    }
    return $result;
  }
  DataMessage_GroupUpdateInviteMessage._() : super();
  factory DataMessage_GroupUpdateInviteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateInviteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateInviteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'groupSessionId', protoName: 'groupSessionId')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'memberAuthData', $pb.PbFieldType.QY, protoName: 'memberAuthData')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'adminSignature', $pb.PbFieldType.QY, protoName: 'adminSignature')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInviteMessage clone() => DataMessage_GroupUpdateInviteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInviteMessage copyWith(void Function(DataMessage_GroupUpdateInviteMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateInviteMessage)) as DataMessage_GroupUpdateInviteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInviteMessage create() => DataMessage_GroupUpdateInviteMessage._();
  DataMessage_GroupUpdateInviteMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateInviteMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateInviteMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInviteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateInviteMessage>(create);
  static DataMessage_GroupUpdateInviteMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.String get groupSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupSessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupSessionId() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  /// @required
  @$pb.TagNumber(3)
  $core.List<$core.int> get memberAuthData => $_getN(2);
  @$pb.TagNumber(3)
  set memberAuthData($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMemberAuthData() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemberAuthData() => clearField(3);

  /// @required
  @$pb.TagNumber(4)
  $core.List<$core.int> get adminSignature => $_getN(3);
  @$pb.TagNumber(4)
  set adminSignature($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAdminSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdminSignature() => clearField(4);
}

class DataMessage_GroupUpdateDeleteMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateDeleteMessage({
    $core.Iterable<$core.String>? memberSessionIds,
    $core.List<$core.int>? adminSignature,
  }) {
    final $result = create();
    if (memberSessionIds != null) {
      $result.memberSessionIds.addAll(memberSessionIds);
    }
    if (adminSignature != null) {
      $result.adminSignature = adminSignature;
    }
    return $result;
  }
  DataMessage_GroupUpdateDeleteMessage._() : super();
  factory DataMessage_GroupUpdateDeleteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateDeleteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateDeleteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'memberSessionIds', protoName: 'memberSessionIds')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'adminSignature', $pb.PbFieldType.QY, protoName: 'adminSignature')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateDeleteMessage clone() => DataMessage_GroupUpdateDeleteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateDeleteMessage copyWith(void Function(DataMessage_GroupUpdateDeleteMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateDeleteMessage)) as DataMessage_GroupUpdateDeleteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateDeleteMessage create() => DataMessage_GroupUpdateDeleteMessage._();
  DataMessage_GroupUpdateDeleteMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateDeleteMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateDeleteMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateDeleteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateDeleteMessage>(create);
  static DataMessage_GroupUpdateDeleteMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get memberSessionIds => $_getList(0);

  /// @required
  /// signature of "DELETE" || timestamp || sessionId[0] || ... || sessionId[n]
  @$pb.TagNumber(2)
  $core.List<$core.int> get adminSignature => $_getN(1);
  @$pb.TagNumber(2)
  set adminSignature($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAdminSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminSignature() => clearField(2);
}

class DataMessage_GroupUpdatePromoteMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdatePromoteMessage({
    $core.List<$core.int>? groupIdentitySeed,
    $core.String? name,
  }) {
    final $result = create();
    if (groupIdentitySeed != null) {
      $result.groupIdentitySeed = groupIdentitySeed;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  DataMessage_GroupUpdatePromoteMessage._() : super();
  factory DataMessage_GroupUpdatePromoteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdatePromoteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdatePromoteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'groupIdentitySeed', $pb.PbFieldType.QY, protoName: 'groupIdentitySeed')
    ..aQS(2, _omitFieldNames ? '' : 'name')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdatePromoteMessage clone() => DataMessage_GroupUpdatePromoteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdatePromoteMessage copyWith(void Function(DataMessage_GroupUpdatePromoteMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdatePromoteMessage)) as DataMessage_GroupUpdatePromoteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdatePromoteMessage create() => DataMessage_GroupUpdatePromoteMessage._();
  DataMessage_GroupUpdatePromoteMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdatePromoteMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdatePromoteMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdatePromoteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdatePromoteMessage>(create);
  static DataMessage_GroupUpdatePromoteMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get groupIdentitySeed => $_getN(0);
  @$pb.TagNumber(1)
  set groupIdentitySeed($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupIdentitySeed() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupIdentitySeed() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class DataMessage_GroupUpdateInfoChangeMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateInfoChangeMessage({
    DataMessage_GroupUpdateInfoChangeMessage_Type? type,
    $core.String? updatedName,
    $core.int? updatedExpiration,
    $core.List<$core.int>? adminSignature,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (updatedName != null) {
      $result.updatedName = updatedName;
    }
    if (updatedExpiration != null) {
      $result.updatedExpiration = updatedExpiration;
    }
    if (adminSignature != null) {
      $result.adminSignature = adminSignature;
    }
    return $result;
  }
  DataMessage_GroupUpdateInfoChangeMessage._() : super();
  factory DataMessage_GroupUpdateInfoChangeMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateInfoChangeMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateInfoChangeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<DataMessage_GroupUpdateInfoChangeMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: DataMessage_GroupUpdateInfoChangeMessage_Type.NAME, valueOf: DataMessage_GroupUpdateInfoChangeMessage_Type.valueOf, enumValues: DataMessage_GroupUpdateInfoChangeMessage_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'updatedName', protoName: 'updatedName')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'updatedExpiration', $pb.PbFieldType.OU3, protoName: 'updatedExpiration')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'adminSignature', $pb.PbFieldType.QY, protoName: 'adminSignature')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInfoChangeMessage clone() => DataMessage_GroupUpdateInfoChangeMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInfoChangeMessage copyWith(void Function(DataMessage_GroupUpdateInfoChangeMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateInfoChangeMessage)) as DataMessage_GroupUpdateInfoChangeMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInfoChangeMessage create() => DataMessage_GroupUpdateInfoChangeMessage._();
  DataMessage_GroupUpdateInfoChangeMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateInfoChangeMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateInfoChangeMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInfoChangeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateInfoChangeMessage>(create);
  static DataMessage_GroupUpdateInfoChangeMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  DataMessage_GroupUpdateInfoChangeMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DataMessage_GroupUpdateInfoChangeMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get updatedName => $_getSZ(1);
  @$pb.TagNumber(2)
  set updatedName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdatedName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get updatedExpiration => $_getIZ(2);
  @$pb.TagNumber(3)
  set updatedExpiration($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedExpiration() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedExpiration() => clearField(3);

  /// @required
  /// "INFO_CHANGE" || type || timestamp
  @$pb.TagNumber(4)
  $core.List<$core.int> get adminSignature => $_getN(3);
  @$pb.TagNumber(4)
  set adminSignature($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAdminSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdminSignature() => clearField(4);
}

class DataMessage_GroupUpdateMemberChangeMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateMemberChangeMessage({
    DataMessage_GroupUpdateMemberChangeMessage_Type? type,
    $core.Iterable<$core.String>? memberSessionIds,
    $core.bool? historyShared,
    $core.List<$core.int>? adminSignature,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (memberSessionIds != null) {
      $result.memberSessionIds.addAll(memberSessionIds);
    }
    if (historyShared != null) {
      $result.historyShared = historyShared;
    }
    if (adminSignature != null) {
      $result.adminSignature = adminSignature;
    }
    return $result;
  }
  DataMessage_GroupUpdateMemberChangeMessage._() : super();
  factory DataMessage_GroupUpdateMemberChangeMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateMemberChangeMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateMemberChangeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<DataMessage_GroupUpdateMemberChangeMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: DataMessage_GroupUpdateMemberChangeMessage_Type.ADDED, valueOf: DataMessage_GroupUpdateMemberChangeMessage_Type.valueOf, enumValues: DataMessage_GroupUpdateMemberChangeMessage_Type.values)
    ..pPS(2, _omitFieldNames ? '' : 'memberSessionIds', protoName: 'memberSessionIds')
    ..aOB(3, _omitFieldNames ? '' : 'historyShared', protoName: 'historyShared')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'adminSignature', $pb.PbFieldType.QY, protoName: 'adminSignature')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberChangeMessage clone() => DataMessage_GroupUpdateMemberChangeMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberChangeMessage copyWith(void Function(DataMessage_GroupUpdateMemberChangeMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateMemberChangeMessage)) as DataMessage_GroupUpdateMemberChangeMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberChangeMessage create() => DataMessage_GroupUpdateMemberChangeMessage._();
  DataMessage_GroupUpdateMemberChangeMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateMemberChangeMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateMemberChangeMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberChangeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateMemberChangeMessage>(create);
  static DataMessage_GroupUpdateMemberChangeMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  DataMessage_GroupUpdateMemberChangeMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DataMessage_GroupUpdateMemberChangeMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get memberSessionIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get historyShared => $_getBF(2);
  @$pb.TagNumber(3)
  set historyShared($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHistoryShared() => $_has(2);
  @$pb.TagNumber(3)
  void clearHistoryShared() => clearField(3);

  /// @required
  /// "MEMBER_CHANGE" || type || timestamp
  @$pb.TagNumber(4)
  $core.List<$core.int> get adminSignature => $_getN(3);
  @$pb.TagNumber(4)
  set adminSignature($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAdminSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdminSignature() => clearField(4);
}

class DataMessage_GroupUpdateMemberLeftMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateMemberLeftMessage() => create();
  DataMessage_GroupUpdateMemberLeftMessage._() : super();
  factory DataMessage_GroupUpdateMemberLeftMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateMemberLeftMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateMemberLeftMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberLeftMessage clone() => DataMessage_GroupUpdateMemberLeftMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberLeftMessage copyWith(void Function(DataMessage_GroupUpdateMemberLeftMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateMemberLeftMessage)) as DataMessage_GroupUpdateMemberLeftMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberLeftMessage create() => DataMessage_GroupUpdateMemberLeftMessage._();
  DataMessage_GroupUpdateMemberLeftMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateMemberLeftMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateMemberLeftMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberLeftMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateMemberLeftMessage>(create);
  static DataMessage_GroupUpdateMemberLeftMessage? _defaultInstance;
}

class DataMessage_GroupUpdateInviteResponseMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateInviteResponseMessage({
    $core.bool? isApproved,
  }) {
    final $result = create();
    if (isApproved != null) {
      $result.isApproved = isApproved;
    }
    return $result;
  }
  DataMessage_GroupUpdateInviteResponseMessage._() : super();
  factory DataMessage_GroupUpdateInviteResponseMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateInviteResponseMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateInviteResponseMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'isApproved', $pb.PbFieldType.QB, protoName: 'isApproved')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInviteResponseMessage clone() => DataMessage_GroupUpdateInviteResponseMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateInviteResponseMessage copyWith(void Function(DataMessage_GroupUpdateInviteResponseMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateInviteResponseMessage)) as DataMessage_GroupUpdateInviteResponseMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInviteResponseMessage create() => DataMessage_GroupUpdateInviteResponseMessage._();
  DataMessage_GroupUpdateInviteResponseMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateInviteResponseMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateInviteResponseMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateInviteResponseMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateInviteResponseMessage>(create);
  static DataMessage_GroupUpdateInviteResponseMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.bool get isApproved => $_getBF(0);
  @$pb.TagNumber(1)
  set isApproved($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsApproved() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsApproved() => clearField(1);
}

class DataMessage_GroupUpdateDeleteMemberContentMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateDeleteMemberContentMessage({
    $core.Iterable<$core.String>? memberSessionIds,
    $core.Iterable<$core.String>? messageHashes,
    $core.List<$core.int>? adminSignature,
  }) {
    final $result = create();
    if (memberSessionIds != null) {
      $result.memberSessionIds.addAll(memberSessionIds);
    }
    if (messageHashes != null) {
      $result.messageHashes.addAll(messageHashes);
    }
    if (adminSignature != null) {
      $result.adminSignature = adminSignature;
    }
    return $result;
  }
  DataMessage_GroupUpdateDeleteMemberContentMessage._() : super();
  factory DataMessage_GroupUpdateDeleteMemberContentMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateDeleteMemberContentMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateDeleteMemberContentMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'memberSessionIds', protoName: 'memberSessionIds')
    ..pPS(2, _omitFieldNames ? '' : 'messageHashes', protoName: 'messageHashes')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'adminSignature', $pb.PbFieldType.OY, protoName: 'adminSignature')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateDeleteMemberContentMessage clone() => DataMessage_GroupUpdateDeleteMemberContentMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateDeleteMemberContentMessage copyWith(void Function(DataMessage_GroupUpdateDeleteMemberContentMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateDeleteMemberContentMessage)) as DataMessage_GroupUpdateDeleteMemberContentMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateDeleteMemberContentMessage create() => DataMessage_GroupUpdateDeleteMemberContentMessage._();
  DataMessage_GroupUpdateDeleteMemberContentMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateDeleteMemberContentMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateDeleteMemberContentMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateDeleteMemberContentMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateDeleteMemberContentMessage>(create);
  static DataMessage_GroupUpdateDeleteMemberContentMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get memberSessionIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get messageHashes => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get adminSignature => $_getN(2);
  @$pb.TagNumber(3)
  set adminSignature($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAdminSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdminSignature() => clearField(3);
}

class DataMessage_GroupUpdateMemberLeftNotificationMessage extends $pb.GeneratedMessage {
  factory DataMessage_GroupUpdateMemberLeftNotificationMessage() => create();
  DataMessage_GroupUpdateMemberLeftNotificationMessage._() : super();
  factory DataMessage_GroupUpdateMemberLeftNotificationMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_GroupUpdateMemberLeftNotificationMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.GroupUpdateMemberLeftNotificationMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberLeftNotificationMessage clone() => DataMessage_GroupUpdateMemberLeftNotificationMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_GroupUpdateMemberLeftNotificationMessage copyWith(void Function(DataMessage_GroupUpdateMemberLeftNotificationMessage) updates) => super.copyWith((message) => updates(message as DataMessage_GroupUpdateMemberLeftNotificationMessage)) as DataMessage_GroupUpdateMemberLeftNotificationMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberLeftNotificationMessage create() => DataMessage_GroupUpdateMemberLeftNotificationMessage._();
  DataMessage_GroupUpdateMemberLeftNotificationMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_GroupUpdateMemberLeftNotificationMessage> createRepeated() => $pb.PbList<DataMessage_GroupUpdateMemberLeftNotificationMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_GroupUpdateMemberLeftNotificationMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_GroupUpdateMemberLeftNotificationMessage>(create);
  static DataMessage_GroupUpdateMemberLeftNotificationMessage? _defaultInstance;
}

class DataMessage_ClosedGroupControlMessage_KeyPairWrapper extends $pb.GeneratedMessage {
  factory DataMessage_ClosedGroupControlMessage_KeyPairWrapper({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? encryptedKeyPair,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (encryptedKeyPair != null) {
      $result.encryptedKeyPair = encryptedKeyPair;
    }
    return $result;
  }
  DataMessage_ClosedGroupControlMessage_KeyPairWrapper._() : super();
  factory DataMessage_ClosedGroupControlMessage_KeyPairWrapper.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_ClosedGroupControlMessage_KeyPairWrapper.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.ClosedGroupControlMessage.KeyPairWrapper', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'encryptedKeyPair', $pb.PbFieldType.QY, protoName: 'encryptedKeyPair')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_ClosedGroupControlMessage_KeyPairWrapper clone() => DataMessage_ClosedGroupControlMessage_KeyPairWrapper()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_ClosedGroupControlMessage_KeyPairWrapper copyWith(void Function(DataMessage_ClosedGroupControlMessage_KeyPairWrapper) updates) => super.copyWith((message) => updates(message as DataMessage_ClosedGroupControlMessage_KeyPairWrapper)) as DataMessage_ClosedGroupControlMessage_KeyPairWrapper;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_ClosedGroupControlMessage_KeyPairWrapper create() => DataMessage_ClosedGroupControlMessage_KeyPairWrapper._();
  DataMessage_ClosedGroupControlMessage_KeyPairWrapper createEmptyInstance() => create();
  static $pb.PbList<DataMessage_ClosedGroupControlMessage_KeyPairWrapper> createRepeated() => $pb.PbList<DataMessage_ClosedGroupControlMessage_KeyPairWrapper>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_ClosedGroupControlMessage_KeyPairWrapper getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_ClosedGroupControlMessage_KeyPairWrapper>(create);
  static DataMessage_ClosedGroupControlMessage_KeyPairWrapper? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.List<$core.int> get encryptedKeyPair => $_getN(1);
  @$pb.TagNumber(2)
  set encryptedKeyPair($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEncryptedKeyPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptedKeyPair() => clearField(2);
}

class DataMessage_ClosedGroupControlMessage extends $pb.GeneratedMessage {
  factory DataMessage_ClosedGroupControlMessage({
    DataMessage_ClosedGroupControlMessage_Type? type,
    $core.List<$core.int>? publicKey,
    $core.String? name,
    KeyPair? encryptionKeyPair,
    $core.Iterable<$core.List<$core.int>>? members,
    $core.Iterable<$core.List<$core.int>>? admins,
    $core.Iterable<DataMessage_ClosedGroupControlMessage_KeyPairWrapper>? wrappers,
    $core.int? expirationTimer,
    $core.List<$core.int>? memberPrivateKey,
    $core.List<$core.int>? privateKey,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (name != null) {
      $result.name = name;
    }
    if (encryptionKeyPair != null) {
      $result.encryptionKeyPair = encryptionKeyPair;
    }
    if (members != null) {
      $result.members.addAll(members);
    }
    if (admins != null) {
      $result.admins.addAll(admins);
    }
    if (wrappers != null) {
      $result.wrappers.addAll(wrappers);
    }
    if (expirationTimer != null) {
      $result.expirationTimer = expirationTimer;
    }
    if (memberPrivateKey != null) {
      $result.memberPrivateKey = memberPrivateKey;
    }
    if (privateKey != null) {
      $result.privateKey = privateKey;
    }
    return $result;
  }
  DataMessage_ClosedGroupControlMessage._() : super();
  factory DataMessage_ClosedGroupControlMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_ClosedGroupControlMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.ClosedGroupControlMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<DataMessage_ClosedGroupControlMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: DataMessage_ClosedGroupControlMessage_Type.NEW, valueOf: DataMessage_ClosedGroupControlMessage_Type.valueOf, enumValues: DataMessage_ClosedGroupControlMessage_Type.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOM<KeyPair>(4, _omitFieldNames ? '' : 'encryptionKeyPair', protoName: 'encryptionKeyPair', subBuilder: KeyPair.create)
    ..p<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'members', $pb.PbFieldType.PY)
    ..p<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'admins', $pb.PbFieldType.PY)
    ..pc<DataMessage_ClosedGroupControlMessage_KeyPairWrapper>(7, _omitFieldNames ? '' : 'wrappers', $pb.PbFieldType.PM, subBuilder: DataMessage_ClosedGroupControlMessage_KeyPairWrapper.create)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'expirationTimer', $pb.PbFieldType.OU3, protoName: 'expirationTimer')
    ..a<$core.List<$core.int>>(9, _omitFieldNames ? '' : 'memberPrivateKey', $pb.PbFieldType.OY, protoName: 'memberPrivateKey')
    ..a<$core.List<$core.int>>(10, _omitFieldNames ? '' : 'privateKey', $pb.PbFieldType.OY, protoName: 'privateKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_ClosedGroupControlMessage clone() => DataMessage_ClosedGroupControlMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_ClosedGroupControlMessage copyWith(void Function(DataMessage_ClosedGroupControlMessage) updates) => super.copyWith((message) => updates(message as DataMessage_ClosedGroupControlMessage)) as DataMessage_ClosedGroupControlMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_ClosedGroupControlMessage create() => DataMessage_ClosedGroupControlMessage._();
  DataMessage_ClosedGroupControlMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage_ClosedGroupControlMessage> createRepeated() => $pb.PbList<DataMessage_ClosedGroupControlMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_ClosedGroupControlMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_ClosedGroupControlMessage>(create);
  static DataMessage_ClosedGroupControlMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  DataMessage_ClosedGroupControlMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DataMessage_ClosedGroupControlMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  KeyPair get encryptionKeyPair => $_getN(3);
  @$pb.TagNumber(4)
  set encryptionKeyPair(KeyPair v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEncryptionKeyPair() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncryptionKeyPair() => clearField(4);
  @$pb.TagNumber(4)
  KeyPair ensureEncryptionKeyPair() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.List<$core.List<$core.int>> get members => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$core.List<$core.int>> get admins => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<DataMessage_ClosedGroupControlMessage_KeyPairWrapper> get wrappers => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get expirationTimer => $_getIZ(7);
  @$pb.TagNumber(8)
  set expirationTimer($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExpirationTimer() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpirationTimer() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get memberPrivateKey => $_getN(8);
  @$pb.TagNumber(9)
  set memberPrivateKey($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMemberPrivateKey() => $_has(8);
  @$pb.TagNumber(9)
  void clearMemberPrivateKey() => clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get privateKey => $_getN(9);
  @$pb.TagNumber(10)
  set privateKey($core.List<$core.int> v) { $_setBytes(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPrivateKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearPrivateKey() => clearField(10);
}

class DataMessage_Reaction extends $pb.GeneratedMessage {
  factory DataMessage_Reaction({
    $fixnum.Int64? id,
    $core.String? author,
    $core.String? emoji,
    DataMessage_Reaction_Action? action,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (author != null) {
      $result.author = author;
    }
    if (emoji != null) {
      $result.emoji = emoji;
    }
    if (action != null) {
      $result.action = action;
    }
    return $result;
  }
  DataMessage_Reaction._() : super();
  factory DataMessage_Reaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage_Reaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage.Reaction', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'author')
    ..aOS(3, _omitFieldNames ? '' : 'emoji')
    ..e<DataMessage_Reaction_Action>(4, _omitFieldNames ? '' : 'action', $pb.PbFieldType.QE, defaultOrMaker: DataMessage_Reaction_Action.REACT, valueOf: DataMessage_Reaction_Action.valueOf, enumValues: DataMessage_Reaction_Action.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage_Reaction clone() => DataMessage_Reaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage_Reaction copyWith(void Function(DataMessage_Reaction) updates) => super.copyWith((message) => updates(message as DataMessage_Reaction)) as DataMessage_Reaction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage_Reaction create() => DataMessage_Reaction._();
  DataMessage_Reaction createEmptyInstance() => create();
  static $pb.PbList<DataMessage_Reaction> createRepeated() => $pb.PbList<DataMessage_Reaction>();
  @$core.pragma('dart2js:noInline')
  static DataMessage_Reaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage_Reaction>(create);
  static DataMessage_Reaction? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get emoji => $_getSZ(2);
  @$pb.TagNumber(3)
  set emoji($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmoji() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmoji() => clearField(3);

  /// @required
  @$pb.TagNumber(4)
  DataMessage_Reaction_Action get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(DataMessage_Reaction_Action v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => clearField(4);
}

class DataMessage extends $pb.GeneratedMessage {
  factory DataMessage({
    $core.String? body,
    $core.Iterable<AttachmentPointer>? attachments,
    $core.int? flags,
    $core.int? expireTimer,
    $core.List<$core.int>? profileKey,
    $fixnum.Int64? timestamp,
    DataMessage_Quote? quote,
    $core.Iterable<DataMessage_Preview>? preview,
    DataMessage_Reaction? reaction,
    DataMessage_LokiProfile? profile,
    DataMessage_OpenGroupInvitation? openGroupInvitation,
    DataMessage_ClosedGroupControlMessage? closedGroupControlMessage,
    $core.String? syncTarget,
    $core.bool? blocksCommunityMessageRequests,
    DataMessage_GroupUpdateMessage? groupUpdateMessage,
  }) {
    final $result = create();
    if (body != null) {
      $result.body = body;
    }
    if (attachments != null) {
      $result.attachments.addAll(attachments);
    }
    if (flags != null) {
      $result.flags = flags;
    }
    if (expireTimer != null) {
      $result.expireTimer = expireTimer;
    }
    if (profileKey != null) {
      $result.profileKey = profileKey;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (quote != null) {
      $result.quote = quote;
    }
    if (preview != null) {
      $result.preview.addAll(preview);
    }
    if (reaction != null) {
      $result.reaction = reaction;
    }
    if (profile != null) {
      $result.profile = profile;
    }
    if (openGroupInvitation != null) {
      $result.openGroupInvitation = openGroupInvitation;
    }
    if (closedGroupControlMessage != null) {
      $result.closedGroupControlMessage = closedGroupControlMessage;
    }
    if (syncTarget != null) {
      $result.syncTarget = syncTarget;
    }
    if (blocksCommunityMessageRequests != null) {
      $result.blocksCommunityMessageRequests = blocksCommunityMessageRequests;
    }
    if (groupUpdateMessage != null) {
      $result.groupUpdateMessage = groupUpdateMessage;
    }
    return $result;
  }
  DataMessage._() : super();
  factory DataMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'body')
    ..pc<AttachmentPointer>(2, _omitFieldNames ? '' : 'attachments', $pb.PbFieldType.PM, subBuilder: AttachmentPointer.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'flags', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'expireTimer', $pb.PbFieldType.OU3, protoName: 'expireTimer')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'profileKey', $pb.PbFieldType.OY, protoName: 'profileKey')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<DataMessage_Quote>(8, _omitFieldNames ? '' : 'quote', subBuilder: DataMessage_Quote.create)
    ..pc<DataMessage_Preview>(10, _omitFieldNames ? '' : 'preview', $pb.PbFieldType.PM, subBuilder: DataMessage_Preview.create)
    ..aOM<DataMessage_Reaction>(11, _omitFieldNames ? '' : 'reaction', subBuilder: DataMessage_Reaction.create)
    ..aOM<DataMessage_LokiProfile>(101, _omitFieldNames ? '' : 'profile', subBuilder: DataMessage_LokiProfile.create)
    ..aOM<DataMessage_OpenGroupInvitation>(102, _omitFieldNames ? '' : 'openGroupInvitation', protoName: 'openGroupInvitation', subBuilder: DataMessage_OpenGroupInvitation.create)
    ..aOM<DataMessage_ClosedGroupControlMessage>(104, _omitFieldNames ? '' : 'closedGroupControlMessage', protoName: 'closedGroupControlMessage', subBuilder: DataMessage_ClosedGroupControlMessage.create)
    ..aOS(105, _omitFieldNames ? '' : 'syncTarget', protoName: 'syncTarget')
    ..aOB(106, _omitFieldNames ? '' : 'blocksCommunityMessageRequests', protoName: 'blocksCommunityMessageRequests')
    ..aOM<DataMessage_GroupUpdateMessage>(120, _omitFieldNames ? '' : 'groupUpdateMessage', protoName: 'groupUpdateMessage', subBuilder: DataMessage_GroupUpdateMessage.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataMessage clone() => DataMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataMessage copyWith(void Function(DataMessage) updates) => super.copyWith((message) => updates(message as DataMessage)) as DataMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataMessage create() => DataMessage._();
  DataMessage createEmptyInstance() => create();
  static $pb.PbList<DataMessage> createRepeated() => $pb.PbList<DataMessage>();
  @$core.pragma('dart2js:noInline')
  static DataMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataMessage>(create);
  static DataMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get body => $_getSZ(0);
  @$pb.TagNumber(1)
  set body($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBody() => $_has(0);
  @$pb.TagNumber(1)
  void clearBody() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<AttachmentPointer> get attachments => $_getList(1);

  @$pb.TagNumber(4)
  $core.int get flags => $_getIZ(2);
  @$pb.TagNumber(4)
  set flags($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasFlags() => $_has(2);
  @$pb.TagNumber(4)
  void clearFlags() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get expireTimer => $_getIZ(3);
  @$pb.TagNumber(5)
  set expireTimer($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpireTimer() => $_has(3);
  @$pb.TagNumber(5)
  void clearExpireTimer() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get profileKey => $_getN(4);
  @$pb.TagNumber(6)
  set profileKey($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasProfileKey() => $_has(4);
  @$pb.TagNumber(6)
  void clearProfileKey() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(7)
  set timestamp($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(7)
  void clearTimestamp() => clearField(7);

  @$pb.TagNumber(8)
  DataMessage_Quote get quote => $_getN(6);
  @$pb.TagNumber(8)
  set quote(DataMessage_Quote v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasQuote() => $_has(6);
  @$pb.TagNumber(8)
  void clearQuote() => clearField(8);
  @$pb.TagNumber(8)
  DataMessage_Quote ensureQuote() => $_ensure(6);

  @$pb.TagNumber(10)
  $core.List<DataMessage_Preview> get preview => $_getList(7);

  @$pb.TagNumber(11)
  DataMessage_Reaction get reaction => $_getN(8);
  @$pb.TagNumber(11)
  set reaction(DataMessage_Reaction v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasReaction() => $_has(8);
  @$pb.TagNumber(11)
  void clearReaction() => clearField(11);
  @$pb.TagNumber(11)
  DataMessage_Reaction ensureReaction() => $_ensure(8);

  @$pb.TagNumber(101)
  DataMessage_LokiProfile get profile => $_getN(9);
  @$pb.TagNumber(101)
  set profile(DataMessage_LokiProfile v) { setField(101, v); }
  @$pb.TagNumber(101)
  $core.bool hasProfile() => $_has(9);
  @$pb.TagNumber(101)
  void clearProfile() => clearField(101);
  @$pb.TagNumber(101)
  DataMessage_LokiProfile ensureProfile() => $_ensure(9);

  @$pb.TagNumber(102)
  DataMessage_OpenGroupInvitation get openGroupInvitation => $_getN(10);
  @$pb.TagNumber(102)
  set openGroupInvitation(DataMessage_OpenGroupInvitation v) { setField(102, v); }
  @$pb.TagNumber(102)
  $core.bool hasOpenGroupInvitation() => $_has(10);
  @$pb.TagNumber(102)
  void clearOpenGroupInvitation() => clearField(102);
  @$pb.TagNumber(102)
  DataMessage_OpenGroupInvitation ensureOpenGroupInvitation() => $_ensure(10);

  @$pb.TagNumber(104)
  DataMessage_ClosedGroupControlMessage get closedGroupControlMessage => $_getN(11);
  @$pb.TagNumber(104)
  set closedGroupControlMessage(DataMessage_ClosedGroupControlMessage v) { setField(104, v); }
  @$pb.TagNumber(104)
  $core.bool hasClosedGroupControlMessage() => $_has(11);
  @$pb.TagNumber(104)
  void clearClosedGroupControlMessage() => clearField(104);
  @$pb.TagNumber(104)
  DataMessage_ClosedGroupControlMessage ensureClosedGroupControlMessage() => $_ensure(11);

  @$pb.TagNumber(105)
  $core.String get syncTarget => $_getSZ(12);
  @$pb.TagNumber(105)
  set syncTarget($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(105)
  $core.bool hasSyncTarget() => $_has(12);
  @$pb.TagNumber(105)
  void clearSyncTarget() => clearField(105);

  @$pb.TagNumber(106)
  $core.bool get blocksCommunityMessageRequests => $_getBF(13);
  @$pb.TagNumber(106)
  set blocksCommunityMessageRequests($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(106)
  $core.bool hasBlocksCommunityMessageRequests() => $_has(13);
  @$pb.TagNumber(106)
  void clearBlocksCommunityMessageRequests() => clearField(106);

  @$pb.TagNumber(120)
  DataMessage_GroupUpdateMessage get groupUpdateMessage => $_getN(14);
  @$pb.TagNumber(120)
  set groupUpdateMessage(DataMessage_GroupUpdateMessage v) { setField(120, v); }
  @$pb.TagNumber(120)
  $core.bool hasGroupUpdateMessage() => $_has(14);
  @$pb.TagNumber(120)
  void clearGroupUpdateMessage() => clearField(120);
  @$pb.TagNumber(120)
  DataMessage_GroupUpdateMessage ensureGroupUpdateMessage() => $_ensure(14);
}

class GroupDeleteMessage extends $pb.GeneratedMessage {
  factory GroupDeleteMessage({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? lastEncryptionKey,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (lastEncryptionKey != null) {
      $result.lastEncryptionKey = lastEncryptionKey;
    }
    return $result;
  }
  GroupDeleteMessage._() : super();
  factory GroupDeleteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupDeleteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupDeleteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'lastEncryptionKey', $pb.PbFieldType.QY, protoName: 'lastEncryptionKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupDeleteMessage clone() => GroupDeleteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupDeleteMessage copyWith(void Function(GroupDeleteMessage) updates) => super.copyWith((message) => updates(message as GroupDeleteMessage)) as GroupDeleteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupDeleteMessage create() => GroupDeleteMessage._();
  GroupDeleteMessage createEmptyInstance() => create();
  static $pb.PbList<GroupDeleteMessage> createRepeated() => $pb.PbList<GroupDeleteMessage>();
  @$core.pragma('dart2js:noInline')
  static GroupDeleteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupDeleteMessage>(create);
  static GroupDeleteMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.List<$core.int> get lastEncryptionKey => $_getN(1);
  @$pb.TagNumber(2)
  set lastEncryptionKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastEncryptionKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastEncryptionKey() => clearField(2);
}

class GroupMemberLeftMessage extends $pb.GeneratedMessage {
  factory GroupMemberLeftMessage() => create();
  GroupMemberLeftMessage._() : super();
  factory GroupMemberLeftMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupMemberLeftMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupMemberLeftMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupMemberLeftMessage clone() => GroupMemberLeftMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupMemberLeftMessage copyWith(void Function(GroupMemberLeftMessage) updates) => super.copyWith((message) => updates(message as GroupMemberLeftMessage)) as GroupMemberLeftMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberLeftMessage create() => GroupMemberLeftMessage._();
  GroupMemberLeftMessage createEmptyInstance() => create();
  static $pb.PbList<GroupMemberLeftMessage> createRepeated() => $pb.PbList<GroupMemberLeftMessage>();
  @$core.pragma('dart2js:noInline')
  static GroupMemberLeftMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupMemberLeftMessage>(create);
  static GroupMemberLeftMessage? _defaultInstance;
}

class GroupInviteMessage extends $pb.GeneratedMessage {
  factory GroupInviteMessage({
    $core.List<$core.int>? publicKey,
    $core.String? name,
    $core.List<$core.int>? memberPrivateKey,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (name != null) {
      $result.name = name;
    }
    if (memberPrivateKey != null) {
      $result.memberPrivateKey = memberPrivateKey;
    }
    return $result;
  }
  GroupInviteMessage._() : super();
  factory GroupInviteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupInviteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupInviteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'memberPrivateKey', $pb.PbFieldType.QY, protoName: 'memberPrivateKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupInviteMessage clone() => GroupInviteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupInviteMessage copyWith(void Function(GroupInviteMessage) updates) => super.copyWith((message) => updates(message as GroupInviteMessage)) as GroupInviteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInviteMessage create() => GroupInviteMessage._();
  GroupInviteMessage createEmptyInstance() => create();
  static $pb.PbList<GroupInviteMessage> createRepeated() => $pb.PbList<GroupInviteMessage>();
  @$core.pragma('dart2js:noInline')
  static GroupInviteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupInviteMessage>(create);
  static GroupInviteMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  /// @required
  @$pb.TagNumber(3)
  $core.List<$core.int> get memberPrivateKey => $_getN(2);
  @$pb.TagNumber(3)
  set memberPrivateKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMemberPrivateKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemberPrivateKey() => clearField(3);
}

class GroupPromoteMessage extends $pb.GeneratedMessage {
  factory GroupPromoteMessage({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? encryptedPrivateKey,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (encryptedPrivateKey != null) {
      $result.encryptedPrivateKey = encryptedPrivateKey;
    }
    return $result;
  }
  GroupPromoteMessage._() : super();
  factory GroupPromoteMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupPromoteMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupPromoteMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'encryptedPrivateKey', $pb.PbFieldType.QY, protoName: 'encryptedPrivateKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupPromoteMessage clone() => GroupPromoteMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupPromoteMessage copyWith(void Function(GroupPromoteMessage) updates) => super.copyWith((message) => updates(message as GroupPromoteMessage)) as GroupPromoteMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupPromoteMessage create() => GroupPromoteMessage._();
  GroupPromoteMessage createEmptyInstance() => create();
  static $pb.PbList<GroupPromoteMessage> createRepeated() => $pb.PbList<GroupPromoteMessage>();
  @$core.pragma('dart2js:noInline')
  static GroupPromoteMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupPromoteMessage>(create);
  static GroupPromoteMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.List<$core.int> get encryptedPrivateKey => $_getN(1);
  @$pb.TagNumber(2)
  set encryptedPrivateKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEncryptedPrivateKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptedPrivateKey() => clearField(2);
}

class CallMessage extends $pb.GeneratedMessage {
  factory CallMessage({
    CallMessage_Type? type,
    $core.Iterable<$core.String>? sdps,
    $core.Iterable<$core.int>? sdpMLineIndexes,
    $core.Iterable<$core.String>? sdpMids,
    $core.String? uuid,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (sdps != null) {
      $result.sdps.addAll(sdps);
    }
    if (sdpMLineIndexes != null) {
      $result.sdpMLineIndexes.addAll(sdpMLineIndexes);
    }
    if (sdpMids != null) {
      $result.sdpMids.addAll(sdpMids);
    }
    if (uuid != null) {
      $result.uuid = uuid;
    }
    return $result;
  }
  CallMessage._() : super();
  factory CallMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CallMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<CallMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: CallMessage_Type.PRE_OFFER, valueOf: CallMessage_Type.valueOf, enumValues: CallMessage_Type.values)
    ..pPS(2, _omitFieldNames ? '' : 'sdps')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'sdpMLineIndexes', $pb.PbFieldType.PU3, protoName: 'sdpMLineIndexes')
    ..pPS(4, _omitFieldNames ? '' : 'sdpMids', protoName: 'sdpMids')
    ..aQS(5, _omitFieldNames ? '' : 'uuid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CallMessage clone() => CallMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CallMessage copyWith(void Function(CallMessage) updates) => super.copyWith((message) => updates(message as CallMessage)) as CallMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallMessage create() => CallMessage._();
  CallMessage createEmptyInstance() => create();
  static $pb.PbList<CallMessage> createRepeated() => $pb.PbList<CallMessage>();
  @$core.pragma('dart2js:noInline')
  static CallMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallMessage>(create);
  static CallMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  CallMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(CallMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get sdps => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get sdpMLineIndexes => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get sdpMids => $_getList(3);

  /// @required
  @$pb.TagNumber(5)
  $core.String get uuid => $_getSZ(4);
  @$pb.TagNumber(5)
  set uuid($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUuid() => $_has(4);
  @$pb.TagNumber(5)
  void clearUuid() => clearField(5);
}

class ConfigurationMessage_ClosedGroup extends $pb.GeneratedMessage {
  factory ConfigurationMessage_ClosedGroup({
    $core.List<$core.int>? publicKey,
    $core.String? name,
    KeyPair? encryptionKeyPair,
    $core.Iterable<$core.List<$core.int>>? members,
    $core.Iterable<$core.List<$core.int>>? admins,
    $core.int? expirationTimer,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (name != null) {
      $result.name = name;
    }
    if (encryptionKeyPair != null) {
      $result.encryptionKeyPair = encryptionKeyPair;
    }
    if (members != null) {
      $result.members.addAll(members);
    }
    if (admins != null) {
      $result.admins.addAll(admins);
    }
    if (expirationTimer != null) {
      $result.expirationTimer = expirationTimer;
    }
    return $result;
  }
  ConfigurationMessage_ClosedGroup._() : super();
  factory ConfigurationMessage_ClosedGroup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConfigurationMessage_ClosedGroup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConfigurationMessage.ClosedGroup', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<KeyPair>(3, _omitFieldNames ? '' : 'encryptionKeyPair', protoName: 'encryptionKeyPair', subBuilder: KeyPair.create)
    ..p<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'members', $pb.PbFieldType.PY)
    ..p<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'admins', $pb.PbFieldType.PY)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'expirationTimer', $pb.PbFieldType.OU3, protoName: 'expirationTimer')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConfigurationMessage_ClosedGroup clone() => ConfigurationMessage_ClosedGroup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConfigurationMessage_ClosedGroup copyWith(void Function(ConfigurationMessage_ClosedGroup) updates) => super.copyWith((message) => updates(message as ConfigurationMessage_ClosedGroup)) as ConfigurationMessage_ClosedGroup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage_ClosedGroup create() => ConfigurationMessage_ClosedGroup._();
  ConfigurationMessage_ClosedGroup createEmptyInstance() => create();
  static $pb.PbList<ConfigurationMessage_ClosedGroup> createRepeated() => $pb.PbList<ConfigurationMessage_ClosedGroup>();
  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage_ClosedGroup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConfigurationMessage_ClosedGroup>(create);
  static ConfigurationMessage_ClosedGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  KeyPair get encryptionKeyPair => $_getN(2);
  @$pb.TagNumber(3)
  set encryptionKeyPair(KeyPair v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEncryptionKeyPair() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncryptionKeyPair() => clearField(3);
  @$pb.TagNumber(3)
  KeyPair ensureEncryptionKeyPair() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$core.List<$core.int>> get members => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$core.List<$core.int>> get admins => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get expirationTimer => $_getIZ(5);
  @$pb.TagNumber(6)
  set expirationTimer($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasExpirationTimer() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpirationTimer() => clearField(6);
}

class ConfigurationMessage_Contact extends $pb.GeneratedMessage {
  factory ConfigurationMessage_Contact({
    $core.List<$core.int>? publicKey,
    $core.String? name,
    $core.String? profilePicture,
    $core.List<$core.int>? profileKey,
    $core.bool? isApproved,
    $core.bool? isBlocked,
    $core.bool? didApproveMe,
  }) {
    final $result = create();
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    if (name != null) {
      $result.name = name;
    }
    if (profilePicture != null) {
      $result.profilePicture = profilePicture;
    }
    if (profileKey != null) {
      $result.profileKey = profileKey;
    }
    if (isApproved != null) {
      $result.isApproved = isApproved;
    }
    if (isBlocked != null) {
      $result.isBlocked = isBlocked;
    }
    if (didApproveMe != null) {
      $result.didApproveMe = didApproveMe;
    }
    return $result;
  }
  ConfigurationMessage_Contact._() : super();
  factory ConfigurationMessage_Contact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConfigurationMessage_Contact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConfigurationMessage.Contact', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.QY, protoName: 'publicKey')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'profilePicture', protoName: 'profilePicture')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'profileKey', $pb.PbFieldType.OY, protoName: 'profileKey')
    ..aOB(5, _omitFieldNames ? '' : 'isApproved', protoName: 'isApproved')
    ..aOB(6, _omitFieldNames ? '' : 'isBlocked', protoName: 'isBlocked')
    ..aOB(7, _omitFieldNames ? '' : 'didApproveMe', protoName: 'didApproveMe')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConfigurationMessage_Contact clone() => ConfigurationMessage_Contact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConfigurationMessage_Contact copyWith(void Function(ConfigurationMessage_Contact) updates) => super.copyWith((message) => updates(message as ConfigurationMessage_Contact)) as ConfigurationMessage_Contact;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage_Contact create() => ConfigurationMessage_Contact._();
  ConfigurationMessage_Contact createEmptyInstance() => create();
  static $pb.PbList<ConfigurationMessage_Contact> createRepeated() => $pb.PbList<ConfigurationMessage_Contact>();
  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage_Contact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConfigurationMessage_Contact>(create);
  static ConfigurationMessage_Contact? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get profilePicture => $_getSZ(2);
  @$pb.TagNumber(3)
  set profilePicture($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProfilePicture() => $_has(2);
  @$pb.TagNumber(3)
  void clearProfilePicture() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get profileKey => $_getN(3);
  @$pb.TagNumber(4)
  set profileKey($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProfileKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfileKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isApproved => $_getBF(4);
  @$pb.TagNumber(5)
  set isApproved($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsApproved() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsApproved() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBlocked => $_getBF(5);
  @$pb.TagNumber(6)
  set isBlocked($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBlocked() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get didApproveMe => $_getBF(6);
  @$pb.TagNumber(7)
  set didApproveMe($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDidApproveMe() => $_has(6);
  @$pb.TagNumber(7)
  void clearDidApproveMe() => clearField(7);
}

class ConfigurationMessage extends $pb.GeneratedMessage {
  factory ConfigurationMessage({
    $core.Iterable<ConfigurationMessage_ClosedGroup>? closedGroups,
    $core.Iterable<$core.String>? openGroups,
    $core.String? displayName,
    $core.String? profilePicture,
    $core.List<$core.int>? profileKey,
    $core.Iterable<ConfigurationMessage_Contact>? contacts,
  }) {
    final $result = create();
    if (closedGroups != null) {
      $result.closedGroups.addAll(closedGroups);
    }
    if (openGroups != null) {
      $result.openGroups.addAll(openGroups);
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (profilePicture != null) {
      $result.profilePicture = profilePicture;
    }
    if (profileKey != null) {
      $result.profileKey = profileKey;
    }
    if (contacts != null) {
      $result.contacts.addAll(contacts);
    }
    return $result;
  }
  ConfigurationMessage._() : super();
  factory ConfigurationMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConfigurationMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConfigurationMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..pc<ConfigurationMessage_ClosedGroup>(1, _omitFieldNames ? '' : 'closedGroups', $pb.PbFieldType.PM, protoName: 'closedGroups', subBuilder: ConfigurationMessage_ClosedGroup.create)
    ..pPS(2, _omitFieldNames ? '' : 'openGroups', protoName: 'openGroups')
    ..aOS(3, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'profilePicture', protoName: 'profilePicture')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'profileKey', $pb.PbFieldType.OY, protoName: 'profileKey')
    ..pc<ConfigurationMessage_Contact>(6, _omitFieldNames ? '' : 'contacts', $pb.PbFieldType.PM, subBuilder: ConfigurationMessage_Contact.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConfigurationMessage clone() => ConfigurationMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConfigurationMessage copyWith(void Function(ConfigurationMessage) updates) => super.copyWith((message) => updates(message as ConfigurationMessage)) as ConfigurationMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage create() => ConfigurationMessage._();
  ConfigurationMessage createEmptyInstance() => create();
  static $pb.PbList<ConfigurationMessage> createRepeated() => $pb.PbList<ConfigurationMessage>();
  @$core.pragma('dart2js:noInline')
  static ConfigurationMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConfigurationMessage>(create);
  static ConfigurationMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ConfigurationMessage_ClosedGroup> get closedGroups => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get openGroups => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get profilePicture => $_getSZ(3);
  @$pb.TagNumber(4)
  set profilePicture($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProfilePicture() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfilePicture() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get profileKey => $_getN(4);
  @$pb.TagNumber(5)
  set profileKey($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProfileKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearProfileKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<ConfigurationMessage_Contact> get contacts => $_getList(5);
}

class MessageRequestResponse extends $pb.GeneratedMessage {
  factory MessageRequestResponse({
    $core.bool? isApproved,
    $core.List<$core.int>? profileKey,
    DataMessage_LokiProfile? profile,
  }) {
    final $result = create();
    if (isApproved != null) {
      $result.isApproved = isApproved;
    }
    if (profileKey != null) {
      $result.profileKey = profileKey;
    }
    if (profile != null) {
      $result.profile = profile;
    }
    return $result;
  }
  MessageRequestResponse._() : super();
  factory MessageRequestResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageRequestResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageRequestResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'isApproved', $pb.PbFieldType.QB, protoName: 'isApproved')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'profileKey', $pb.PbFieldType.OY, protoName: 'profileKey')
    ..aOM<DataMessage_LokiProfile>(3, _omitFieldNames ? '' : 'profile', subBuilder: DataMessage_LokiProfile.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageRequestResponse clone() => MessageRequestResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageRequestResponse copyWith(void Function(MessageRequestResponse) updates) => super.copyWith((message) => updates(message as MessageRequestResponse)) as MessageRequestResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageRequestResponse create() => MessageRequestResponse._();
  MessageRequestResponse createEmptyInstance() => create();
  static $pb.PbList<MessageRequestResponse> createRepeated() => $pb.PbList<MessageRequestResponse>();
  @$core.pragma('dart2js:noInline')
  static MessageRequestResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageRequestResponse>(create);
  static MessageRequestResponse? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $core.bool get isApproved => $_getBF(0);
  @$pb.TagNumber(1)
  set isApproved($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsApproved() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsApproved() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get profileKey => $_getN(1);
  @$pb.TagNumber(2)
  set profileKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfileKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileKey() => clearField(2);

  @$pb.TagNumber(3)
  DataMessage_LokiProfile get profile => $_getN(2);
  @$pb.TagNumber(3)
  set profile(DataMessage_LokiProfile v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasProfile() => $_has(2);
  @$pb.TagNumber(3)
  void clearProfile() => clearField(3);
  @$pb.TagNumber(3)
  DataMessage_LokiProfile ensureProfile() => $_ensure(2);
}

class SharedConfigMessage extends $pb.GeneratedMessage {
  factory SharedConfigMessage({
    SharedConfigMessage_Kind? kind,
    $fixnum.Int64? seqno,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (kind != null) {
      $result.kind = kind;
    }
    if (seqno != null) {
      $result.seqno = seqno;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SharedConfigMessage._() : super();
  factory SharedConfigMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SharedConfigMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SharedConfigMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<SharedConfigMessage_Kind>(1, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.QE, defaultOrMaker: SharedConfigMessage_Kind.USER_PROFILE, valueOf: SharedConfigMessage_Kind.valueOf, enumValues: SharedConfigMessage_Kind.values)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'seqno', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.QY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SharedConfigMessage clone() => SharedConfigMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SharedConfigMessage copyWith(void Function(SharedConfigMessage) updates) => super.copyWith((message) => updates(message as SharedConfigMessage)) as SharedConfigMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SharedConfigMessage create() => SharedConfigMessage._();
  SharedConfigMessage createEmptyInstance() => create();
  static $pb.PbList<SharedConfigMessage> createRepeated() => $pb.PbList<SharedConfigMessage>();
  @$core.pragma('dart2js:noInline')
  static SharedConfigMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SharedConfigMessage>(create);
  static SharedConfigMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  SharedConfigMessage_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SharedConfigMessage_Kind v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => clearField(1);

  /// @required
  @$pb.TagNumber(2)
  $fixnum.Int64 get seqno => $_getI64(1);
  @$pb.TagNumber(2)
  set seqno($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSeqno() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeqno() => clearField(2);

  /// @required
  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
}

class ReceiptMessage extends $pb.GeneratedMessage {
  factory ReceiptMessage({
    ReceiptMessage_Type? type,
    $core.Iterable<$fixnum.Int64>? timestamp,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (timestamp != null) {
      $result.timestamp.addAll(timestamp);
    }
    return $result;
  }
  ReceiptMessage._() : super();
  factory ReceiptMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReceiptMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReceiptMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..e<ReceiptMessage_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: ReceiptMessage_Type.DELIVERY, valueOf: ReceiptMessage_Type.valueOf, enumValues: ReceiptMessage_Type.values)
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.PU6)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReceiptMessage clone() => ReceiptMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReceiptMessage copyWith(void Function(ReceiptMessage) updates) => super.copyWith((message) => updates(message as ReceiptMessage)) as ReceiptMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiptMessage create() => ReceiptMessage._();
  ReceiptMessage createEmptyInstance() => create();
  static $pb.PbList<ReceiptMessage> createRepeated() => $pb.PbList<ReceiptMessage>();
  @$core.pragma('dart2js:noInline')
  static ReceiptMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReceiptMessage>(create);
  static ReceiptMessage? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  ReceiptMessage_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ReceiptMessage_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get timestamp => $_getList(1);
}

class AttachmentPointer extends $pb.GeneratedMessage {
  factory AttachmentPointer({
    $fixnum.Int64? id,
    $core.String? contentType,
    $core.List<$core.int>? key,
    $core.int? size,
    $core.List<$core.int>? thumbnail,
    $core.List<$core.int>? digest,
    $core.String? fileName,
    $core.int? flags,
    $core.int? width,
    $core.int? height,
    $core.String? caption,
    $core.String? url,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    if (key != null) {
      $result.key = key;
    }
    if (size != null) {
      $result.size = size;
    }
    if (thumbnail != null) {
      $result.thumbnail = thumbnail;
    }
    if (digest != null) {
      $result.digest = digest;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (flags != null) {
      $result.flags = flags;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (caption != null) {
      $result.caption = caption;
    }
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  AttachmentPointer._() : super();
  factory AttachmentPointer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AttachmentPointer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AttachmentPointer', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionProtos'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QF6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'key', $pb.PbFieldType.OY)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'thumbnail', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'digest', $pb.PbFieldType.OY)
    ..aOS(7, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'flags', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..aOS(11, _omitFieldNames ? '' : 'caption')
    ..aOS(101, _omitFieldNames ? '' : 'url')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AttachmentPointer clone() => AttachmentPointer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AttachmentPointer copyWith(void Function(AttachmentPointer) updates) => super.copyWith((message) => updates(message as AttachmentPointer)) as AttachmentPointer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachmentPointer create() => AttachmentPointer._();
  AttachmentPointer createEmptyInstance() => create();
  static $pb.PbList<AttachmentPointer> createRepeated() => $pb.PbList<AttachmentPointer>();
  @$core.pragma('dart2js:noInline')
  static AttachmentPointer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttachmentPointer>(create);
  static AttachmentPointer? _defaultInstance;

  /// @required
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentType => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get key => $_getN(2);
  @$pb.TagNumber(3)
  set key($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get size => $_getIZ(3);
  @$pb.TagNumber(4)
  set size($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get thumbnail => $_getN(4);
  @$pb.TagNumber(5)
  set thumbnail($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasThumbnail() => $_has(4);
  @$pb.TagNumber(5)
  void clearThumbnail() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get digest => $_getN(5);
  @$pb.TagNumber(6)
  set digest($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDigest() => $_has(5);
  @$pb.TagNumber(6)
  void clearDigest() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get fileName => $_getSZ(6);
  @$pb.TagNumber(7)
  set fileName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFileName() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileName() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get flags => $_getIZ(7);
  @$pb.TagNumber(8)
  set flags($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFlags() => $_has(7);
  @$pb.TagNumber(8)
  void clearFlags() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get width => $_getIZ(8);
  @$pb.TagNumber(9)
  set width($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasWidth() => $_has(8);
  @$pb.TagNumber(9)
  void clearWidth() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get height => $_getIZ(9);
  @$pb.TagNumber(10)
  set height($core.int v) { $_setUnsignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasHeight() => $_has(9);
  @$pb.TagNumber(10)
  void clearHeight() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get caption => $_getSZ(10);
  @$pb.TagNumber(11)
  set caption($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCaption() => $_has(10);
  @$pb.TagNumber(11)
  void clearCaption() => clearField(11);

  @$pb.TagNumber(101)
  $core.String get url => $_getSZ(11);
  @$pb.TagNumber(101)
  set url($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(101)
  $core.bool hasUrl() => $_has(11);
  @$pb.TagNumber(101)
  void clearUrl() => clearField(101);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
