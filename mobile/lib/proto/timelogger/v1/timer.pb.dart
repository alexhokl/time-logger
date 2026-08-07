// This is a generated file - do not edit.
//
// Generated from timelogger/v1/timer.proto.

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

import 'entry.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class StartTimerRequest extends $pb.GeneratedMessage {
  factory StartTimerRequest({
    $core.String? description,
    $fixnum.Int64? projectId,
    $fixnum.Int64? taskId,
    $core.Iterable<$core.String>? tags,
    $1.Timestamp? startTime,
  }) {
    final result = create();
    if (description != null) result.description = description;
    if (projectId != null) result.projectId = projectId;
    if (taskId != null) result.taskId = taskId;
    if (tags != null) result.tags.addAll(tags);
    if (startTime != null) result.startTime = startTime;
    return result;
  }

  StartTimerRequest._();

  factory StartTimerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTimerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTimerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'startTime',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTimerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTimerRequest copyWith(void Function(StartTimerRequest) updates) =>
      super.copyWith((message) => updates(message as StartTimerRequest))
          as StartTimerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTimerRequest create() => StartTimerRequest._();
  @$core.override
  StartTimerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTimerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTimerRequest>(create);
  static StartTimerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get description => $_getSZ(0);
  @$pb.TagNumber(1)
  set description($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get taskId => $_getI64(2);
  @$pb.TagNumber(3)
  set taskId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tags => $_getList(3);

  /// Defaults to the server's current time when unset. Useful for backdating a
  /// timer the user forgot to start.
  @$pb.TagNumber(5)
  $1.Timestamp get startTime => $_getN(4);
  @$pb.TagNumber(5)
  set startTime($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartTime() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureStartTime() => $_ensure(4);
}

class StartTimerResponse extends $pb.GeneratedMessage {
  factory StartTimerResponse({
    $2.TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  StartTimerResponse._();

  factory StartTimerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTimerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTimerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$2.TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: $2.TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTimerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTimerResponse copyWith(void Function(StartTimerResponse) updates) =>
      super.copyWith((message) => updates(message as StartTimerResponse))
          as StartTimerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTimerResponse create() => StartTimerResponse._();
  @$core.override
  StartTimerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTimerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTimerResponse>(create);
  static StartTimerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($2.TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.TimeEntry ensureEntry() => $_ensure(0);
}

class StopTimerRequest extends $pb.GeneratedMessage {
  factory StopTimerRequest({
    $1.Timestamp? endTime,
    $core.String? description,
  }) {
    final result = create();
    if (endTime != null) result.endTime = endTime;
    if (description != null) result.description = description;
    return result;
  }

  StopTimerRequest._();

  factory StopTimerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopTimerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopTimerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'endTime',
        subBuilder: $1.Timestamp.create)
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopTimerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopTimerRequest copyWith(void Function(StopTimerRequest) updates) =>
      super.copyWith((message) => updates(message as StopTimerRequest))
          as StopTimerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopTimerRequest create() => StopTimerRequest._();
  @$core.override
  StopTimerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopTimerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopTimerRequest>(create);
  static StopTimerRequest? _defaultInstance;

  /// Defaults to the server's current time when unset. Must be at or after the
  /// running entry's start_time.
  @$pb.TagNumber(1)
  $1.Timestamp get endTime => $_getN(0);
  @$pb.TagNumber(1)
  set endTime($1.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEndTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureEndTime() => $_ensure(0);

  /// When set, the running entry's description is replaced before it is
  /// closed. Lets the user name the work after the fact.
  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);
}

class StopTimerResponse extends $pb.GeneratedMessage {
  factory StopTimerResponse({
    $2.TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  StopTimerResponse._();

  factory StopTimerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopTimerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopTimerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$2.TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: $2.TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopTimerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopTimerResponse copyWith(void Function(StopTimerResponse) updates) =>
      super.copyWith((message) => updates(message as StopTimerResponse))
          as StopTimerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopTimerResponse create() => StopTimerResponse._();
  @$core.override
  StopTimerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopTimerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopTimerResponse>(create);
  static StopTimerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($2.TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.TimeEntry ensureEntry() => $_ensure(0);
}

class GetRunningTimerRequest extends $pb.GeneratedMessage {
  factory GetRunningTimerRequest() => create();

  GetRunningTimerRequest._();

  factory GetRunningTimerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunningTimerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunningTimerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunningTimerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunningTimerRequest copyWith(
          void Function(GetRunningTimerRequest) updates) =>
      super.copyWith((message) => updates(message as GetRunningTimerRequest))
          as GetRunningTimerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunningTimerRequest create() => GetRunningTimerRequest._();
  @$core.override
  GetRunningTimerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRunningTimerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunningTimerRequest>(create);
  static GetRunningTimerRequest? _defaultInstance;
}

class GetRunningTimerResponse extends $pb.GeneratedMessage {
  factory GetRunningTimerResponse({
    $2.TimeEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  GetRunningTimerResponse._();

  factory GetRunningTimerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunningTimerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunningTimerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$2.TimeEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: $2.TimeEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunningTimerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunningTimerResponse copyWith(
          void Function(GetRunningTimerResponse) updates) =>
      super.copyWith((message) => updates(message as GetRunningTimerResponse))
          as GetRunningTimerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunningTimerResponse create() => GetRunningTimerResponse._();
  @$core.override
  GetRunningTimerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRunningTimerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunningTimerResponse>(create);
  static GetRunningTimerResponse? _defaultInstance;

  /// Unset when no timer is running.
  @$pb.TagNumber(1)
  $2.TimeEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($2.TimeEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.TimeEntry ensureEntry() => $_ensure(0);
}

class CancelRunningTimerRequest extends $pb.GeneratedMessage {
  factory CancelRunningTimerRequest() => create();

  CancelRunningTimerRequest._();

  factory CancelRunningTimerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRunningTimerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRunningTimerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunningTimerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunningTimerRequest copyWith(
          void Function(CancelRunningTimerRequest) updates) =>
      super.copyWith((message) => updates(message as CancelRunningTimerRequest))
          as CancelRunningTimerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRunningTimerRequest create() => CancelRunningTimerRequest._();
  @$core.override
  CancelRunningTimerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelRunningTimerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRunningTimerRequest>(create);
  static CancelRunningTimerRequest? _defaultInstance;
}

/// CancelRunningTimerResponse is intentionally empty; it exists so the RPC can gain
/// response fields later without a breaking change.
class CancelRunningTimerResponse extends $pb.GeneratedMessage {
  factory CancelRunningTimerResponse() => create();

  CancelRunningTimerResponse._();

  factory CancelRunningTimerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRunningTimerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRunningTimerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunningTimerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRunningTimerResponse copyWith(
          void Function(CancelRunningTimerResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CancelRunningTimerResponse))
          as CancelRunningTimerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRunningTimerResponse create() => CancelRunningTimerResponse._();
  @$core.override
  CancelRunningTimerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelRunningTimerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRunningTimerResponse>(create);
  static CancelRunningTimerResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
