// This is a generated file - do not edit.
//
// Generated from timelogger/v1/entry.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TimeEntry extends $pb.GeneratedMessage {
  factory TimeEntry({
    $fixnum.Int64? id,
    $core.String? description,
    $fixnum.Int64? projectId,
    $core.String? projectName,
    $fixnum.Int64? taskId,
    $core.String? taskName,
    $core.Iterable<$core.String>? tags,
    $1.Timestamp? startTime,
    $1.Timestamp? endTime,
    $fixnum.Int64? durationSeconds,
    $core.bool? running,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (description != null) result.description = description;
    if (projectId != null) result.projectId = projectId;
    if (projectName != null) result.projectName = projectName;
    if (taskId != null) result.taskId = taskId;
    if (taskName != null) result.taskName = taskName;
    if (tags != null) result.tags.addAll(tags);
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (running != null) result.running = running;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  TimeEntry._();

  factory TimeEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TimeEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'projectName')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(6, _omitFieldNames ? '' : 'taskName')
    ..pPS(7, _omitFieldNames ? '' : 'tags')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'startTime',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'endTime',
        subBuilder: $1.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'durationSeconds')
    ..aOB(11, _omitFieldNames ? '' : 'running')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeEntry copyWith(void Function(TimeEntry) updates) =>
      super.copyWith((message) => updates(message as TimeEntry)) as TimeEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeEntry create() => TimeEntry._();
  @$core.override
  TimeEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TimeEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeEntry>(create);
  static TimeEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  /// Zero when the entry is not associated with a project.
  @$pb.TagNumber(3)
  $fixnum.Int64 get projectId => $_getI64(2);
  @$pb.TagNumber(3)
  set projectId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get projectName => $_getSZ(3);
  @$pb.TagNumber(4)
  set projectName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProjectName() => $_has(3);
  @$pb.TagNumber(4)
  void clearProjectName() => $_clearField(4);

  /// Zero when the entry is not associated with a task.
  @$pb.TagNumber(5)
  $fixnum.Int64 get taskId => $_getI64(4);
  @$pb.TagNumber(5)
  set taskId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTaskId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTaskId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get taskName => $_getSZ(5);
  @$pb.TagNumber(6)
  set taskName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTaskName() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaskName() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get tags => $_getList(6);

  @$pb.TagNumber(8)
  $1.Timestamp get startTime => $_getN(7);
  @$pb.TagNumber(8)
  set startTime($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartTime() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureStartTime() => $_ensure(7);

  /// Absent while the entry is still running.
  @$pb.TagNumber(9)
  $1.Timestamp get endTime => $_getN(8);
  @$pb.TagNumber(9)
  set endTime($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndTime() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureEndTime() => $_ensure(8);

  /// Elapsed seconds. For a running entry this is the elapsed time as of the
  /// moment the server built the response.
  @$pb.TagNumber(10)
  $fixnum.Int64 get durationSeconds => $_getI64(9);
  @$pb.TagNumber(10)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDurationSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearDurationSeconds() => $_clearField(10);

  /// True when end_time is absent, i.e. the entry is the user's running timer.
  @$pb.TagNumber(11)
  $core.bool get running => $_getBF(10);
  @$pb.TagNumber(11)
  set running($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRunning() => $_has(10);
  @$pb.TagNumber(11)
  void clearRunning() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get updatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set updatedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureUpdatedAt() => $_ensure(12);
}

/// TimeSpec carries the caller's chosen combination of start, end, duration and
/// date. It is shared by CreateEntry and the bulk create RPC.
class TimeSpec extends $pb.GeneratedMessage {
  factory TimeSpec({
    $1.Timestamp? startTime,
    $1.Timestamp? endTime,
    $fixnum.Int64? durationSeconds,
    $2.Date? date,
  }) {
    final result = create();
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (date != null) result.date = date;
    return result;
  }

  TimeSpec._();

  factory TimeSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TimeSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeSpec',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'startTime',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'endTime',
        subBuilder: $1.Timestamp.create)
    ..aInt64(3, _omitFieldNames ? '' : 'durationSeconds')
    ..aOM<$2.Date>(4, _omitFieldNames ? '' : 'date', subBuilder: $2.Date.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSpec copyWith(void Function(TimeSpec) updates) =>
      super.copyWith((message) => updates(message as TimeSpec)) as TimeSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeSpec create() => TimeSpec._();
  @$core.override
  TimeSpec createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TimeSpec getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeSpec>(create);
  static TimeSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Timestamp get startTime => $_getN(0);
  @$pb.TagNumber(1)
  set startTime($1.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureStartTime() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Timestamp get endTime => $_getN(1);
  @$pb.TagNumber(2)
  set endTime($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureEndTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get durationSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);

  /// Calendar date interpreted in the user's configured timezone. Only
  /// meaningful together with duration_seconds.
  @$pb.TagNumber(4)
  $2.Date get date => $_getN(3);
  @$pb.TagNumber(4)
  set date($2.Date value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDate() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Date ensureDate() => $_ensure(3);
}

class CreateEntryRequest extends $pb.GeneratedMessage {
  factory CreateEntryRequest({
    $core.String? description,
    $fixnum.Int64? projectId,
    $fixnum.Int64? taskId,
    $core.Iterable<$core.String>? tags,
    TimeSpec? time,
  }) {
    final result = create();
    if (description != null) result.description = description;
    if (projectId != null) result.projectId = projectId;
    if (taskId != null) result.taskId = taskId;
    if (tags != null) result.tags.addAll(tags);
    if (time != null) result.time = time;
    return result;
  }

  CreateEntryRequest._();

  factory CreateEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..aOM<TimeSpec>(5, _omitFieldNames ? '' : 'time',
        subBuilder: TimeSpec.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntryRequest copyWith(void Function(CreateEntryRequest) updates) =>
      super.copyWith((message) => updates(message as CreateEntryRequest))
          as CreateEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEntryRequest create() => CreateEntryRequest._();
  @$core.override
  CreateEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEntryRequest>(create);
  static CreateEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get description => $_getSZ(0);
  @$pb.TagNumber(1)
  set description($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => $_clearField(1);

  /// Zero leaves the entry unassigned to a project.
  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  /// Zero leaves the entry unassigned to a task. When set, the task must
  /// belong to project_id if that is also set.
  @$pb.TagNumber(3)
  $fixnum.Int64 get taskId => $_getI64(2);
  @$pb.TagNumber(3)
  set taskId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskId() => $_clearField(3);

  /// Tags are matched by name and created on demand.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tags => $_getList(3);

  @$pb.TagNumber(5)
  TimeSpec get time => $_getN(4);
  @$pb.TagNumber(5)
  set time(TimeSpec value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearTime() => $_clearField(5);
  @$pb.TagNumber(5)
  TimeSpec ensureTime() => $_ensure(4);
}

class CreateEntryResponse extends $pb.GeneratedMessage {
  factory CreateEntryResponse({
    TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  CreateEntryResponse._();

  factory CreateEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntryResponse copyWith(void Function(CreateEntryResponse) updates) =>
      super.copyWith((message) => updates(message as CreateEntryResponse))
          as CreateEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEntryResponse create() => CreateEntryResponse._();
  @$core.override
  CreateEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEntryResponse>(create);
  static CreateEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  TimeEntry ensureEntry() => $_ensure(0);
}

class CreateEntriesRequest extends $pb.GeneratedMessage {
  factory CreateEntriesRequest({
    $core.Iterable<CreateEntryRequest>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  CreateEntriesRequest._();

  factory CreateEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<CreateEntryRequest>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: CreateEntryRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntriesRequest copyWith(void Function(CreateEntriesRequest) updates) =>
      super.copyWith((message) => updates(message as CreateEntriesRequest))
          as CreateEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEntriesRequest create() => CreateEntriesRequest._();
  @$core.override
  CreateEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEntriesRequest>(create);
  static CreateEntriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreateEntryRequest> get entries => $_getList(0);
}

class CreateEntriesResponse extends $pb.GeneratedMessage {
  factory CreateEntriesResponse({
    $core.Iterable<TimeEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  CreateEntriesResponse._();

  factory CreateEntriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateEntriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateEntriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<TimeEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateEntriesResponse copyWith(
          void Function(CreateEntriesResponse) updates) =>
      super.copyWith((message) => updates(message as CreateEntriesResponse))
          as CreateEntriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateEntriesResponse create() => CreateEntriesResponse._();
  @$core.override
  CreateEntriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateEntriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateEntriesResponse>(create);
  static CreateEntriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimeEntry> get entries => $_getList(0);
}

class EntryFilter extends $pb.GeneratedMessage {
  factory EntryFilter({
    $1.Timestamp? from,
    $1.Timestamp? to,
    $core.Iterable<$fixnum.Int64>? projectIds,
    $core.Iterable<$fixnum.Int64>? taskIds,
    $core.Iterable<$core.String>? tags,
    $core.String? search,
    $core.bool? running,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (projectIds != null) result.projectIds.addAll(projectIds);
    if (taskIds != null) result.taskIds.addAll(taskIds);
    if (tags != null) result.tags.addAll(tags);
    if (search != null) result.search = search;
    if (running != null) result.running = running;
    return result;
  }

  EntryFilter._();

  factory EntryFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntryFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntryFilter',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $1.Timestamp.create)
    ..p<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'projectIds', $pb.PbFieldType.KU6)
    ..p<$fixnum.Int64>(4, _omitFieldNames ? '' : 'taskIds', $pb.PbFieldType.KU6)
    ..pPS(5, _omitFieldNames ? '' : 'tags')
    ..aOS(6, _omitFieldNames ? '' : 'search')
    ..aOB(7, _omitFieldNames ? '' : 'running')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntryFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntryFilter copyWith(void Function(EntryFilter) updates) =>
      super.copyWith((message) => updates(message as EntryFilter))
          as EntryFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntryFilter create() => EntryFilter._();
  @$core.override
  EntryFilter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntryFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntryFilter>(create);
  static EntryFilter? _defaultInstance;

  /// Inclusive lower bound on start_time.
  @$pb.TagNumber(1)
  $1.Timestamp get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($1.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureFrom() => $_ensure(0);

  /// Exclusive upper bound on start_time.
  @$pb.TagNumber(2)
  $1.Timestamp get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get projectIds => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get taskIds => $_getList(3);

  /// Entries must carry every tag listed here.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get tags => $_getList(4);

  /// Case-insensitive substring match against the description.
  @$pb.TagNumber(6)
  $core.String get search => $_getSZ(5);
  @$pb.TagNumber(6)
  set search($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearch() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearch() => $_clearField(6);

  /// When true only the running entry is returned; when false running entries
  /// are excluded. Unset returns both.
  @$pb.TagNumber(7)
  $core.bool get running => $_getBF(6);
  @$pb.TagNumber(7)
  set running($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRunning() => $_has(6);
  @$pb.TagNumber(7)
  void clearRunning() => $_clearField(7);
}

class ListEntriesRequest extends $pb.GeneratedMessage {
  factory ListEntriesRequest({
    EntryFilter? filter,
    $2.PageRequest? page,
    $2.SortOrder? order,
  }) {
    final result = create();
    if (filter != null) result.filter = filter;
    if (page != null) result.page = page;
    if (order != null) result.order = order;
    return result;
  }

  ListEntriesRequest._();

  factory ListEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<EntryFilter>(1, _omitFieldNames ? '' : 'filter',
        subBuilder: EntryFilter.create)
    ..aOM<$2.PageRequest>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $2.PageRequest.create)
    ..aE<$2.SortOrder>(3, _omitFieldNames ? '' : 'order',
        enumValues: $2.SortOrder.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntriesRequest copyWith(void Function(ListEntriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListEntriesRequest))
          as ListEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEntriesRequest create() => ListEntriesRequest._();
  @$core.override
  ListEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEntriesRequest>(create);
  static ListEntriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  EntryFilter get filter => $_getN(0);
  @$pb.TagNumber(1)
  set filter(EntryFilter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilter() => $_clearField(1);
  @$pb.TagNumber(1)
  EntryFilter ensureFilter() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.PageRequest get page => $_getN(1);
  @$pb.TagNumber(2)
  set page($2.PageRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PageRequest ensurePage() => $_ensure(1);

  /// Sort direction on start_time. Defaults to descending (newest first).
  @$pb.TagNumber(3)
  $2.SortOrder get order => $_getN(2);
  @$pb.TagNumber(3)
  set order($2.SortOrder value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrder() => $_clearField(3);
}

class ListEntriesResponse extends $pb.GeneratedMessage {
  factory ListEntriesResponse({
    $core.Iterable<TimeEntry>? entries,
    $2.PageResponse? page,
    $fixnum.Int64? totalSeconds,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    if (page != null) result.page = page;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    return result;
  }

  ListEntriesResponse._();

  factory ListEntriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEntriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEntriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<TimeEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: TimeEntry.create)
    ..aOM<$2.PageResponse>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $2.PageResponse.create)
    ..aInt64(3, _omitFieldNames ? '' : 'totalSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntriesResponse copyWith(void Function(ListEntriesResponse) updates) =>
      super.copyWith((message) => updates(message as ListEntriesResponse))
          as ListEntriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEntriesResponse create() => ListEntriesResponse._();
  @$core.override
  ListEntriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEntriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEntriesResponse>(create);
  static ListEntriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimeEntry> get entries => $_getList(0);

  @$pb.TagNumber(2)
  $2.PageResponse get page => $_getN(1);
  @$pb.TagNumber(2)
  set page($2.PageResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PageResponse ensurePage() => $_ensure(1);

  /// Sum of duration_seconds across every entry matching the filter, not just
  /// the returned page.
  @$pb.TagNumber(3)
  $fixnum.Int64 get totalSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSeconds() => $_clearField(3);
}

class GetEntryRequest extends $pb.GeneratedMessage {
  factory GetEntryRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetEntryRequest._();

  factory GetEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEntryRequest copyWith(void Function(GetEntryRequest) updates) =>
      super.copyWith((message) => updates(message as GetEntryRequest))
          as GetEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEntryRequest create() => GetEntryRequest._();
  @$core.override
  GetEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEntryRequest>(create);
  static GetEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetEntryResponse extends $pb.GeneratedMessage {
  factory GetEntryResponse({
    TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  GetEntryResponse._();

  factory GetEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEntryResponse copyWith(void Function(GetEntryResponse) updates) =>
      super.copyWith((message) => updates(message as GetEntryResponse))
          as GetEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEntryResponse create() => GetEntryResponse._();
  @$core.override
  GetEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEntryResponse>(create);
  static GetEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  TimeEntry ensureEntry() => $_ensure(0);
}

class UpdateEntryRequest extends $pb.GeneratedMessage {
  factory UpdateEntryRequest({
    $fixnum.Int64? id,
    $core.Iterable<$core.String>? updateMask,
    $core.String? description,
    $fixnum.Int64? projectId,
    $fixnum.Int64? taskId,
    $core.Iterable<$core.String>? tags,
    TimeSpec? time,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (updateMask != null) result.updateMask.addAll(updateMask);
    if (description != null) result.description = description;
    if (projectId != null) result.projectId = projectId;
    if (taskId != null) result.taskId = taskId;
    if (tags != null) result.tags.addAll(tags);
    if (time != null) result.time = time;
    return result;
  }

  UpdateEntryRequest._();

  factory UpdateEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(2, _omitFieldNames ? '' : 'updateMask')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(6, _omitFieldNames ? '' : 'tags')
    ..aOM<TimeSpec>(7, _omitFieldNames ? '' : 'time',
        subBuilder: TimeSpec.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEntryRequest copyWith(void Function(UpdateEntryRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateEntryRequest))
          as UpdateEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateEntryRequest create() => UpdateEntryRequest._();
  @$core.override
  UpdateEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateEntryRequest>(create);
  static UpdateEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Valid mask values: "description", "project_id", "task_id", "tags",
  /// "start_time", "end_time", "duration_seconds". An empty mask updates every
  /// field present in the request.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get updateMask => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get projectId => $_getI64(3);
  @$pb.TagNumber(4)
  set projectId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProjectId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProjectId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get taskId => $_getI64(4);
  @$pb.TagNumber(5)
  set taskId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTaskId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTaskId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get tags => $_getList(5);

  @$pb.TagNumber(7)
  TimeSpec get time => $_getN(6);
  @$pb.TagNumber(7)
  set time(TimeSpec value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearTime() => $_clearField(7);
  @$pb.TagNumber(7)
  TimeSpec ensureTime() => $_ensure(6);
}

class UpdateEntryResponse extends $pb.GeneratedMessage {
  factory UpdateEntryResponse({
    TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  UpdateEntryResponse._();

  factory UpdateEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateEntryResponse copyWith(void Function(UpdateEntryResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateEntryResponse))
          as UpdateEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateEntryResponse create() => UpdateEntryResponse._();
  @$core.override
  UpdateEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateEntryResponse>(create);
  static UpdateEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  TimeEntry ensureEntry() => $_ensure(0);
}

class DeleteEntryRequest extends $pb.GeneratedMessage {
  factory DeleteEntryRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteEntryRequest._();

  factory DeleteEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntryRequest copyWith(void Function(DeleteEntryRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteEntryRequest))
          as DeleteEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEntryRequest create() => DeleteEntryRequest._();
  @$core.override
  DeleteEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEntryRequest>(create);
  static DeleteEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class CopyEntriesRequest extends $pb.GeneratedMessage {
  factory CopyEntriesRequest({
    $core.Iterable<$fixnum.Int64>? entryIds,
    $2.Date? targetDate,
  }) {
    final result = create();
    if (entryIds != null) result.entryIds.addAll(entryIds);
    if (targetDate != null) result.targetDate = targetDate;
    return result;
  }

  CopyEntriesRequest._();

  factory CopyEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CopyEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopyEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'entryIds', $pb.PbFieldType.KU6)
    ..aOM<$2.Date>(2, _omitFieldNames ? '' : 'targetDate',
        subBuilder: $2.Date.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyEntriesRequest copyWith(void Function(CopyEntriesRequest) updates) =>
      super.copyWith((message) => updates(message as CopyEntriesRequest))
          as CopyEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyEntriesRequest create() => CopyEntriesRequest._();
  @$core.override
  CopyEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CopyEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopyEntriesRequest>(create);
  static CopyEntriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get entryIds => $_getList(0);

  /// Date the copies should land on, interpreted in the user's timezone. The
  /// time of day of each source entry is preserved.
  @$pb.TagNumber(2)
  $2.Date get targetDate => $_getN(1);
  @$pb.TagNumber(2)
  set targetDate($2.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetDate() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Date ensureTargetDate() => $_ensure(1);
}

class CopyEntriesResponse extends $pb.GeneratedMessage {
  factory CopyEntriesResponse({
    $core.Iterable<TimeEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  CopyEntriesResponse._();

  factory CopyEntriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CopyEntriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopyEntriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<TimeEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyEntriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyEntriesResponse copyWith(void Function(CopyEntriesResponse) updates) =>
      super.copyWith((message) => updates(message as CopyEntriesResponse))
          as CopyEntriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyEntriesResponse create() => CopyEntriesResponse._();
  @$core.override
  CopyEntriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CopyEntriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopyEntriesResponse>(create);
  static CopyEntriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimeEntry> get entries => $_getList(0);
}

/// DeleteEntryResponse is intentionally empty; it exists so the RPC can gain
/// response fields later without a breaking change.
class DeleteEntryResponse extends $pb.GeneratedMessage {
  factory DeleteEntryResponse() => create();

  DeleteEntryResponse._();

  factory DeleteEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntryResponse copyWith(void Function(DeleteEntryResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteEntryResponse))
          as DeleteEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEntryResponse create() => DeleteEntryResponse._();
  @$core.override
  DeleteEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEntryResponse>(create);
  static DeleteEntryResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
