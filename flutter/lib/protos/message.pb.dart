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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $0;
import 'avatar.pb.dart' as $2;
import 'control_messages.pb.dart' as $3;
import 'file.pb.dart' as $1;
import 'message.pbenum.dart';

export 'message.pbenum.dart';

enum UserName_Name {
  me, 
  other, 
  notSet
}

class UserName extends $pb.GeneratedMessage {
  factory UserName({
    $0.Empty? me,
    $core.String? other,
  }) {
    final $result = create();
    if (me != null) {
      $result.me = me;
    }
    if (other != null) {
      $result.other = other;
    }
    return $result;
  }
  UserName._() : super();
  factory UserName.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserName.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, UserName_Name> _UserName_NameByTag = {
    1 : UserName_Name.me,
    2 : UserName_Name.other,
    0 : UserName_Name.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserName', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<$0.Empty>(1, _omitFieldNames ? '' : 'me', subBuilder: $0.Empty.create)
    ..aOS(2, _omitFieldNames ? '' : 'other')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserName clone() => UserName()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserName copyWith(void Function(UserName) updates) => super.copyWith((message) => updates(message as UserName)) as UserName;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserName create() => UserName._();
  UserName createEmptyInstance() => create();
  static $pb.PbList<UserName> createRepeated() => $pb.PbList<UserName>();
  @$core.pragma('dart2js:noInline')
  static UserName getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserName>(create);
  static UserName? _defaultInstance;

  UserName_Name whichName() => _UserName_NameByTag[$_whichOneof(0)]!;
  void clearName() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Empty get me => $_getN(0);
  @$pb.TagNumber(1)
  set me($0.Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMe() => $_has(0);
  @$pb.TagNumber(1)
  void clearMe() => clearField(1);
  @$pb.TagNumber(1)
  $0.Empty ensureMe() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get other => $_getSZ(1);
  @$pb.TagNumber(2)
  set other($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOther() => $_has(1);
  @$pb.TagNumber(2)
  void clearOther() => clearField(2);
}

enum AttachmentContent_Content {
  file, 
  pendingAttachmentId, 
  communityFile, 
  notSet
}

class AttachmentContent extends $pb.GeneratedMessage {
  factory AttachmentContent({
    $1.EncryptedFile? file,
    $fixnum.Int64? pendingAttachmentId,
    $1.CommunityFile? communityFile,
  }) {
    final $result = create();
    if (file != null) {
      $result.file = file;
    }
    if (pendingAttachmentId != null) {
      $result.pendingAttachmentId = pendingAttachmentId;
    }
    if (communityFile != null) {
      $result.communityFile = communityFile;
    }
    return $result;
  }
  AttachmentContent._() : super();
  factory AttachmentContent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AttachmentContent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AttachmentContent_Content> _AttachmentContent_ContentByTag = {
    1 : AttachmentContent_Content.file,
    2 : AttachmentContent_Content.pendingAttachmentId,
    3 : AttachmentContent_Content.communityFile,
    0 : AttachmentContent_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AttachmentContent', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<$1.EncryptedFile>(1, _omitFieldNames ? '' : 'file', subBuilder: $1.EncryptedFile.create)
    ..aInt64(2, _omitFieldNames ? '' : 'pendingAttachmentId')
    ..aOM<$1.CommunityFile>(3, _omitFieldNames ? '' : 'communityFile', subBuilder: $1.CommunityFile.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AttachmentContent clone() => AttachmentContent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AttachmentContent copyWith(void Function(AttachmentContent) updates) => super.copyWith((message) => updates(message as AttachmentContent)) as AttachmentContent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachmentContent create() => AttachmentContent._();
  AttachmentContent createEmptyInstance() => create();
  static $pb.PbList<AttachmentContent> createRepeated() => $pb.PbList<AttachmentContent>();
  @$core.pragma('dart2js:noInline')
  static AttachmentContent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttachmentContent>(create);
  static AttachmentContent? _defaultInstance;

  AttachmentContent_Content whichContent() => _AttachmentContent_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.EncryptedFile get file => $_getN(0);
  @$pb.TagNumber(1)
  set file($1.EncryptedFile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => clearField(1);
  @$pb.TagNumber(1)
  $1.EncryptedFile ensureFile() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pendingAttachmentId => $_getI64(1);
  @$pb.TagNumber(2)
  set pendingAttachmentId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPendingAttachmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingAttachmentId() => clearField(2);

  @$pb.TagNumber(3)
  $1.CommunityFile get communityFile => $_getN(2);
  @$pb.TagNumber(3)
  set communityFile($1.CommunityFile v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommunityFile() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommunityFile() => clearField(3);
  @$pb.TagNumber(3)
  $1.CommunityFile ensureCommunityFile() => $_ensure(2);
}

class AudioAttachment extends $pb.GeneratedMessage {
  factory AudioAttachment({
    AttachmentContent? content,
    $fixnum.Int64? durationMills,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (durationMills != null) {
      $result.durationMills = durationMills;
    }
    return $result;
  }
  AudioAttachment._() : super();
  factory AudioAttachment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AudioAttachment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AudioAttachment', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQM<AttachmentContent>(1, _omitFieldNames ? '' : 'content', subBuilder: AttachmentContent.create)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'durationMills', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AudioAttachment clone() => AudioAttachment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AudioAttachment copyWith(void Function(AudioAttachment) updates) => super.copyWith((message) => updates(message as AudioAttachment)) as AudioAttachment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioAttachment create() => AudioAttachment._();
  AudioAttachment createEmptyInstance() => create();
  static $pb.PbList<AudioAttachment> createRepeated() => $pb.PbList<AudioAttachment>();
  @$core.pragma('dart2js:noInline')
  static AudioAttachment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AudioAttachment>(create);
  static AudioAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  AttachmentContent get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(AttachmentContent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
  @$pb.TagNumber(1)
  AttachmentContent ensureContent() => $_ensure(0);

  @$pb.TagNumber(3)
  $fixnum.Int64 get durationMills => $_getI64(1);
  @$pb.TagNumber(3)
  set durationMills($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasDurationMills() => $_has(1);
  @$pb.TagNumber(3)
  void clearDurationMills() => clearField(3);
}

class ImageAttachment extends $pb.GeneratedMessage {
  factory ImageAttachment({
    AttachmentContent? content,
    $core.int? width,
    $core.int? height,
    $core.List<$core.int>? thumbnail,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (thumbnail != null) {
      $result.thumbnail = thumbnail;
    }
    return $result;
  }
  ImageAttachment._() : super();
  factory ImageAttachment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageAttachment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageAttachment', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQM<AttachmentContent>(1, _omitFieldNames ? '' : 'content', subBuilder: AttachmentContent.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'thumbnail', $pb.PbFieldType.OY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageAttachment clone() => ImageAttachment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageAttachment copyWith(void Function(ImageAttachment) updates) => super.copyWith((message) => updates(message as ImageAttachment)) as ImageAttachment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageAttachment create() => ImageAttachment._();
  ImageAttachment createEmptyInstance() => create();
  static $pb.PbList<ImageAttachment> createRepeated() => $pb.PbList<ImageAttachment>();
  @$core.pragma('dart2js:noInline')
  static ImageAttachment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageAttachment>(create);
  static ImageAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  AttachmentContent get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(AttachmentContent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
  @$pb.TagNumber(1)
  AttachmentContent ensureContent() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get thumbnail => $_getN(3);
  @$pb.TagNumber(5)
  set thumbnail($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasThumbnail() => $_has(3);
  @$pb.TagNumber(5)
  void clearThumbnail() => clearField(5);
}

class ImageAttachments extends $pb.GeneratedMessage {
  factory ImageAttachments({
    $core.Iterable<ImageAttachment>? images,
  }) {
    final $result = create();
    if (images != null) {
      $result.images.addAll(images);
    }
    return $result;
  }
  ImageAttachments._() : super();
  factory ImageAttachments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageAttachments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageAttachments', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<ImageAttachment>(1, _omitFieldNames ? '' : 'images', $pb.PbFieldType.PM, subBuilder: ImageAttachment.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageAttachments clone() => ImageAttachments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageAttachments copyWith(void Function(ImageAttachments) updates) => super.copyWith((message) => updates(message as ImageAttachments)) as ImageAttachments;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageAttachments create() => ImageAttachments._();
  ImageAttachments createEmptyInstance() => create();
  static $pb.PbList<ImageAttachments> createRepeated() => $pb.PbList<ImageAttachments>();
  @$core.pragma('dart2js:noInline')
  static ImageAttachments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageAttachments>(create);
  static ImageAttachments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ImageAttachment> get images => $_getList(0);
}

class VideoAttachment extends $pb.GeneratedMessage {
  factory VideoAttachment({
    AttachmentContent? content,
    $core.int? width,
    $core.int? height,
    $fixnum.Int64? durationMills,
    $core.List<$core.int>? thumbnail,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (durationMills != null) {
      $result.durationMills = durationMills;
    }
    if (thumbnail != null) {
      $result.thumbnail = thumbnail;
    }
    return $result;
  }
  VideoAttachment._() : super();
  factory VideoAttachment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoAttachment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoAttachment', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQM<AttachmentContent>(1, _omitFieldNames ? '' : 'content', subBuilder: AttachmentContent.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'durationMills', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'thumbnail', $pb.PbFieldType.OY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoAttachment clone() => VideoAttachment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoAttachment copyWith(void Function(VideoAttachment) updates) => super.copyWith((message) => updates(message as VideoAttachment)) as VideoAttachment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoAttachment create() => VideoAttachment._();
  VideoAttachment createEmptyInstance() => create();
  static $pb.PbList<VideoAttachment> createRepeated() => $pb.PbList<VideoAttachment>();
  @$core.pragma('dart2js:noInline')
  static VideoAttachment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoAttachment>(create);
  static VideoAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  AttachmentContent get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(AttachmentContent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
  @$pb.TagNumber(1)
  AttachmentContent ensureContent() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get durationMills => $_getI64(3);
  @$pb.TagNumber(5)
  set durationMills($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasDurationMills() => $_has(3);
  @$pb.TagNumber(5)
  void clearDurationMills() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get thumbnail => $_getN(4);
  @$pb.TagNumber(6)
  set thumbnail($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasThumbnail() => $_has(4);
  @$pb.TagNumber(6)
  void clearThumbnail() => clearField(6);
}

class VideoAttachments extends $pb.GeneratedMessage {
  factory VideoAttachments({
    $core.Iterable<VideoAttachment>? videos,
  }) {
    final $result = create();
    if (videos != null) {
      $result.videos.addAll(videos);
    }
    return $result;
  }
  VideoAttachments._() : super();
  factory VideoAttachments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoAttachments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VideoAttachments', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<VideoAttachment>(1, _omitFieldNames ? '' : 'videos', $pb.PbFieldType.PM, subBuilder: VideoAttachment.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoAttachments clone() => VideoAttachments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoAttachments copyWith(void Function(VideoAttachments) updates) => super.copyWith((message) => updates(message as VideoAttachments)) as VideoAttachments;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoAttachments create() => VideoAttachments._();
  VideoAttachments createEmptyInstance() => create();
  static $pb.PbList<VideoAttachments> createRepeated() => $pb.PbList<VideoAttachments>();
  @$core.pragma('dart2js:noInline')
  static VideoAttachments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoAttachments>(create);
  static VideoAttachments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<VideoAttachment> get videos => $_getList(0);
}

class FileAttachment extends $pb.GeneratedMessage {
  factory FileAttachment({
    AttachmentContent? content,
    $core.String? fileName,
    $core.int? size,
    $core.List<$core.int>? thumbnail,
    $core.String? contentType,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (size != null) {
      $result.size = size;
    }
    if (thumbnail != null) {
      $result.thumbnail = thumbnail;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    return $result;
  }
  FileAttachment._() : super();
  factory FileAttachment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileAttachment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileAttachment', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQM<AttachmentContent>(1, _omitFieldNames ? '' : 'content', subBuilder: AttachmentContent.create)
    ..aOS(3, _omitFieldNames ? '' : 'fileName')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'thumbnail', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'contentType')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileAttachment clone() => FileAttachment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileAttachment copyWith(void Function(FileAttachment) updates) => super.copyWith((message) => updates(message as FileAttachment)) as FileAttachment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileAttachment create() => FileAttachment._();
  FileAttachment createEmptyInstance() => create();
  static $pb.PbList<FileAttachment> createRepeated() => $pb.PbList<FileAttachment>();
  @$core.pragma('dart2js:noInline')
  static FileAttachment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileAttachment>(create);
  static FileAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  AttachmentContent get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(AttachmentContent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
  @$pb.TagNumber(1)
  AttachmentContent ensureContent() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(3)
  set fileName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(3)
  void clearFileName() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(4)
  set size($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get thumbnail => $_getN(3);
  @$pb.TagNumber(5)
  set thumbnail($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasThumbnail() => $_has(3);
  @$pb.TagNumber(5)
  void clearThumbnail() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get contentType => $_getSZ(4);
  @$pb.TagNumber(6)
  set contentType($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(6)
  void clearContentType() => clearField(6);
}

class FileAttachments extends $pb.GeneratedMessage {
  factory FileAttachments({
    $core.Iterable<FileAttachment>? files,
  }) {
    final $result = create();
    if (files != null) {
      $result.files.addAll(files);
    }
    return $result;
  }
  FileAttachments._() : super();
  factory FileAttachments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileAttachments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileAttachments', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..pc<FileAttachment>(1, _omitFieldNames ? '' : 'files', $pb.PbFieldType.PM, subBuilder: FileAttachment.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileAttachments clone() => FileAttachments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileAttachments copyWith(void Function(FileAttachments) updates) => super.copyWith((message) => updates(message as FileAttachments)) as FileAttachments;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileAttachments create() => FileAttachments._();
  FileAttachments createEmptyInstance() => create();
  static $pb.PbList<FileAttachments> createRepeated() => $pb.PbList<FileAttachments>();
  @$core.pragma('dart2js:noInline')
  static FileAttachments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileAttachments>(create);
  static FileAttachments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<FileAttachment> get files => $_getList(0);
}

enum MessageContent_Full_Attachments {
  images, 
  videos, 
  files, 
  notSet
}

class MessageContent_Full extends $pb.GeneratedMessage {
  factory MessageContent_Full({
    $core.String? text,
    ImageAttachments? images,
    VideoAttachments? videos,
    FileAttachments? files,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    if (images != null) {
      $result.images = images;
    }
    if (videos != null) {
      $result.videos = videos;
    }
    if (files != null) {
      $result.files = files;
    }
    return $result;
  }
  MessageContent_Full._() : super();
  factory MessageContent_Full.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageContent_Full.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, MessageContent_Full_Attachments> _MessageContent_Full_AttachmentsByTag = {
    3 : MessageContent_Full_Attachments.images,
    4 : MessageContent_Full_Attachments.videos,
    5 : MessageContent_Full_Attachments.files,
    0 : MessageContent_Full_Attachments.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageContent.Full', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..aQS(1, _omitFieldNames ? '' : 'text')
    ..aOM<ImageAttachments>(3, _omitFieldNames ? '' : 'images', subBuilder: ImageAttachments.create)
    ..aOM<VideoAttachments>(4, _omitFieldNames ? '' : 'videos', subBuilder: VideoAttachments.create)
    ..aOM<FileAttachments>(5, _omitFieldNames ? '' : 'files', subBuilder: FileAttachments.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageContent_Full clone() => MessageContent_Full()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageContent_Full copyWith(void Function(MessageContent_Full) updates) => super.copyWith((message) => updates(message as MessageContent_Full)) as MessageContent_Full;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageContent_Full create() => MessageContent_Full._();
  MessageContent_Full createEmptyInstance() => create();
  static $pb.PbList<MessageContent_Full> createRepeated() => $pb.PbList<MessageContent_Full>();
  @$core.pragma('dart2js:noInline')
  static MessageContent_Full getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageContent_Full>(create);
  static MessageContent_Full? _defaultInstance;

  MessageContent_Full_Attachments whichAttachments() => _MessageContent_Full_AttachmentsByTag[$_whichOneof(0)]!;
  void clearAttachments() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(3)
  ImageAttachments get images => $_getN(1);
  @$pb.TagNumber(3)
  set images(ImageAttachments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImages() => $_has(1);
  @$pb.TagNumber(3)
  void clearImages() => clearField(3);
  @$pb.TagNumber(3)
  ImageAttachments ensureImages() => $_ensure(1);

  @$pb.TagNumber(4)
  VideoAttachments get videos => $_getN(2);
  @$pb.TagNumber(4)
  set videos(VideoAttachments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasVideos() => $_has(2);
  @$pb.TagNumber(4)
  void clearVideos() => clearField(4);
  @$pb.TagNumber(4)
  VideoAttachments ensureVideos() => $_ensure(2);

  @$pb.TagNumber(5)
  FileAttachments get files => $_getN(3);
  @$pb.TagNumber(5)
  set files(FileAttachments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFiles() => $_has(3);
  @$pb.TagNumber(5)
  void clearFiles() => clearField(5);
  @$pb.TagNumber(5)
  FileAttachments ensureFiles() => $_ensure(3);
}

enum MessageContent_Content {
  text, 
  voice, 
  images, 
  videos, 
  files, 
  full, 
  deleted, 
  notSet
}

class MessageContent extends $pb.GeneratedMessage {
  factory MessageContent({
    $core.String? text,
    AudioAttachment? voice,
    ImageAttachments? images,
    VideoAttachments? videos,
    FileAttachments? files,
    MessageContent_Full? full,
    MessageDeleteState? deleted,
    $core.Map<$core.String, UserName>? mentions,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    if (voice != null) {
      $result.voice = voice;
    }
    if (images != null) {
      $result.images = images;
    }
    if (videos != null) {
      $result.videos = videos;
    }
    if (files != null) {
      $result.files = files;
    }
    if (full != null) {
      $result.full = full;
    }
    if (deleted != null) {
      $result.deleted = deleted;
    }
    if (mentions != null) {
      $result.mentions.addAll(mentions);
    }
    return $result;
  }
  MessageContent._() : super();
  factory MessageContent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageContent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, MessageContent_Content> _MessageContent_ContentByTag = {
    1 : MessageContent_Content.text,
    2 : MessageContent_Content.voice,
    3 : MessageContent_Content.images,
    4 : MessageContent_Content.videos,
    5 : MessageContent_Content.files,
    6 : MessageContent_Content.full,
    7 : MessageContent_Content.deleted,
    0 : MessageContent_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageContent', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOM<AudioAttachment>(2, _omitFieldNames ? '' : 'voice', subBuilder: AudioAttachment.create)
    ..aOM<ImageAttachments>(3, _omitFieldNames ? '' : 'images', subBuilder: ImageAttachments.create)
    ..aOM<VideoAttachments>(4, _omitFieldNames ? '' : 'videos', subBuilder: VideoAttachments.create)
    ..aOM<FileAttachments>(5, _omitFieldNames ? '' : 'files', subBuilder: FileAttachments.create)
    ..aOM<MessageContent_Full>(6, _omitFieldNames ? '' : 'full', subBuilder: MessageContent_Full.create)
    ..e<MessageDeleteState>(7, _omitFieldNames ? '' : 'deleted', $pb.PbFieldType.OE, defaultOrMaker: MessageDeleteState.DELETED_LOCALLY, valueOf: MessageDeleteState.valueOf, enumValues: MessageDeleteState.values)
    ..m<$core.String, UserName>(10, _omitFieldNames ? '' : 'mentions', entryClassName: 'MessageContent.MentionsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: UserName.create, valueDefaultOrMaker: UserName.getDefault, packageName: const $pb.PackageName('SessionApp'))
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageContent clone() => MessageContent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageContent copyWith(void Function(MessageContent) updates) => super.copyWith((message) => updates(message as MessageContent)) as MessageContent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageContent create() => MessageContent._();
  MessageContent createEmptyInstance() => create();
  static $pb.PbList<MessageContent> createRepeated() => $pb.PbList<MessageContent>();
  @$core.pragma('dart2js:noInline')
  static MessageContent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageContent>(create);
  static MessageContent? _defaultInstance;

  MessageContent_Content whichContent() => _MessageContent_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  AudioAttachment get voice => $_getN(1);
  @$pb.TagNumber(2)
  set voice(AudioAttachment v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoice() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoice() => clearField(2);
  @$pb.TagNumber(2)
  AudioAttachment ensureVoice() => $_ensure(1);

  @$pb.TagNumber(3)
  ImageAttachments get images => $_getN(2);
  @$pb.TagNumber(3)
  set images(ImageAttachments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImages() => $_has(2);
  @$pb.TagNumber(3)
  void clearImages() => clearField(3);
  @$pb.TagNumber(3)
  ImageAttachments ensureImages() => $_ensure(2);

  @$pb.TagNumber(4)
  VideoAttachments get videos => $_getN(3);
  @$pb.TagNumber(4)
  set videos(VideoAttachments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasVideos() => $_has(3);
  @$pb.TagNumber(4)
  void clearVideos() => clearField(4);
  @$pb.TagNumber(4)
  VideoAttachments ensureVideos() => $_ensure(3);

  @$pb.TagNumber(5)
  FileAttachments get files => $_getN(4);
  @$pb.TagNumber(5)
  set files(FileAttachments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFiles() => $_has(4);
  @$pb.TagNumber(5)
  void clearFiles() => clearField(5);
  @$pb.TagNumber(5)
  FileAttachments ensureFiles() => $_ensure(4);

  @$pb.TagNumber(6)
  MessageContent_Full get full => $_getN(5);
  @$pb.TagNumber(6)
  set full(MessageContent_Full v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasFull() => $_has(5);
  @$pb.TagNumber(6)
  void clearFull() => clearField(6);
  @$pb.TagNumber(6)
  MessageContent_Full ensureFull() => $_ensure(5);

  @$pb.TagNumber(7)
  MessageDeleteState get deleted => $_getN(6);
  @$pb.TagNumber(7)
  set deleted(MessageDeleteState v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasDeleted() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeleted() => clearField(7);

  @$pb.TagNumber(10)
  $core.Map<$core.String, UserName> get mentions => $_getMap(7);
}

class QuotedMessage extends $pb.GeneratedMessage {
  factory QuotedMessage({
    $core.String? id,
    $core.String? author,
    MessageContent? content,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (author != null) {
      $result.author = author;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  QuotedMessage._() : super();
  factory QuotedMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QuotedMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QuotedMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'author')
    ..aQM<MessageContent>(3, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QuotedMessage clone() => QuotedMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QuotedMessage copyWith(void Function(QuotedMessage) updates) => super.copyWith((message) => updates(message as QuotedMessage)) as QuotedMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuotedMessage create() => QuotedMessage._();
  QuotedMessage createEmptyInstance() => create();
  static $pb.PbList<QuotedMessage> createRepeated() => $pb.PbList<QuotedMessage>();
  @$core.pragma('dart2js:noInline')
  static QuotedMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuotedMessage>(create);
  static QuotedMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => clearField(2);

  @$pb.TagNumber(3)
  MessageContent get content => $_getN(2);
  @$pb.TagNumber(3)
  set content(MessageContent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);
  @$pb.TagNumber(3)
  MessageContent ensureContent() => $_ensure(2);
}

class MessageReaction extends $pb.GeneratedMessage {
  factory MessageReaction({
    $core.String? emoji,
    $core.int? count,
  }) {
    final $result = create();
    if (emoji != null) {
      $result.emoji = emoji;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  MessageReaction._() : super();
  factory MessageReaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageReaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReaction', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'emoji')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'count', $pb.PbFieldType.QU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageReaction clone() => MessageReaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageReaction copyWith(void Function(MessageReaction) updates) => super.copyWith((message) => updates(message as MessageReaction)) as MessageReaction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReaction create() => MessageReaction._();
  MessageReaction createEmptyInstance() => create();
  static $pb.PbList<MessageReaction> createRepeated() => $pb.PbList<MessageReaction>();
  @$core.pragma('dart2js:noInline')
  static MessageReaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReaction>(create);
  static MessageReaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get emoji => $_getSZ(0);
  @$pb.TagNumber(1)
  set emoji($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmoji() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmoji() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => clearField(2);
}

class RegularMessage extends $pb.GeneratedMessage {
  factory RegularMessage({
    $core.String? authorId,
    UserName? authorName,
    $2.Avatar? authorAvatar,
    MessageContent? content,
    QuotedMessage? quotedMessage,
    MessageState? state,
  }) {
    final $result = create();
    if (authorId != null) {
      $result.authorId = authorId;
    }
    if (authorName != null) {
      $result.authorName = authorName;
    }
    if (authorAvatar != null) {
      $result.authorAvatar = authorAvatar;
    }
    if (content != null) {
      $result.content = content;
    }
    if (quotedMessage != null) {
      $result.quotedMessage = quotedMessage;
    }
    if (state != null) {
      $result.state = state;
    }
    return $result;
  }
  RegularMessage._() : super();
  factory RegularMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegularMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegularMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'authorId')
    ..aQM<UserName>(3, _omitFieldNames ? '' : 'authorName', subBuilder: UserName.create)
    ..aQM<$2.Avatar>(4, _omitFieldNames ? '' : 'authorAvatar', subBuilder: $2.Avatar.create)
    ..aQM<MessageContent>(7, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOM<QuotedMessage>(9, _omitFieldNames ? '' : 'quotedMessage', subBuilder: QuotedMessage.create)
    ..e<MessageState>(11, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: MessageState.SENDING, valueOf: MessageState.valueOf, enumValues: MessageState.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegularMessage clone() => RegularMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegularMessage copyWith(void Function(RegularMessage) updates) => super.copyWith((message) => updates(message as RegularMessage)) as RegularMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegularMessage create() => RegularMessage._();
  RegularMessage createEmptyInstance() => create();
  static $pb.PbList<RegularMessage> createRepeated() => $pb.PbList<RegularMessage>();
  @$core.pragma('dart2js:noInline')
  static RegularMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegularMessage>(create);
  static RegularMessage? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get authorId => $_getSZ(0);
  @$pb.TagNumber(2)
  set authorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthorId() => $_has(0);
  @$pb.TagNumber(2)
  void clearAuthorId() => clearField(2);

  @$pb.TagNumber(3)
  UserName get authorName => $_getN(1);
  @$pb.TagNumber(3)
  set authorName(UserName v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthorName() => $_has(1);
  @$pb.TagNumber(3)
  void clearAuthorName() => clearField(3);
  @$pb.TagNumber(3)
  UserName ensureAuthorName() => $_ensure(1);

  @$pb.TagNumber(4)
  $2.Avatar get authorAvatar => $_getN(2);
  @$pb.TagNumber(4)
  set authorAvatar($2.Avatar v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAuthorAvatar() => $_has(2);
  @$pb.TagNumber(4)
  void clearAuthorAvatar() => clearField(4);
  @$pb.TagNumber(4)
  $2.Avatar ensureAuthorAvatar() => $_ensure(2);

  @$pb.TagNumber(7)
  MessageContent get content => $_getN(3);
  @$pb.TagNumber(7)
  set content(MessageContent v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(7)
  void clearContent() => clearField(7);
  @$pb.TagNumber(7)
  MessageContent ensureContent() => $_ensure(3);

  @$pb.TagNumber(9)
  QuotedMessage get quotedMessage => $_getN(4);
  @$pb.TagNumber(9)
  set quotedMessage(QuotedMessage v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasQuotedMessage() => $_has(4);
  @$pb.TagNumber(9)
  void clearQuotedMessage() => clearField(9);
  @$pb.TagNumber(9)
  QuotedMessage ensureQuotedMessage() => $_ensure(4);

  @$pb.TagNumber(11)
  MessageState get state => $_getN(5);
  @$pb.TagNumber(11)
  set state(MessageState v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(11)
  void clearState() => clearField(11);
}

enum Message_Body {
  regular, 
  control, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? id,
    $fixnum.Int64? createdAt,
    $core.Iterable<MessageReaction>? reactions,
    RegularMessage? regular,
    $3.ControlMessage? control,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (reactions != null) {
      $result.reactions.addAll(reactions);
    }
    if (regular != null) {
      $result.regular = regular;
    }
    if (control != null) {
      $result.control = control;
    }
    return $result;
  }
  Message._() : super();
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Message_Body> _Message_BodyByTag = {
    10 : Message_Body.regular,
    20 : Message_Body.control,
    0 : Message_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Message', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [10, 20])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<MessageReaction>(3, _omitFieldNames ? '' : 'reactions', $pb.PbFieldType.PM, subBuilder: MessageReaction.create)
    ..aOM<RegularMessage>(10, _omitFieldNames ? '' : 'regular', subBuilder: RegularMessage.create)
    ..aOM<$3.ControlMessage>(20, _omitFieldNames ? '' : 'control', subBuilder: $3.ControlMessage.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  Message_Body whichBody() => _Message_BodyByTag[$_whichOneof(0)]!;
  void clearBody() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAt => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAt($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<MessageReaction> get reactions => $_getList(2);

  @$pb.TagNumber(10)
  RegularMessage get regular => $_getN(3);
  @$pb.TagNumber(10)
  set regular(RegularMessage v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasRegular() => $_has(3);
  @$pb.TagNumber(10)
  void clearRegular() => clearField(10);
  @$pb.TagNumber(10)
  RegularMessage ensureRegular() => $_ensure(3);

  @$pb.TagNumber(20)
  $3.ControlMessage get control => $_getN(4);
  @$pb.TagNumber(20)
  set control($3.ControlMessage v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasControl() => $_has(4);
  @$pb.TagNumber(20)
  void clearControl() => clearField(20);
  @$pb.TagNumber(20)
  $3.ControlMessage ensureControl() => $_ensure(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
