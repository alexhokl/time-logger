// This is a generated file - do not edit.
//
// Generated from timelogger/v1/goal.proto.

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

class Goal extends $pb.GeneratedMessage {
  factory Goal({
    $fixnum.Int64? id,
    $fixnum.Int64? projectId,
    $core.String? projectName,
    $fixnum.Int64? taskId,
    $core.String? taskName,
    $core.double? targetHours,
    $1.Period? period,
    $1.Date? startDate,
    $1.Date? endDate,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (projectId != null) result.projectId = projectId;
    if (projectName != null) result.projectName = projectName;
    if (taskId != null) result.taskId = taskId;
    if (taskName != null) result.taskName = taskName;
    if (targetHours != null) result.targetHours = targetHours;
    if (period != null) result.period = period;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  Goal._();

  factory Goal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Goal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Goal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'projectName')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'taskName')
    ..aD(6, _omitFieldNames ? '' : 'targetHours')
    ..aE<$1.Period>(7, _omitFieldNames ? '' : 'period',
        enumValues: $1.Period.values)
    ..aOM<$1.Date>(8, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Date.create)
    ..aOM<$1.Date>(9, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Date.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal copyWith(void Function(Goal) updates) =>
      super.copyWith((message) => updates(message as Goal)) as Goal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Goal create() => Goal._();
  @$core.override
  Goal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Goal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Goal>(create);
  static Goal? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Zero means the goal covers all projects.
  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectName => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectName() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectName() => $_clearField(3);

  /// Zero means the goal covers all tasks within the project.
  @$pb.TagNumber(4)
  $fixnum.Int64 get taskId => $_getI64(3);
  @$pb.TagNumber(4)
  set taskId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaskId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get taskName => $_getSZ(4);
  @$pb.TagNumber(5)
  set taskName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTaskName() => $_has(4);
  @$pb.TagNumber(5)
  void clearTaskName() => $_clearField(5);

  /// Target expressed in hours to keep the CLI and UI natural; the server
  /// compares against seconds internally.
  @$pb.TagNumber(6)
  $core.double get targetHours => $_getN(5);
  @$pb.TagNumber(6)
  set targetHours($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetHours() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetHours() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Period get period => $_getN(6);
  @$pb.TagNumber(7)
  set period($1.Period value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPeriod() => $_has(6);
  @$pb.TagNumber(7)
  void clearPeriod() => $_clearField(7);

  /// First date the goal applies to, in the user's timezone.
  @$pb.TagNumber(8)
  $1.Date get startDate => $_getN(7);
  @$pb.TagNumber(8)
  set startDate($1.Date value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Date ensureStartDate() => $_ensure(7);

  /// Last date the goal applies to. Unset means the goal is open-ended.
  @$pb.TagNumber(9)
  $1.Date get endDate => $_getN(8);
  @$pb.TagNumber(9)
  set endDate($1.Date value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndDate() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Date ensureEndDate() => $_ensure(8);
}

class CreateGoalRequest extends $pb.GeneratedMessage {
  factory CreateGoalRequest({
    $fixnum.Int64? projectId,
    $fixnum.Int64? taskId,
    $core.double? targetHours,
    $1.Period? period,
    $1.Date? startDate,
    $1.Date? endDate,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (taskId != null) result.taskId = taskId;
    if (targetHours != null) result.targetHours = targetHours;
    if (period != null) result.period = period;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  CreateGoalRequest._();

  factory CreateGoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateGoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGoalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'targetHours')
    ..aE<$1.Period>(4, _omitFieldNames ? '' : 'period',
        enumValues: $1.Period.values)
    ..aOM<$1.Date>(5, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Date.create)
    ..aOM<$1.Date>(6, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Date.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGoalRequest copyWith(void Function(CreateGoalRequest) updates) =>
      super.copyWith((message) => updates(message as CreateGoalRequest))
          as CreateGoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGoalRequest create() => CreateGoalRequest._();
  @$core.override
  CreateGoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateGoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGoalRequest>(create);
  static CreateGoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get projectId => $_getI64(0);
  @$pb.TagNumber(1)
  set projectId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get taskId => $_getI64(1);
  @$pb.TagNumber(2)
  set taskId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get targetHours => $_getN(2);
  @$pb.TagNumber(3)
  set targetHours($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetHours() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetHours() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Period get period => $_getN(3);
  @$pb.TagNumber(4)
  set period($1.Period value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriod() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Date get startDate => $_getN(4);
  @$pb.TagNumber(5)
  set startDate($1.Date value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDate() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Date ensureStartDate() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Date get endDate => $_getN(5);
  @$pb.TagNumber(6)
  set endDate($1.Date value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndDate() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Date ensureEndDate() => $_ensure(5);
}

class CreateGoalResponse extends $pb.GeneratedMessage {
  factory CreateGoalResponse({
    Goal? goal,
  }) {
    final result = create();
    if (goal != null) result.goal = goal;
    return result;
  }

  CreateGoalResponse._();

  factory CreateGoalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateGoalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGoalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Goal>(1, _omitFieldNames ? '' : 'goal', subBuilder: Goal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGoalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGoalResponse copyWith(void Function(CreateGoalResponse) updates) =>
      super.copyWith((message) => updates(message as CreateGoalResponse))
          as CreateGoalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGoalResponse create() => CreateGoalResponse._();
  @$core.override
  CreateGoalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateGoalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGoalResponse>(create);
  static CreateGoalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Goal get goal => $_getN(0);
  @$pb.TagNumber(1)
  set goal(Goal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGoal() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoal() => $_clearField(1);
  @$pb.TagNumber(1)
  Goal ensureGoal() => $_ensure(0);
}

class ListGoalsRequest extends $pb.GeneratedMessage {
  factory ListGoalsRequest({
    $fixnum.Int64? projectId,
    $core.bool? activeOnly,
    $1.PageRequest? page,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (page != null) result.page = page;
    return result;
  }

  ListGoalsRequest._();

  factory ListGoalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListGoalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGoalsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aOM<$1.PageRequest>(3, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGoalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGoalsRequest copyWith(void Function(ListGoalsRequest) updates) =>
      super.copyWith((message) => updates(message as ListGoalsRequest))
          as ListGoalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGoalsRequest create() => ListGoalsRequest._();
  @$core.override
  ListGoalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListGoalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGoalsRequest>(create);
  static ListGoalsRequest? _defaultInstance;

  /// Restrict to goals scoped to this project. Zero means no filter.
  @$pb.TagNumber(1)
  $fixnum.Int64 get projectId => $_getI64(0);
  @$pb.TagNumber(1)
  set projectId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  /// When true only goals whose window includes today are returned.
  @$pb.TagNumber(2)
  $core.bool get activeOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set activeOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveOnly() => $_clearField(2);

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

class ListGoalsResponse extends $pb.GeneratedMessage {
  factory ListGoalsResponse({
    $core.Iterable<Goal>? goals,
    $1.PageResponse? page,
  }) {
    final result = create();
    if (goals != null) result.goals.addAll(goals);
    if (page != null) result.page = page;
    return result;
  }

  ListGoalsResponse._();

  factory ListGoalsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListGoalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListGoalsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<Goal>(1, _omitFieldNames ? '' : 'goals', subBuilder: Goal.create)
    ..aOM<$1.PageResponse>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGoalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListGoalsResponse copyWith(void Function(ListGoalsResponse) updates) =>
      super.copyWith((message) => updates(message as ListGoalsResponse))
          as ListGoalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListGoalsResponse create() => ListGoalsResponse._();
  @$core.override
  ListGoalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListGoalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListGoalsResponse>(create);
  static ListGoalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Goal> get goals => $_getList(0);

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

class GetGoalRequest extends $pb.GeneratedMessage {
  factory GetGoalRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetGoalRequest._();

  factory GetGoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalRequest copyWith(void Function(GetGoalRequest) updates) =>
      super.copyWith((message) => updates(message as GetGoalRequest))
          as GetGoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalRequest create() => GetGoalRequest._();
  @$core.override
  GetGoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalRequest>(create);
  static GetGoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetGoalResponse extends $pb.GeneratedMessage {
  factory GetGoalResponse({
    Goal? goal,
  }) {
    final result = create();
    if (goal != null) result.goal = goal;
    return result;
  }

  GetGoalResponse._();

  factory GetGoalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Goal>(1, _omitFieldNames ? '' : 'goal', subBuilder: Goal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalResponse copyWith(void Function(GetGoalResponse) updates) =>
      super.copyWith((message) => updates(message as GetGoalResponse))
          as GetGoalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalResponse create() => GetGoalResponse._();
  @$core.override
  GetGoalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalResponse>(create);
  static GetGoalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Goal get goal => $_getN(0);
  @$pb.TagNumber(1)
  set goal(Goal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGoal() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoal() => $_clearField(1);
  @$pb.TagNumber(1)
  Goal ensureGoal() => $_ensure(0);
}

class UpdateGoalRequest extends $pb.GeneratedMessage {
  factory UpdateGoalRequest({
    $fixnum.Int64? id,
    $core.Iterable<$core.String>? updateMask,
    $fixnum.Int64? projectId,
    $fixnum.Int64? taskId,
    $core.double? targetHours,
    $1.Period? period,
    $1.Date? startDate,
    $1.Date? endDate,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (updateMask != null) result.updateMask.addAll(updateMask);
    if (projectId != null) result.projectId = projectId;
    if (taskId != null) result.taskId = taskId;
    if (targetHours != null) result.targetHours = targetHours;
    if (period != null) result.period = period;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  UpdateGoalRequest._();

  factory UpdateGoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateGoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateGoalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(2, _omitFieldNames ? '' : 'updateMask')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(5, _omitFieldNames ? '' : 'targetHours')
    ..aE<$1.Period>(6, _omitFieldNames ? '' : 'period',
        enumValues: $1.Period.values)
    ..aOM<$1.Date>(7, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Date.create)
    ..aOM<$1.Date>(8, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Date.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateGoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateGoalRequest copyWith(void Function(UpdateGoalRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateGoalRequest))
          as UpdateGoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateGoalRequest create() => UpdateGoalRequest._();
  @$core.override
  UpdateGoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateGoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateGoalRequest>(create);
  static UpdateGoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Valid mask values: "project_id", "task_id", "target_hours", "period",
  /// "start_date", "end_date".
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get updateMask => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get projectId => $_getI64(2);
  @$pb.TagNumber(3)
  set projectId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get taskId => $_getI64(3);
  @$pb.TagNumber(4)
  set taskId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaskId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get targetHours => $_getN(4);
  @$pb.TagNumber(5)
  set targetHours($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetHours() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetHours() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Period get period => $_getN(5);
  @$pb.TagNumber(6)
  set period($1.Period value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriod() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriod() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Date get startDate => $_getN(6);
  @$pb.TagNumber(7)
  set startDate($1.Date value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartDate() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Date ensureStartDate() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Date get endDate => $_getN(7);
  @$pb.TagNumber(8)
  set endDate($1.Date value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEndDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearEndDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Date ensureEndDate() => $_ensure(7);
}

class UpdateGoalResponse extends $pb.GeneratedMessage {
  factory UpdateGoalResponse({
    Goal? goal,
  }) {
    final result = create();
    if (goal != null) result.goal = goal;
    return result;
  }

  UpdateGoalResponse._();

  factory UpdateGoalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateGoalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateGoalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Goal>(1, _omitFieldNames ? '' : 'goal', subBuilder: Goal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateGoalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateGoalResponse copyWith(void Function(UpdateGoalResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateGoalResponse))
          as UpdateGoalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateGoalResponse create() => UpdateGoalResponse._();
  @$core.override
  UpdateGoalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateGoalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateGoalResponse>(create);
  static UpdateGoalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Goal get goal => $_getN(0);
  @$pb.TagNumber(1)
  set goal(Goal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGoal() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoal() => $_clearField(1);
  @$pb.TagNumber(1)
  Goal ensureGoal() => $_ensure(0);
}

class DeleteGoalRequest extends $pb.GeneratedMessage {
  factory DeleteGoalRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteGoalRequest._();

  factory DeleteGoalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteGoalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteGoalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGoalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGoalRequest copyWith(void Function(DeleteGoalRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteGoalRequest))
          as DeleteGoalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteGoalRequest create() => DeleteGoalRequest._();
  @$core.override
  DeleteGoalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteGoalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteGoalRequest>(create);
  static DeleteGoalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// DeleteGoalResponse is intentionally empty; it exists so the RPC can gain
/// response fields later without a breaking change.
class DeleteGoalResponse extends $pb.GeneratedMessage {
  factory DeleteGoalResponse() => create();

  DeleteGoalResponse._();

  factory DeleteGoalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteGoalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteGoalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGoalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteGoalResponse copyWith(void Function(DeleteGoalResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteGoalResponse))
          as DeleteGoalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteGoalResponse create() => DeleteGoalResponse._();
  @$core.override
  DeleteGoalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteGoalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteGoalResponse>(create);
  static DeleteGoalResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
