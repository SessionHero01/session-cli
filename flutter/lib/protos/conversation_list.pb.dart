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

import 'avatar.pb.dart' as $2;
import 'conversation_list.pbenum.dart';
import 'message.pb.dart' as $4;

export 'conversation_list.pbenum.dart';

enum ConversationSummary_Avatar {
  multipleAvatar, 
  singleAvatar, 
  notSet
}

class ConversationSummary extends $pb.GeneratedMessage {
  factory ConversationSummary({
    $core.String? id,
    $core.int? unreadCount,
    ConversationType? type,
    $core.String? name,
    $2.GroupMemberAvatarList? multipleAvatar,
    $2.Avatar? singleAvatar,
    $4.Message? lastMessage,
    $core.bool? approved,
    $core.bool? mentionedMe,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (unreadCount != null) {
      $result.unreadCount = unreadCount;
    }
    if (type != null) {
      $result.type = type;
    }
    if (name != null) {
      $result.name = name;
    }
    if (multipleAvatar != null) {
      $result.multipleAvatar = multipleAvatar;
    }
    if (singleAvatar != null) {
      $result.singleAvatar = singleAvatar;
    }
    if (lastMessage != null) {
      $result.lastMessage = lastMessage;
    }
    if (approved != null) {
      $result.approved = approved;
    }
    if (mentionedMe != null) {
      $result.mentionedMe = mentionedMe;
    }
    return $result;
  }
  ConversationSummary._() : super();
  factory ConversationSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConversationSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ConversationSummary_Avatar> _ConversationSummary_AvatarByTag = {
    5 : ConversationSummary_Avatar.multipleAvatar,
    6 : ConversationSummary_Avatar.singleAvatar,
    0 : ConversationSummary_Avatar.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConversationSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [5, 6])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'unreadCount', $pb.PbFieldType.QU3)
    ..e<ConversationType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: ConversationType.GROUP, valueOf: ConversationType.valueOf, enumValues: ConversationType.values)
    ..aQS(4, _omitFieldNames ? '' : 'name')
    ..aOM<$2.GroupMemberAvatarList>(5, _omitFieldNames ? '' : 'multipleAvatar', subBuilder: $2.GroupMemberAvatarList.create)
    ..aOM<$2.Avatar>(6, _omitFieldNames ? '' : 'singleAvatar', subBuilder: $2.Avatar.create)
    ..aOM<$4.Message>(7, _omitFieldNames ? '' : 'lastMessage', subBuilder: $4.Message.create)
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'approved', $pb.PbFieldType.QB)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'mentionedMe', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConversationSummary clone() => ConversationSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConversationSummary copyWith(void Function(ConversationSummary) updates) => super.copyWith((message) => updates(message as ConversationSummary)) as ConversationSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConversationSummary create() => ConversationSummary._();
  ConversationSummary createEmptyInstance() => create();
  static $pb.PbList<ConversationSummary> createRepeated() => $pb.PbList<ConversationSummary>();
  @$core.pragma('dart2js:noInline')
  static ConversationSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConversationSummary>(create);
  static ConversationSummary? _defaultInstance;

  ConversationSummary_Avatar whichAvatar() => _ConversationSummary_AvatarByTag[$_whichOneof(0)]!;
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
  $core.int get unreadCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set unreadCount($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUnreadCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreadCount() => clearField(2);

  @$pb.TagNumber(3)
  ConversationType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(ConversationType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

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
  $2.Avatar get singleAvatar => $_getN(5);
  @$pb.TagNumber(6)
  set singleAvatar($2.Avatar v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSingleAvatar() => $_has(5);
  @$pb.TagNumber(6)
  void clearSingleAvatar() => clearField(6);
  @$pb.TagNumber(6)
  $2.Avatar ensureSingleAvatar() => $_ensure(5);

  @$pb.TagNumber(7)
  $4.Message get lastMessage => $_getN(6);
  @$pb.TagNumber(7)
  set lastMessage($4.Message v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLastMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastMessage() => clearField(7);
  @$pb.TagNumber(7)
  $4.Message ensureLastMessage() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get approved => $_getBF(7);
  @$pb.TagNumber(8)
  set approved($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasApproved() => $_has(7);
  @$pb.TagNumber(8)
  void clearApproved() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get mentionedMe => $_getBF(8);
  @$pb.TagNumber(9)
  set mentionedMe($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMentionedMe() => $_has(8);
  @$pb.TagNumber(9)
  void clearMentionedMe() => clearField(9);
}

class ListConversationsRequest extends $pb.GeneratedMessage {
  factory ListConversationsRequest({
    $core.bool? approved,
  }) {
    final $result = create();
    if (approved != null) {
      $result.approved = approved;
    }
    return $result;
  }
  ListConversationsRequest._() : super();
  factory ListConversationsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListConversationsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListConversationsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'approved')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListConversationsRequest clone() => ListConversationsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListConversationsRequest copyWith(void Function(ListConversationsRequest) updates) => super.copyWith((message) => updates(message as ListConversationsRequest)) as ListConversationsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConversationsRequest create() => ListConversationsRequest._();
  ListConversationsRequest createEmptyInstance() => create();
  static $pb.PbList<ListConversationsRequest> createRepeated() => $pb.PbList<ListConversationsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListConversationsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListConversationsRequest>(create);
  static ListConversationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get approved => $_getBF(0);
  @$pb.TagNumber(1)
  set approved($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasApproved() => $_has(0);
  @$pb.TagNumber(1)
  void clearApproved() => clearField(1);
}

class ListConversationsResponse extends $pb.GeneratedMessage {
  factory ListConversationsResponse({
    $core.Iterable<ConversationSummary>? conversations,
  }) {
    final $result = create();
    if (conversations != null) {
      $result.conversations.addAll(conversations);
    }
    return $result;
  }
  ListConversationsResponse._() : super();
  factory ListConversationsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListConversationsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListConversationsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<ConversationSummary>(1, _omitFieldNames ? '' : 'conversations', $pb.PbFieldType.PM, subBuilder: ConversationSummary.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListConversationsResponse clone() => ListConversationsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListConversationsResponse copyWith(void Function(ListConversationsResponse) updates) => super.copyWith((message) => updates(message as ListConversationsResponse)) as ListConversationsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListConversationsResponse create() => ListConversationsResponse._();
  ListConversationsResponse createEmptyInstance() => create();
  static $pb.PbList<ListConversationsResponse> createRepeated() => $pb.PbList<ListConversationsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListConversationsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListConversationsResponse>(create);
  static ListConversationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ConversationSummary> get conversations => $_getList(0);
}

class LoadMoreCommunityMessagesRequest extends $pb.GeneratedMessage {
  factory LoadMoreCommunityMessagesRequest({
    $core.String? communityId,
  }) {
    final $result = create();
    if (communityId != null) {
      $result.communityId = communityId;
    }
    return $result;
  }
  LoadMoreCommunityMessagesRequest._() : super();
  factory LoadMoreCommunityMessagesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoadMoreCommunityMessagesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoadMoreCommunityMessagesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'communityId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoadMoreCommunityMessagesRequest clone() => LoadMoreCommunityMessagesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoadMoreCommunityMessagesRequest copyWith(void Function(LoadMoreCommunityMessagesRequest) updates) => super.copyWith((message) => updates(message as LoadMoreCommunityMessagesRequest)) as LoadMoreCommunityMessagesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadMoreCommunityMessagesRequest create() => LoadMoreCommunityMessagesRequest._();
  LoadMoreCommunityMessagesRequest createEmptyInstance() => create();
  static $pb.PbList<LoadMoreCommunityMessagesRequest> createRepeated() => $pb.PbList<LoadMoreCommunityMessagesRequest>();
  @$core.pragma('dart2js:noInline')
  static LoadMoreCommunityMessagesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoadMoreCommunityMessagesRequest>(create);
  static LoadMoreCommunityMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get communityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set communityId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommunityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommunityId() => clearField(1);
}

class LoadMoreCommunityMessagesResponse extends $pb.GeneratedMessage {
  factory LoadMoreCommunityMessagesResponse() => create();
  LoadMoreCommunityMessagesResponse._() : super();
  factory LoadMoreCommunityMessagesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoadMoreCommunityMessagesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoadMoreCommunityMessagesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoadMoreCommunityMessagesResponse clone() => LoadMoreCommunityMessagesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoadMoreCommunityMessagesResponse copyWith(void Function(LoadMoreCommunityMessagesResponse) updates) => super.copyWith((message) => updates(message as LoadMoreCommunityMessagesResponse)) as LoadMoreCommunityMessagesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadMoreCommunityMessagesResponse create() => LoadMoreCommunityMessagesResponse._();
  LoadMoreCommunityMessagesResponse createEmptyInstance() => create();
  static $pb.PbList<LoadMoreCommunityMessagesResponse> createRepeated() => $pb.PbList<LoadMoreCommunityMessagesResponse>();
  @$core.pragma('dart2js:noInline')
  static LoadMoreCommunityMessagesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoadMoreCommunityMessagesResponse>(create);
  static LoadMoreCommunityMessagesResponse? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
