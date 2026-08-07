// This is a generated file - do not edit.
//
// Generated from timelogger/v1/project.proto.

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

class Project extends $pb.GeneratedMessage {
  factory Project({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? color,
    $core.bool? archived,
    $fixnum.Int64? entryCount,
    $fixnum.Int64? totalSeconds,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (color != null) result.color = color;
    if (archived != null) result.archived = archived;
    if (entryCount != null) result.entryCount = entryCount;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    return result;
  }

  Project._();

  factory Project.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Project.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Project',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..aOB(4, _omitFieldNames ? '' : 'archived')
    ..aInt64(5, _omitFieldNames ? '' : 'entryCount')
    ..aInt64(6, _omitFieldNames ? '' : 'totalSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Project clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Project copyWith(void Function(Project) updates) =>
      super.copyWith((message) => updates(message as Project)) as Project;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Project create() => Project._();
  @$core.override
  Project createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Project getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Project>(create);
  static Project? _defaultInstance;

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

  /// Hex colour used by the Flutter client, e.g. "#4285F4". Optional.
  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get archived => $_getBF(3);
  @$pb.TagNumber(4)
  set archived($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArchived() => $_has(3);
  @$pb.TagNumber(4)
  void clearArchived() => $_clearField(4);

  /// Number of time entries referencing this project. Only populated by
  /// ListProjects and GetProject when include_stats is set.
  @$pb.TagNumber(5)
  $fixnum.Int64 get entryCount => $_getI64(4);
  @$pb.TagNumber(5)
  set entryCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEntryCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearEntryCount() => $_clearField(5);

  /// Total tracked seconds against this project. Only populated when
  /// include_stats is set.
  @$pb.TagNumber(6)
  $fixnum.Int64 get totalSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalSeconds() => $_clearField(6);
}

class CreateProjectRequest extends $pb.GeneratedMessage {
  factory CreateProjectRequest({
    $core.String? name,
    $core.String? color,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (color != null) result.color = color;
    return result;
  }

  CreateProjectRequest._();

  factory CreateProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectRequest copyWith(void Function(CreateProjectRequest) updates) =>
      super.copyWith((message) => updates(message as CreateProjectRequest))
          as CreateProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest create() => CreateProjectRequest._();
  @$core.override
  CreateProjectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectRequest>(create);
  static CreateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get color => $_getSZ(1);
  @$pb.TagNumber(2)
  set color($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearColor() => $_clearField(2);
}

class CreateProjectResponse extends $pb.GeneratedMessage {
  factory CreateProjectResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  CreateProjectResponse._();

  factory CreateProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateProjectResponse copyWith(
          void Function(CreateProjectResponse) updates) =>
      super.copyWith((message) => updates(message as CreateProjectResponse))
          as CreateProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse create() => CreateProjectResponse._();
  @$core.override
  CreateProjectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateProjectResponse>(create);
  static CreateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class ListProjectsRequest extends $pb.GeneratedMessage {
  factory ListProjectsRequest({
    $core.bool? includeArchived,
    $core.bool? includeStats,
    $1.PageRequest? page,
  }) {
    final result = create();
    if (includeArchived != null) result.includeArchived = includeArchived;
    if (includeStats != null) result.includeStats = includeStats;
    if (page != null) result.page = page;
    return result;
  }

  ListProjectsRequest._();

  factory ListProjectsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProjectsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeArchived')
    ..aOB(2, _omitFieldNames ? '' : 'includeStats')
    ..aOM<$1.PageRequest>(3, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsRequest copyWith(void Function(ListProjectsRequest) updates) =>
      super.copyWith((message) => updates(message as ListProjectsRequest))
          as ListProjectsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest create() => ListProjectsRequest._();
  @$core.override
  ListProjectsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProjectsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsRequest>(create);
  static ListProjectsRequest? _defaultInstance;

  /// When false (default) archived projects are omitted.
  @$pb.TagNumber(1)
  $core.bool get includeArchived => $_getBF(0);
  @$pb.TagNumber(1)
  set includeArchived($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeArchived() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeArchived() => $_clearField(1);

  /// When true the entry_count and total_seconds fields are populated. This
  /// costs an extra aggregate query, so it is opt-in.
  @$pb.TagNumber(2)
  $core.bool get includeStats => $_getBF(1);
  @$pb.TagNumber(2)
  set includeStats($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeStats() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PageRequest get page => $_getN(2);
  @$pb.TagNumber(3)
  set page($1.PageRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PageRequest ensurePage() => $_ensure(2);
}

class ListProjectsResponse extends $pb.GeneratedMessage {
  factory ListProjectsResponse({
    $core.Iterable<Project>? projects,
    $1.PageResponse? page,
  }) {
    final result = create();
    if (projects != null) result.projects.addAll(projects);
    if (page != null) result.page = page;
    return result;
  }

  ListProjectsResponse._();

  factory ListProjectsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProjectsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProjectsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<Project>(1, _omitFieldNames ? '' : 'projects',
        subBuilder: Project.create)
    ..aOM<$1.PageResponse>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProjectsResponse copyWith(void Function(ListProjectsResponse) updates) =>
      super.copyWith((message) => updates(message as ListProjectsResponse))
          as ListProjectsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse create() => ListProjectsResponse._();
  @$core.override
  ListProjectsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProjectsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProjectsResponse>(create);
  static ListProjectsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Project> get projects => $_getList(0);

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

class GetProjectRequest extends $pb.GeneratedMessage {
  factory GetProjectRequest({
    $fixnum.Int64? id,
    $core.bool? includeStats,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (includeStats != null) result.includeStats = includeStats;
    return result;
  }

  GetProjectRequest._();

  factory GetProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, _omitFieldNames ? '' : 'includeStats')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectRequest copyWith(void Function(GetProjectRequest) updates) =>
      super.copyWith((message) => updates(message as GetProjectRequest))
          as GetProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectRequest create() => GetProjectRequest._();
  @$core.override
  GetProjectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProjectRequest>(create);
  static GetProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeStats => $_getBF(1);
  @$pb.TagNumber(2)
  set includeStats($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeStats() => $_clearField(2);
}

class GetProjectResponse extends $pb.GeneratedMessage {
  factory GetProjectResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  GetProjectResponse._();

  factory GetProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProjectResponse copyWith(void Function(GetProjectResponse) updates) =>
      super.copyWith((message) => updates(message as GetProjectResponse))
          as GetProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProjectResponse create() => GetProjectResponse._();
  @$core.override
  GetProjectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProjectResponse>(create);
  static GetProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class UpdateProjectRequest extends $pb.GeneratedMessage {
  factory UpdateProjectRequest({
    $fixnum.Int64? id,
    $core.Iterable<$core.String>? updateMask,
    $core.String? name,
    $core.String? color,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (updateMask != null) result.updateMask.addAll(updateMask);
    if (name != null) result.name = name;
    if (color != null) result.color = color;
    return result;
  }

  UpdateProjectRequest._();

  factory UpdateProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(2, _omitFieldNames ? '' : 'updateMask')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectRequest copyWith(void Function(UpdateProjectRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectRequest))
          as UpdateProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest create() => UpdateProjectRequest._();
  @$core.override
  UpdateProjectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectRequest>(create);
  static UpdateProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Only the fields listed in update_mask are applied. Valid values are
  /// "name" and "color". An empty mask updates every provided field.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get updateMask => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => $_clearField(4);
}

class UpdateProjectResponse extends $pb.GeneratedMessage {
  factory UpdateProjectResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  UpdateProjectResponse._();

  factory UpdateProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProjectResponse copyWith(
          void Function(UpdateProjectResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateProjectResponse))
          as UpdateProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse create() => UpdateProjectResponse._();
  @$core.override
  UpdateProjectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProjectResponse>(create);
  static UpdateProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

class DeleteProjectRequest extends $pb.GeneratedMessage {
  factory DeleteProjectRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteProjectRequest._();

  factory DeleteProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectRequest copyWith(void Function(DeleteProjectRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectRequest))
          as DeleteProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest create() => DeleteProjectRequest._();
  @$core.override
  DeleteProjectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectRequest>(create);
  static DeleteProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class SetProjectArchivedRequest extends $pb.GeneratedMessage {
  factory SetProjectArchivedRequest({
    $fixnum.Int64? id,
    $core.bool? archived,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (archived != null) result.archived = archived;
    return result;
  }

  SetProjectArchivedRequest._();

  factory SetProjectArchivedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetProjectArchivedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetProjectArchivedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, _omitFieldNames ? '' : 'archived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetProjectArchivedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetProjectArchivedRequest copyWith(
          void Function(SetProjectArchivedRequest) updates) =>
      super.copyWith((message) => updates(message as SetProjectArchivedRequest))
          as SetProjectArchivedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetProjectArchivedRequest create() => SetProjectArchivedRequest._();
  @$core.override
  SetProjectArchivedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetProjectArchivedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetProjectArchivedRequest>(create);
  static SetProjectArchivedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get archived => $_getBF(1);
  @$pb.TagNumber(2)
  set archived($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArchived() => $_has(1);
  @$pb.TagNumber(2)
  void clearArchived() => $_clearField(2);
}

class SetProjectArchivedResponse extends $pb.GeneratedMessage {
  factory SetProjectArchivedResponse({
    Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  SetProjectArchivedResponse._();

  factory SetProjectArchivedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetProjectArchivedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetProjectArchivedResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Project>(1, _omitFieldNames ? '' : 'project',
        subBuilder: Project.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetProjectArchivedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetProjectArchivedResponse copyWith(
          void Function(SetProjectArchivedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetProjectArchivedResponse))
          as SetProjectArchivedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetProjectArchivedResponse create() => SetProjectArchivedResponse._();
  @$core.override
  SetProjectArchivedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetProjectArchivedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetProjectArchivedResponse>(create);
  static SetProjectArchivedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  Project ensureProject() => $_ensure(0);
}

/// DeleteProjectResponse is intentionally empty; it exists so the RPC can gain
/// response fields later without a breaking change.
class DeleteProjectResponse extends $pb.GeneratedMessage {
  factory DeleteProjectResponse() => create();

  DeleteProjectResponse._();

  factory DeleteProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProjectResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProjectResponse copyWith(
          void Function(DeleteProjectResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteProjectResponse))
          as DeleteProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse create() => DeleteProjectResponse._();
  @$core.override
  DeleteProjectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProjectResponse>(create);
  static DeleteProjectResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
