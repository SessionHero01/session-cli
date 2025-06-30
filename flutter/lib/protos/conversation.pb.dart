//
//  Generated code. Do not modify.
//  source: protos/conversation.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'avatar.pb.dart' as $2;
import 'message.pb.dart' as $4;

enum ConversationDetails_Avatar {
  singleAvatar, 
  multipleAvatar, 
  notSet
}

class ConversationDetails extends $pb.GeneratedMessage {
  factory ConversationDetails({
    $core.String? id,
    $core.String? name,
    $core.int? unreadCount,
    $2.Avatar? singleAvatar,
    $2.GroupMemberAvatarList? multipleAvatar,
    $core.int? activeCommunityMembers,
    $core.int? totalGroupMembers,
    $core.bool? canPostText,
    $core.bool? canUpload,
    $core.bool? approved,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (unreadCount != null) {
      $result.unreadCount = unreadCount;
    }
    if (singleAvatar != null) {
      $result.singleAvatar = singleAvatar;
    }
    if (multipleAvatar != null) {
      $result.multipleAvatar = multipleAvatar;
    }
    if (activeCommunityMembers != null) {
      $result.activeCommunityMembers = activeCommunityMembers;
    }
    if (totalGroupMembers != null) {
      $result.totalGroupMembers = totalGroupMembers;
    }
    if (canPostText != null) {
      $result.canPostText = canPostText;
    }
    if (canUpload != null) {
      $result.canUpload = canUpload;
    }
    if (approved != null) {
      $result.approved = approved;
    }
    return $result;
  }
  ConversationDetails._() : super();
  factory ConversationDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConversationDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ConversationDetails_Avatar> _ConversationDetails_AvatarByTag = {
    4 : ConversationDetails_Avatar.singleAvatar,
    5 : ConversationDetails_Avatar.multipleAvatar,
    0 : ConversationDetails_Avatar.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConversationDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [4, 5])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'unreadCount', $pb.PbFieldType.Q3)
    ..aOM<$2.Avatar>(4, _omitFieldNames ? '' : 'singleAvatar', subBuilder: $2.Avatar.create)
    ..aOM<$2.GroupMemberAvatarList>(5, _omitFieldNames ? '' : 'multipleAvatar', subBuilder: $2.GroupMemberAvatarList.create)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'activeCommunityMembers', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'totalGroupMembers', $pb.PbFieldType.O3)
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'canPostText', $pb.PbFieldType.QB)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'canUpload', $pb.PbFieldType.QB)
    ..a<$core.bool>(10, _omitFieldNames ? '' : 'approved', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConversationDetails clone() => ConversationDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConversationDetails copyWith(void Function(ConversationDetails) updates) => super.copyWith((message) => updates(message as ConversationDetails)) as ConversationDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConversationDetails create() => ConversationDetails._();
  ConversationDetails createEmptyInstance() => create();
  static $pb.PbList<ConversationDetails> createRepeated() => $pb.PbList<ConversationDetails>();
  @$core.pragma('dart2js:noInline')
  static ConversationDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConversationDetails>(create);
  static ConversationDetails? _defaultInstance;

  ConversationDetails_Avatar whichAvatar() => _ConversationDetails_AvatarByTag[$_whichOneof(0)]!;
  void clearAvatar() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get unreadCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUnreadCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadCount() => clearField(3);

  @$pb.TagNumber(4)
  $2.Avatar get singleAvatar => $_getN(3);
  @$pb.TagNumber(4)
  set singleAvatar($2.Avatar v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSingleAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearSingleAvatar() => clearField(4);
  @$pb.TagNumber(4)
  $2.Avatar ensureSingleAvatar() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.GroupMemberAvatarList get multipleAvatar => $_getN(4);
  @$pb.TagNumber(5)
  set multipleAvatar($2.GroupMemberAvatarList v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMultipleAvatar() => $_has(4);
  @$pb.TagNumber(5)
  void clearMultipleAvatar() => clearField(5);
  @$pb.TagNumber(5)
  $2.GroupMemberAvatarList ensureMultipleAvatar() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get activeCommunityMembers => $_getIZ(5);
  @$pb.TagNumber(6)
  set activeCommunityMembers($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasActiveCommunityMembers() => $_has(5);
  @$pb.TagNumber(6)
  void clearActiveCommunityMembers() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalGroupMembers => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalGroupMembers($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalGroupMembers() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalGroupMembers() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get canPostText => $_getBF(7);
  @$pb.TagNumber(8)
  set canPostText($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCanPostText() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanPostText() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get canUpload => $_getBF(8);
  @$pb.TagNumber(9)
  set canUpload($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCanUpload() => $_has(8);
  @$pb.TagNumber(9)
  void clearCanUpload() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get approved => $_getBF(9);
  @$pb.TagNumber(10)
  set approved($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasApproved() => $_has(9);
  @$pb.TagNumber(10)
  void clearApproved() => clearField(10);
}

class GetConversationDetailsRequest extends $pb.GeneratedMessage {
  factory GetConversationDetailsRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetConversationDetailsRequest._() : super();
  factory GetConversationDetailsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetConversationDetailsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetConversationDetailsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetConversationDetailsRequest clone() => GetConversationDetailsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetConversationDetailsRequest copyWith(void Function(GetConversationDetailsRequest) updates) => super.copyWith((message) => updates(message as GetConversationDetailsRequest)) as GetConversationDetailsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConversationDetailsRequest create() => GetConversationDetailsRequest._();
  GetConversationDetailsRequest createEmptyInstance() => create();
  static $pb.PbList<GetConversationDetailsRequest> createRepeated() => $pb.PbList<GetConversationDetailsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetConversationDetailsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetConversationDetailsRequest>(create);
  static GetConversationDetailsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class GetConversationDetailsResponse extends $pb.GeneratedMessage {
  factory GetConversationDetailsResponse({
    ConversationDetails? details,
  }) {
    final $result = create();
    if (details != null) {
      $result.details = details;
    }
    return $result;
  }
  GetConversationDetailsResponse._() : super();
  factory GetConversationDetailsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetConversationDetailsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetConversationDetailsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aOM<ConversationDetails>(1, _omitFieldNames ? '' : 'details', subBuilder: ConversationDetails.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetConversationDetailsResponse clone() => GetConversationDetailsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetConversationDetailsResponse copyWith(void Function(GetConversationDetailsResponse) updates) => super.copyWith((message) => updates(message as GetConversationDetailsResponse)) as GetConversationDetailsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConversationDetailsResponse create() => GetConversationDetailsResponse._();
  GetConversationDetailsResponse createEmptyInstance() => create();
  static $pb.PbList<GetConversationDetailsResponse> createRepeated() => $pb.PbList<GetConversationDetailsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetConversationDetailsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetConversationDetailsResponse>(create);
  static GetConversationDetailsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ConversationDetails get details => $_getN(0);
  @$pb.TagNumber(1)
  set details(ConversationDetails v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDetails() => $_has(0);
  @$pb.TagNumber(1)
  void clearDetails() => clearField(1);
  @$pb.TagNumber(1)
  ConversationDetails ensureDetails() => $_ensure(0);
}

enum GetConversationMessagesRequest_Earlier {
  limit, 
  after, 
  notSet
}

class GetConversationMessagesRequest extends $pb.GeneratedMessage {
  factory GetConversationMessagesRequest({
    $core.String? id,
    $fixnum.Int64? until,
    $core.int? limit,
    $fixnum.Int64? after,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (until != null) {
      $result.until = until;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (after != null) {
      $result.after = after;
    }
    return $result;
  }
  GetConversationMessagesRequest._() : super();
  factory GetConversationMessagesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetConversationMessagesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GetConversationMessagesRequest_Earlier> _GetConversationMessagesRequest_EarlierByTag = {
    3 : GetConversationMessagesRequest_Earlier.limit,
    4 : GetConversationMessagesRequest_Earlier.after,
    0 : GetConversationMessagesRequest_Earlier.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetConversationMessagesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'until', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'after', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetConversationMessagesRequest clone() => GetConversationMessagesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetConversationMessagesRequest copyWith(void Function(GetConversationMessagesRequest) updates) => super.copyWith((message) => updates(message as GetConversationMessagesRequest)) as GetConversationMessagesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConversationMessagesRequest create() => GetConversationMessagesRequest._();
  GetConversationMessagesRequest createEmptyInstance() => create();
  static $pb.PbList<GetConversationMessagesRequest> createRepeated() => $pb.PbList<GetConversationMessagesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetConversationMessagesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetConversationMessagesRequest>(create);
  static GetConversationMessagesRequest? _defaultInstance;

  GetConversationMessagesRequest_Earlier whichEarlier() => _GetConversationMessagesRequest_EarlierByTag[$_whichOneof(0)]!;
  void clearEarlier() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get until => $_getI64(1);
  @$pb.TagNumber(2)
  set until($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUntil() => $_has(1);
  @$pb.TagNumber(2)
  void clearUntil() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get after => $_getI64(3);
  @$pb.TagNumber(4)
  set after($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAfter() => $_has(3);
  @$pb.TagNumber(4)
  void clearAfter() => clearField(4);
}

class GetConversationMessagesResponse extends $pb.GeneratedMessage {
  factory GetConversationMessagesResponse({
    $core.Iterable<$4.Message>? messages,
  }) {
    final $result = create();
    if (messages != null) {
      $result.messages.addAll(messages);
    }
    return $result;
  }
  GetConversationMessagesResponse._() : super();
  factory GetConversationMessagesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetConversationMessagesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetConversationMessagesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<$4.Message>(1, _omitFieldNames ? '' : 'messages', $pb.PbFieldType.PM, subBuilder: $4.Message.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetConversationMessagesResponse clone() => GetConversationMessagesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetConversationMessagesResponse copyWith(void Function(GetConversationMessagesResponse) updates) => super.copyWith((message) => updates(message as GetConversationMessagesResponse)) as GetConversationMessagesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConversationMessagesResponse create() => GetConversationMessagesResponse._();
  GetConversationMessagesResponse createEmptyInstance() => create();
  static $pb.PbList<GetConversationMessagesResponse> createRepeated() => $pb.PbList<GetConversationMessagesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetConversationMessagesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetConversationMessagesResponse>(create);
  static GetConversationMessagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$4.Message> get messages => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
