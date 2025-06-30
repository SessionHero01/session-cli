//
//  Generated code. Do not modify.
//  source: protos/control_messages.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum ControlMessage_Content {
  messageApprovalFromMe, 
  screenshotTakenFromMe, 
  mediaSavedFromMe, 
  notSet
}

class ControlMessage extends $pb.GeneratedMessage {
  factory ControlMessage({
    $core.bool? messageApprovalFromMe,
    $core.bool? screenshotTakenFromMe,
    $core.bool? mediaSavedFromMe,
  }) {
    final $result = create();
    if (messageApprovalFromMe != null) {
      $result.messageApprovalFromMe = messageApprovalFromMe;
    }
    if (screenshotTakenFromMe != null) {
      $result.screenshotTakenFromMe = screenshotTakenFromMe;
    }
    if (mediaSavedFromMe != null) {
      $result.mediaSavedFromMe = mediaSavedFromMe;
    }
    return $result;
  }
  ControlMessage._() : super();
  factory ControlMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ControlMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ControlMessage_Content> _ControlMessage_ContentByTag = {
    2 : ControlMessage_Content.messageApprovalFromMe,
    3 : ControlMessage_Content.screenshotTakenFromMe,
    4 : ControlMessage_Content.mediaSavedFromMe,
    0 : ControlMessage_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ControlMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'SessionApp'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOB(2, _omitFieldNames ? '' : 'messageApprovalFromMe')
    ..aOB(3, _omitFieldNames ? '' : 'screenshotTakenFromMe')
    ..aOB(4, _omitFieldNames ? '' : 'mediaSavedFromMe')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ControlMessage clone() => ControlMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ControlMessage copyWith(void Function(ControlMessage) updates) => super.copyWith((message) => updates(message as ControlMessage)) as ControlMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ControlMessage create() => ControlMessage._();
  ControlMessage createEmptyInstance() => create();
  static $pb.PbList<ControlMessage> createRepeated() => $pb.PbList<ControlMessage>();
  @$core.pragma('dart2js:noInline')
  static ControlMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ControlMessage>(create);
  static ControlMessage? _defaultInstance;

  ControlMessage_Content whichContent() => _ControlMessage_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.bool get messageApprovalFromMe => $_getBF(0);
  @$pb.TagNumber(2)
  set messageApprovalFromMe($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessageApprovalFromMe() => $_has(0);
  @$pb.TagNumber(2)
  void clearMessageApprovalFromMe() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get screenshotTakenFromMe => $_getBF(1);
  @$pb.TagNumber(3)
  set screenshotTakenFromMe($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasScreenshotTakenFromMe() => $_has(1);
  @$pb.TagNumber(3)
  void clearScreenshotTakenFromMe() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get mediaSavedFromMe => $_getBF(2);
  @$pb.TagNumber(4)
  set mediaSavedFromMe($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasMediaSavedFromMe() => $_has(2);
  @$pb.TagNumber(4)
  void clearMediaSavedFromMe() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
