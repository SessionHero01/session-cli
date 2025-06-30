//
//  Generated code. Do not modify.
//  source: protos/avatar.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $0;
import 'file.pb.dart' as $1;

enum Avatar_Image {
  image, 
  communityImage, 
  empty, 
  notSet
}

class Avatar extends $pb.GeneratedMessage {
  factory Avatar({
    $1.EncryptedFile? image,
    $1.CommunityFile? communityImage,
    $0.Empty? empty,
    $core.bool? isModerator,
    $core.String? fallbackText,
  }) {
    final $result = create();
    if (image != null) {
      $result.image = image;
    }
    if (communityImage != null) {
      $result.communityImage = communityImage;
    }
    if (empty != null) {
      $result.empty = empty;
    }
    if (isModerator != null) {
      $result.isModerator = isModerator;
    }
    if (fallbackText != null) {
      $result.fallbackText = fallbackText;
    }
    return $result;
  }
  Avatar._() : super();
  factory Avatar.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Avatar.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Avatar_Image> _Avatar_ImageByTag = {
    1 : Avatar_Image.image,
    2 : Avatar_Image.communityImage,
    3 : Avatar_Image.empty,
    0 : Avatar_Image.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Avatar', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<$1.EncryptedFile>(1, _omitFieldNames ? '' : 'image', subBuilder: $1.EncryptedFile.create)
    ..aOM<$1.CommunityFile>(2, _omitFieldNames ? '' : 'communityImage', subBuilder: $1.CommunityFile.create)
    ..aOM<$0.Empty>(3, _omitFieldNames ? '' : 'empty', subBuilder: $0.Empty.create)
    ..aOB(4, _omitFieldNames ? '' : 'isModerator')
    ..aOS(11, _omitFieldNames ? '' : 'fallbackText')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Avatar clone() => Avatar()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Avatar copyWith(void Function(Avatar) updates) => super.copyWith((message) => updates(message as Avatar)) as Avatar;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Avatar create() => Avatar._();
  Avatar createEmptyInstance() => create();
  static $pb.PbList<Avatar> createRepeated() => $pb.PbList<Avatar>();
  @$core.pragma('dart2js:noInline')
  static Avatar getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Avatar>(create);
  static Avatar? _defaultInstance;

  Avatar_Image whichImage_() => _Avatar_ImageByTag[$_whichOneof(0)]!;
  void clearImage_() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.EncryptedFile get image => $_getN(0);
  @$pb.TagNumber(1)
  set image($1.EncryptedFile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => clearField(1);
  @$pb.TagNumber(1)
  $1.EncryptedFile ensureImage() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.CommunityFile get communityImage => $_getN(1);
  @$pb.TagNumber(2)
  set communityImage($1.CommunityFile v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommunityImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunityImage() => clearField(2);
  @$pb.TagNumber(2)
  $1.CommunityFile ensureCommunityImage() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Empty get empty => $_getN(2);
  @$pb.TagNumber(3)
  set empty($0.Empty v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmpty() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmpty() => clearField(3);
  @$pb.TagNumber(3)
  $0.Empty ensureEmpty() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isModerator => $_getBF(3);
  @$pb.TagNumber(4)
  set isModerator($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsModerator() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsModerator() => clearField(4);

  @$pb.TagNumber(11)
  $core.String get fallbackText => $_getSZ(4);
  @$pb.TagNumber(11)
  set fallbackText($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(11)
  $core.bool hasFallbackText() => $_has(4);
  @$pb.TagNumber(11)
  void clearFallbackText() => clearField(11);
}

class GroupMemberAvatarList extends $pb.GeneratedMessage {
  factory GroupMemberAvatarList({
    $core.Iterable<Avatar>? avatars,
  }) {
    final $result = create();
    if (avatars != null) {
      $result.avatars.addAll(avatars);
    }
    return $result;
  }
  GroupMemberAvatarList._() : super();
  factory GroupMemberAvatarList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupMemberAvatarList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GroupMemberAvatarList', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<Avatar>(1, _omitFieldNames ? '' : 'avatars', $pb.PbFieldType.PM, subBuilder: Avatar.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupMemberAvatarList clone() => GroupMemberAvatarList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupMemberAvatarList copyWith(void Function(GroupMemberAvatarList) updates) => super.copyWith((message) => updates(message as GroupMemberAvatarList)) as GroupMemberAvatarList;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberAvatarList create() => GroupMemberAvatarList._();
  GroupMemberAvatarList createEmptyInstance() => create();
  static $pb.PbList<GroupMemberAvatarList> createRepeated() => $pb.PbList<GroupMemberAvatarList>();
  @$core.pragma('dart2js:noInline')
  static GroupMemberAvatarList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupMemberAvatarList>(create);
  static GroupMemberAvatarList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Avatar> get avatars => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
