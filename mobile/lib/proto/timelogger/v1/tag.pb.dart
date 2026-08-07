// This is a generated file - do not edit.
//
// Generated from timelogger/v1/tag.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Tag extends $pb.GeneratedMessage {
  factory Tag({
    $fixnum.Int64? id,
    $core.String? name,
    $fixnum.Int64? entryCount,
    $fixnum.Int64? totalSeconds,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (entryCount != null) result.entryCount = entryCount;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    return result;
  }

  Tag._();

  factory Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tag',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'entryCount')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag copyWith(void Function(Tag) updates) =>
      super.copyWith((message) => updates(message as Tag)) as Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tag create() => Tag._();
  @$core.override
  Tag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tag getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tag>(create);
  static Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get entryCount => $_getI64(2);
  @$pb.TagNumber(3)
  set entryCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntryCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntryCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSeconds() => $_clearField(4);
}

class CreateTagRequest extends $pb.GeneratedMessage {
  factory CreateTagRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  CreateTagRequest._();

  factory CreateTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTagRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTagRequest copyWith(void Function(CreateTagRequest) updates) =>
      super.copyWith((message) => updates(message as CreateTagRequest))
          as CreateTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTagRequest create() => CreateTagRequest._();
  @$core.override
  CreateTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTagRequest>(create);
  static CreateTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class CreateTagResponse extends $pb.GeneratedMessage {
  factory CreateTagResponse({
    Tag? tag,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    return result;
  }

  CreateTagResponse._();

  factory CreateTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTagResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Tag>(1, _omitFieldNames ? '' : 'tag', subBuilder: Tag.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTagResponse copyWith(void Function(CreateTagResponse) updates) =>
      super.copyWith((message) => updates(message as CreateTagResponse))
          as CreateTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTagResponse create() => CreateTagResponse._();
  @$core.override
  CreateTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTagResponse>(create);
  static CreateTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tag get tag => $_getN(0);
  @$pb.TagNumber(1)
  set tag(Tag value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);
  @$pb.TagNumber(1)
  Tag ensureTag() => $_ensure(0);
}

class ListTagsRequest extends $pb.GeneratedMessage {
  factory ListTagsRequest({
    $core.bool? includeStats,
    $1.PageRequest? page,
  }) {
    final result = create();
    if (includeStats != null) result.includeStats = includeStats;
    if (page != null) result.page = page;
    return result;
  }

  ListTagsRequest._();

  factory ListTagsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTagsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTagsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeStats')
    ..aOM<$1.PageRequest>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsRequest copyWith(void Function(ListTagsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTagsRequest))
          as ListTagsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTagsRequest create() => ListTagsRequest._();
  @$core.override
  ListTagsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTagsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTagsRequest>(create);
  static ListTagsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeStats => $_getBF(0);
  @$pb.TagNumber(1)
  set includeStats($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeStats() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeStats() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PageRequest get page => $_getN(1);
  @$pb.TagNumber(2)
  set page($1.PageRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PageRequest ensurePage() => $_ensure(1);
}

class ListTagsResponse extends $pb.GeneratedMessage {
  factory ListTagsResponse({
    $core.Iterable<Tag>? tags,
    $1.PageResponse? page,
  }) {
    final result = create();
    if (tags != null) result.tags.addAll(tags);
    if (page != null) result.page = page;
    return result;
  }

  ListTagsResponse._();

  factory ListTagsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTagsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTagsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<Tag>(1, _omitFieldNames ? '' : 'tags', subBuilder: Tag.create)
    ..aOM<$1.PageResponse>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTagsResponse copyWith(void Function(ListTagsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTagsResponse))
          as ListTagsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTagsResponse create() => ListTagsResponse._();
  @$core.override
  ListTagsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTagsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTagsResponse>(create);
  static ListTagsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Tag> get tags => $_getList(0);

  @$pb.TagNumber(2)
  $1.PageResponse get page => $_getN(1);
  @$pb.TagNumber(2)
  set page($1.PageResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PageResponse ensurePage() => $_ensure(1);
}

class RenameTagRequest extends $pb.GeneratedMessage {
  factory RenameTagRequest({
    $fixnum.Int64? id,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  RenameTagRequest._();

  factory RenameTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameTagRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameTagRequest copyWith(void Function(RenameTagRequest) updates) =>
      super.copyWith((message) => updates(message as RenameTagRequest))
          as RenameTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameTagRequest create() => RenameTagRequest._();
  @$core.override
  RenameTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameTagRequest>(create);
  static RenameTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class RenameTagResponse extends $pb.GeneratedMessage {
  factory RenameTagResponse({
    Tag? tag,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    return result;
  }

  RenameTagResponse._();

  factory RenameTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameTagResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Tag>(1, _omitFieldNames ? '' : 'tag', subBuilder: Tag.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameTagResponse copyWith(void Function(RenameTagResponse) updates) =>
      super.copyWith((message) => updates(message as RenameTagResponse))
          as RenameTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameTagResponse create() => RenameTagResponse._();
  @$core.override
  RenameTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameTagResponse>(create);
  static RenameTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tag get tag => $_getN(0);
  @$pb.TagNumber(1)
  set tag(Tag value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);
  @$pb.TagNumber(1)
  Tag ensureTag() => $_ensure(0);
}

class DeleteTagRequest extends $pb.GeneratedMessage {
  factory DeleteTagRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteTagRequest._();

  factory DeleteTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTagRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTagRequest copyWith(void Function(DeleteTagRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteTagRequest))
          as DeleteTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTagRequest create() => DeleteTagRequest._();
  @$core.override
  DeleteTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTagRequest>(create);
  static DeleteTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// DeleteTagResponse is intentionally empty; it exists so the RPC can gain
/// response fields later without a breaking change.
class DeleteTagResponse extends $pb.GeneratedMessage {
  factory DeleteTagResponse() => create();

  DeleteTagResponse._();

  factory DeleteTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTagResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTagResponse copyWith(void Function(DeleteTagResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteTagResponse))
          as DeleteTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTagResponse create() => DeleteTagResponse._();
  @$core.override
  DeleteTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTagResponse>(create);
  static DeleteTagResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
