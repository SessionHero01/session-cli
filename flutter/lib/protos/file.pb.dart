//
//  Generated code. Do not modify.
//  source: protos/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $0;

class EncryptedFile extends $pb.GeneratedMessage {
  factory EncryptedFile({
    $core.String? url,
    $core.String? key,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (key != null) {
      $result.key = key;
    }
    return $result;
  }
  EncryptedFile._() : super();
  factory EncryptedFile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EncryptedFile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EncryptedFile', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'url')
    ..aQS(2, _omitFieldNames ? '' : 'key')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EncryptedFile clone() => EncryptedFile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EncryptedFile copyWith(void Function(EncryptedFile) updates) => super.copyWith((message) => updates(message as EncryptedFile)) as EncryptedFile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EncryptedFile create() => EncryptedFile._();
  EncryptedFile createEmptyInstance() => create();
  static $pb.PbList<EncryptedFile> createRepeated() => $pb.PbList<EncryptedFile>();
  @$core.pragma('dart2js:noInline')
  static EncryptedFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EncryptedFile>(create);
  static EncryptedFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);
}

class CommunityFile extends $pb.GeneratedMessage {
  factory CommunityFile({
    $core.String? communityUrl,
    $fixnum.Int64? communityFileId,
  }) {
    final $result = create();
    if (communityUrl != null) {
      $result.communityUrl = communityUrl;
    }
    if (communityFileId != null) {
      $result.communityFileId = communityFileId;
    }
    return $result;
  }
  CommunityFile._() : super();
  factory CommunityFile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommunityFile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommunityFile', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'communityUrl')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'communityFileId', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommunityFile clone() => CommunityFile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommunityFile copyWith(void Function(CommunityFile) updates) => super.copyWith((message) => updates(message as CommunityFile)) as CommunityFile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommunityFile create() => CommunityFile._();
  CommunityFile createEmptyInstance() => create();
  static $pb.PbList<CommunityFile> createRepeated() => $pb.PbList<CommunityFile>();
  @$core.pragma('dart2js:noInline')
  static CommunityFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommunityFile>(create);
  static CommunityFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get communityUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set communityUrl($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommunityUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommunityUrl() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get communityFileId => $_getI64(1);
  @$pb.TagNumber(2)
  set communityFileId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommunityFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunityFileId() => clearField(2);
}

enum TrimFileCacheRequest_Keep {
  keepDefault, 
  keepDays, 
  notSet
}

class TrimFileCacheRequest extends $pb.GeneratedMessage {
  factory TrimFileCacheRequest({
    $0.Empty? keepDefault,
    $core.int? keepDays,
  }) {
    final $result = create();
    if (keepDefault != null) {
      $result.keepDefault = keepDefault;
    }
    if (keepDays != null) {
      $result.keepDays = keepDays;
    }
    return $result;
  }
  TrimFileCacheRequest._() : super();
  factory TrimFileCacheRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrimFileCacheRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TrimFileCacheRequest_Keep> _TrimFileCacheRequest_KeepByTag = {
    1 : TrimFileCacheRequest_Keep.keepDefault,
    2 : TrimFileCacheRequest_Keep.keepDays,
    0 : TrimFileCacheRequest_Keep.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrimFileCacheRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<$0.Empty>(1, _omitFieldNames ? '' : 'keepDefault', subBuilder: $0.Empty.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'keepDays', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrimFileCacheRequest clone() => TrimFileCacheRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrimFileCacheRequest copyWith(void Function(TrimFileCacheRequest) updates) => super.copyWith((message) => updates(message as TrimFileCacheRequest)) as TrimFileCacheRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrimFileCacheRequest create() => TrimFileCacheRequest._();
  TrimFileCacheRequest createEmptyInstance() => create();
  static $pb.PbList<TrimFileCacheRequest> createRepeated() => $pb.PbList<TrimFileCacheRequest>();
  @$core.pragma('dart2js:noInline')
  static TrimFileCacheRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrimFileCacheRequest>(create);
  static TrimFileCacheRequest? _defaultInstance;

  TrimFileCacheRequest_Keep whichKeep() => _TrimFileCacheRequest_KeepByTag[$_whichOneof(0)]!;
  void clearKeep() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Empty get keepDefault => $_getN(0);
  @$pb.TagNumber(1)
  set keepDefault($0.Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasKeepDefault() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeepDefault() => clearField(1);
  @$pb.TagNumber(1)
  $0.Empty ensureKeepDefault() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get keepDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set keepDays($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeepDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeepDays() => clearField(2);
}

class TrimFileCacheResponse extends $pb.GeneratedMessage {
  factory TrimFileCacheResponse({
    $core.int? numDeleted,
  }) {
    final $result = create();
    if (numDeleted != null) {
      $result.numDeleted = numDeleted;
    }
    return $result;
  }
  TrimFileCacheResponse._() : super();
  factory TrimFileCacheResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrimFileCacheResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrimFileCacheResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'numDeleted', $pb.PbFieldType.QU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrimFileCacheResponse clone() => TrimFileCacheResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrimFileCacheResponse copyWith(void Function(TrimFileCacheResponse) updates) => super.copyWith((message) => updates(message as TrimFileCacheResponse)) as TrimFileCacheResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrimFileCacheResponse create() => TrimFileCacheResponse._();
  TrimFileCacheResponse createEmptyInstance() => create();
  static $pb.PbList<TrimFileCacheResponse> createRepeated() => $pb.PbList<TrimFileCacheResponse>();
  @$core.pragma('dart2js:noInline')
  static TrimFileCacheResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrimFileCacheResponse>(create);
  static TrimFileCacheResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numDeleted => $_getIZ(0);
  @$pb.TagNumber(1)
  set numDeleted($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumDeleted() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumDeleted() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
