//
//  Generated code. Do not modify.
//  source: protos/network_status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $0;

class GetNetworkStatusRequest extends $pb.GeneratedMessage {
  factory GetNetworkStatusRequest() => create();
  GetNetworkStatusRequest._() : super();
  factory GetNetworkStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNetworkStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNetworkStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNetworkStatusRequest clone() => GetNetworkStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNetworkStatusRequest copyWith(void Function(GetNetworkStatusRequest) updates) => super.copyWith((message) => updates(message as GetNetworkStatusRequest)) as GetNetworkStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNetworkStatusRequest create() => GetNetworkStatusRequest._();
  GetNetworkStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetNetworkStatusRequest> createRepeated() => $pb.PbList<GetNetworkStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetNetworkStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNetworkStatusRequest>(create);
  static GetNetworkStatusRequest? _defaultInstance;
}

class NetworkPath extends $pb.GeneratedMessage {
  factory NetworkPath({
    $core.Iterable<$core.String>? ipv4Addresses,
  }) {
    final $result = create();
    if (ipv4Addresses != null) {
      $result.ipv4Addresses.addAll(ipv4Addresses);
    }
    return $result;
  }
  NetworkPath._() : super();
  factory NetworkPath.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NetworkPath.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NetworkPath', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'ipv4Addresses')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NetworkPath clone() => NetworkPath()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NetworkPath copyWith(void Function(NetworkPath) updates) => super.copyWith((message) => updates(message as NetworkPath)) as NetworkPath;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NetworkPath create() => NetworkPath._();
  NetworkPath createEmptyInstance() => create();
  static $pb.PbList<NetworkPath> createRepeated() => $pb.PbList<NetworkPath>();
  @$core.pragma('dart2js:noInline')
  static NetworkPath getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkPath>(create);
  static NetworkPath? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get ipv4Addresses => $_getList(0);
}

enum GetNetworkStatusResponse_State {
  idle, 
  connecting, 
  connected, 
  error, 
  notSet
}

class GetNetworkStatusResponse extends $pb.GeneratedMessage {
  factory GetNetworkStatusResponse({
    $0.Empty? idle,
    $0.Empty? connecting,
    NetworkPath? connected,
    $core.String? error,
  }) {
    final $result = create();
    if (idle != null) {
      $result.idle = idle;
    }
    if (connecting != null) {
      $result.connecting = connecting;
    }
    if (connected != null) {
      $result.connected = connected;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  GetNetworkStatusResponse._() : super();
  factory GetNetworkStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNetworkStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GetNetworkStatusResponse_State> _GetNetworkStatusResponse_StateByTag = {
    1 : GetNetworkStatusResponse_State.idle,
    2 : GetNetworkStatusResponse_State.connecting,
    3 : GetNetworkStatusResponse_State.connected,
    4 : GetNetworkStatusResponse_State.error,
    0 : GetNetworkStatusResponse_State.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNetworkStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<$0.Empty>(1, _omitFieldNames ? '' : 'idle', subBuilder: $0.Empty.create)
    ..aOM<$0.Empty>(2, _omitFieldNames ? '' : 'connecting', subBuilder: $0.Empty.create)
    ..aOM<NetworkPath>(3, _omitFieldNames ? '' : 'connected', subBuilder: NetworkPath.create)
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNetworkStatusResponse clone() => GetNetworkStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNetworkStatusResponse copyWith(void Function(GetNetworkStatusResponse) updates) => super.copyWith((message) => updates(message as GetNetworkStatusResponse)) as GetNetworkStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNetworkStatusResponse create() => GetNetworkStatusResponse._();
  GetNetworkStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetNetworkStatusResponse> createRepeated() => $pb.PbList<GetNetworkStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetNetworkStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNetworkStatusResponse>(create);
  static GetNetworkStatusResponse? _defaultInstance;

  GetNetworkStatusResponse_State whichState() => _GetNetworkStatusResponse_StateByTag[$_whichOneof(0)]!;
  void clearState() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Empty get idle => $_getN(0);
  @$pb.TagNumber(1)
  set idle($0.Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdle() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdle() => clearField(1);
  @$pb.TagNumber(1)
  $0.Empty ensureIdle() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Empty get connecting => $_getN(1);
  @$pb.TagNumber(2)
  set connecting($0.Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnecting() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnecting() => clearField(2);
  @$pb.TagNumber(2)
  $0.Empty ensureConnecting() => $_ensure(1);

  @$pb.TagNumber(3)
  NetworkPath get connected => $_getN(2);
  @$pb.TagNumber(3)
  set connected(NetworkPath v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConnected() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnected() => clearField(3);
  @$pb.TagNumber(3)
  NetworkPath ensureConnected() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
