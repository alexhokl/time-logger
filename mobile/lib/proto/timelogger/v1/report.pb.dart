// This is a generated file - do not edit.
//
// Generated from timelogger/v1/report.proto.

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
import 'report.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'report.pbenum.dart';

/// ReportRow is one bucket of a period report.
class ReportRow extends $pb.GeneratedMessage {
  factory ReportRow({
    $fixnum.Int64? id,
    $core.String? label,
    $fixnum.Int64? totalSeconds,
    $fixnum.Int64? entryCount,
    $core.double? percentage,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (label != null) result.label = label;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (entryCount != null) result.entryCount = entryCount;
    if (percentage != null) result.percentage = percentage;
    return result;
  }

  ReportRow._();

  factory ReportRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aInt64(3, _omitFieldNames ? '' : 'totalSeconds')
    ..aInt64(4, _omitFieldNames ? '' : 'entryCount')
    ..aD(5, _omitFieldNames ? '' : 'percentage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportRow copyWith(void Function(ReportRow) updates) =>
      super.copyWith((message) => updates(message as ReportRow)) as ReportRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportRow create() => ReportRow._();
  @$core.override
  ReportRow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportRow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportRow>(create);
  static ReportRow? _defaultInstance;

  /// Identifier of the grouping dimension: the project, task or tag id. Zero
  /// for GROUP_BY_DAY and for the "no project"/"no task" bucket.
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Human-readable label: project name, task name, tag name, or ISO date.
  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get entryCount => $_getI64(3);
  @$pb.TagNumber(4)
  set entryCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryCount() => $_clearField(4);

  /// Share of the report total, between 0 and 100.
  @$pb.TagNumber(5)
  $core.double get percentage => $_getN(4);
  @$pb.TagNumber(5)
  set percentage($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPercentage() => $_has(4);
  @$pb.TagNumber(5)
  void clearPercentage() => $_clearField(5);
}

class PeriodReport extends $pb.GeneratedMessage {
  factory PeriodReport({
    $1.Date? from,
    $1.Date? to,
    $core.Iterable<ReportRow>? rows,
    $fixnum.Int64? totalSeconds,
    $fixnum.Int64? entryCount,
    $core.String? timezone,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (rows != null) result.rows.addAll(rows);
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (entryCount != null) result.entryCount = entryCount;
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  PeriodReport._();

  factory PeriodReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PeriodReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeriodReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'from', subBuilder: $1.Date.create)
    ..aOM<$1.Date>(2, _omitFieldNames ? '' : 'to', subBuilder: $1.Date.create)
    ..pPM<ReportRow>(3, _omitFieldNames ? '' : 'rows',
        subBuilder: ReportRow.create)
    ..aInt64(4, _omitFieldNames ? '' : 'totalSeconds')
    ..aInt64(5, _omitFieldNames ? '' : 'entryCount')
    ..aOS(6, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeriodReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeriodReport copyWith(void Function(PeriodReport) updates) =>
      super.copyWith((message) => updates(message as PeriodReport))
          as PeriodReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeriodReport create() => PeriodReport._();
  @$core.override
  PeriodReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PeriodReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PeriodReport>(create);
  static PeriodReport? _defaultInstance;

  /// Inclusive first day covered by the report.
  @$pb.TagNumber(1)
  $1.Date get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureFrom() => $_ensure(0);

  /// Inclusive last day covered by the report.
  @$pb.TagNumber(2)
  $1.Date get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($1.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Date ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<ReportRow> get rows => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get entryCount => $_getI64(4);
  @$pb.TagNumber(5)
  set entryCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEntryCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearEntryCount() => $_clearField(5);

  /// IANA timezone the day boundaries were computed in.
  @$pb.TagNumber(6)
  $core.String get timezone => $_getSZ(5);
  @$pb.TagNumber(6)
  set timezone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimezone() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimezone() => $_clearField(6);
}

class ReportOptions extends $pb.GeneratedMessage {
  factory ReportOptions({
    GroupBy? groupBy,
    $core.Iterable<$fixnum.Int64>? projectIds,
    $core.Iterable<$fixnum.Int64>? taskIds,
    $core.Iterable<$core.String>? tags,
  }) {
    final result = create();
    if (groupBy != null) result.groupBy = groupBy;
    if (projectIds != null) result.projectIds.addAll(projectIds);
    if (taskIds != null) result.taskIds.addAll(taskIds);
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  ReportOptions._();

  factory ReportOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aE<GroupBy>(1, _omitFieldNames ? '' : 'groupBy',
        enumValues: GroupBy.values)
    ..p<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectIds', $pb.PbFieldType.KU6)
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'taskIds', $pb.PbFieldType.KU6)
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportOptions copyWith(void Function(ReportOptions) updates) =>
      super.copyWith((message) => updates(message as ReportOptions))
          as ReportOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportOptions create() => ReportOptions._();
  @$core.override
  ReportOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportOptions>(create);
  static ReportOptions? _defaultInstance;

  @$pb.TagNumber(1)
  GroupBy get groupBy => $_getN(0);
  @$pb.TagNumber(1)
  set groupBy(GroupBy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupBy() => $_clearField(1);

  /// Optional filters applied before aggregation.
  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get projectIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get taskIds => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tags => $_getList(3);
}

/// Each period RPC has its own response wrapper around the shared
/// PeriodReport payload so that any one of them can grow new fields
/// independently.
class GetDailyReportResponse extends $pb.GeneratedMessage {
  factory GetDailyReportResponse({
    PeriodReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetDailyReportResponse._();

  factory GetDailyReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDailyReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<PeriodReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: PeriodReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReportResponse copyWith(
          void Function(GetDailyReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetDailyReportResponse))
          as GetDailyReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDailyReportResponse create() => GetDailyReportResponse._();
  @$core.override
  GetDailyReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDailyReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReportResponse>(create);
  static GetDailyReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PeriodReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(PeriodReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  PeriodReport ensureReport() => $_ensure(0);
}

class GetWeeklyReportResponse extends $pb.GeneratedMessage {
  factory GetWeeklyReportResponse({
    PeriodReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetWeeklyReportResponse._();

  factory GetWeeklyReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWeeklyReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWeeklyReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<PeriodReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: PeriodReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWeeklyReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWeeklyReportResponse copyWith(
          void Function(GetWeeklyReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetWeeklyReportResponse))
          as GetWeeklyReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWeeklyReportResponse create() => GetWeeklyReportResponse._();
  @$core.override
  GetWeeklyReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWeeklyReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWeeklyReportResponse>(create);
  static GetWeeklyReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PeriodReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(PeriodReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  PeriodReport ensureReport() => $_ensure(0);
}

class GetMonthlyReportResponse extends $pb.GeneratedMessage {
  factory GetMonthlyReportResponse({
    PeriodReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetMonthlyReportResponse._();

  factory GetMonthlyReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMonthlyReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMonthlyReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<PeriodReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: PeriodReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyReportResponse copyWith(
          void Function(GetMonthlyReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetMonthlyReportResponse))
          as GetMonthlyReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMonthlyReportResponse create() => GetMonthlyReportResponse._();
  @$core.override
  GetMonthlyReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMonthlyReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMonthlyReportResponse>(create);
  static GetMonthlyReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PeriodReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(PeriodReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  PeriodReport ensureReport() => $_ensure(0);
}

class GetRangeReportResponse extends $pb.GeneratedMessage {
  factory GetRangeReportResponse({
    PeriodReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetRangeReportResponse._();

  factory GetRangeReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRangeReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRangeReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<PeriodReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: PeriodReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRangeReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRangeReportResponse copyWith(
          void Function(GetRangeReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetRangeReportResponse))
          as GetRangeReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRangeReportResponse create() => GetRangeReportResponse._();
  @$core.override
  GetRangeReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRangeReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRangeReportResponse>(create);
  static GetRangeReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PeriodReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(PeriodReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  PeriodReport ensureReport() => $_ensure(0);
}

class GetDailyReportRequest extends $pb.GeneratedMessage {
  factory GetDailyReportRequest({
    $1.Date? date,
    ReportOptions? options,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (options != null) result.options = options;
    return result;
  }

  GetDailyReportRequest._();

  factory GetDailyReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDailyReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'date', subBuilder: $1.Date.create)
    ..aOM<ReportOptions>(2, _omitFieldNames ? '' : 'options',
        subBuilder: ReportOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReportRequest copyWith(
          void Function(GetDailyReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetDailyReportRequest))
          as GetDailyReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDailyReportRequest create() => GetDailyReportRequest._();
  @$core.override
  GetDailyReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDailyReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReportRequest>(create);
  static GetDailyReportRequest? _defaultInstance;

  /// Defaults to today in the user's timezone.
  @$pb.TagNumber(1)
  $1.Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  ReportOptions get options => $_getN(1);
  @$pb.TagNumber(2)
  set options(ReportOptions value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
  @$pb.TagNumber(2)
  ReportOptions ensureOptions() => $_ensure(1);
}

class GetWeeklyReportRequest extends $pb.GeneratedMessage {
  factory GetWeeklyReportRequest({
    $1.Date? date,
    ReportOptions? options,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (options != null) result.options = options;
    return result;
  }

  GetWeeklyReportRequest._();

  factory GetWeeklyReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWeeklyReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWeeklyReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'date', subBuilder: $1.Date.create)
    ..aOM<ReportOptions>(2, _omitFieldNames ? '' : 'options',
        subBuilder: ReportOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWeeklyReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWeeklyReportRequest copyWith(
          void Function(GetWeeklyReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetWeeklyReportRequest))
          as GetWeeklyReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWeeklyReportRequest create() => GetWeeklyReportRequest._();
  @$core.override
  GetWeeklyReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWeeklyReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWeeklyReportRequest>(create);
  static GetWeeklyReportRequest? _defaultInstance;

  /// Any date within the desired week. Defaults to today.
  @$pb.TagNumber(1)
  $1.Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  ReportOptions get options => $_getN(1);
  @$pb.TagNumber(2)
  set options(ReportOptions value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
  @$pb.TagNumber(2)
  ReportOptions ensureOptions() => $_ensure(1);
}

class GetMonthlyReportRequest extends $pb.GeneratedMessage {
  factory GetMonthlyReportRequest({
    $1.Date? date,
    ReportOptions? options,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (options != null) result.options = options;
    return result;
  }

  GetMonthlyReportRequest._();

  factory GetMonthlyReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMonthlyReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMonthlyReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'date', subBuilder: $1.Date.create)
    ..aOM<ReportOptions>(2, _omitFieldNames ? '' : 'options',
        subBuilder: ReportOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyReportRequest copyWith(
          void Function(GetMonthlyReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetMonthlyReportRequest))
          as GetMonthlyReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMonthlyReportRequest create() => GetMonthlyReportRequest._();
  @$core.override
  GetMonthlyReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMonthlyReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMonthlyReportRequest>(create);
  static GetMonthlyReportRequest? _defaultInstance;

  /// Any date within the desired month. Defaults to today.
  @$pb.TagNumber(1)
  $1.Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  ReportOptions get options => $_getN(1);
  @$pb.TagNumber(2)
  set options(ReportOptions value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
  @$pb.TagNumber(2)
  ReportOptions ensureOptions() => $_ensure(1);
}

class GetRangeReportRequest extends $pb.GeneratedMessage {
  factory GetRangeReportRequest({
    $1.Date? from,
    $1.Date? to,
    ReportOptions? options,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (options != null) result.options = options;
    return result;
  }

  GetRangeReportRequest._();

  factory GetRangeReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRangeReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRangeReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'from', subBuilder: $1.Date.create)
    ..aOM<$1.Date>(2, _omitFieldNames ? '' : 'to', subBuilder: $1.Date.create)
    ..aOM<ReportOptions>(3, _omitFieldNames ? '' : 'options',
        subBuilder: ReportOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRangeReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRangeReportRequest copyWith(
          void Function(GetRangeReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetRangeReportRequest))
          as GetRangeReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRangeReportRequest create() => GetRangeReportRequest._();
  @$core.override
  GetRangeReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRangeReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRangeReportRequest>(create);
  static GetRangeReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Date get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Date get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($1.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Date ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  ReportOptions get options => $_getN(2);
  @$pb.TagNumber(3)
  set options(ReportOptions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptions() => $_clearField(3);
  @$pb.TagNumber(3)
  ReportOptions ensureOptions() => $_ensure(2);
}

class GetGoalReportRequest extends $pb.GeneratedMessage {
  factory GetGoalReportRequest({
    $1.Date? date,
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (projectId != null) result.projectId = projectId;
    return result;
  }

  GetGoalReportRequest._();

  factory GetGoalReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'date', subBuilder: $1.Date.create)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalReportRequest copyWith(void Function(GetGoalReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetGoalReportRequest))
          as GetGoalReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalReportRequest create() => GetGoalReportRequest._();
  @$core.override
  GetGoalReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalReportRequest>(create);
  static GetGoalReportRequest? _defaultInstance;

  /// Any date inside the period to evaluate. Defaults to today.
  @$pb.TagNumber(1)
  $1.Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureDate() => $_ensure(0);

  /// Restrict the report to a single project. Zero means all goals.
  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);
}

class GoalProgress extends $pb.GeneratedMessage {
  factory GoalProgress({
    $fixnum.Int64? goalId,
    $fixnum.Int64? projectId,
    $core.String? projectName,
    $fixnum.Int64? taskId,
    $core.String? taskName,
    $1.Period? period,
    $1.Date? periodStart,
    $1.Date? periodEnd,
    $fixnum.Int64? targetSeconds,
    $fixnum.Int64? actualSeconds,
    $core.double? percentage,
    $fixnum.Int64? remainingSeconds,
    $core.bool? met,
  }) {
    final result = create();
    if (goalId != null) result.goalId = goalId;
    if (projectId != null) result.projectId = projectId;
    if (projectName != null) result.projectName = projectName;
    if (taskId != null) result.taskId = taskId;
    if (taskName != null) result.taskName = taskName;
    if (period != null) result.period = period;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (targetSeconds != null) result.targetSeconds = targetSeconds;
    if (actualSeconds != null) result.actualSeconds = actualSeconds;
    if (percentage != null) result.percentage = percentage;
    if (remainingSeconds != null) result.remainingSeconds = remainingSeconds;
    if (met != null) result.met = met;
    return result;
  }

  GoalProgress._();

  factory GoalProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoalProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoalProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'goalId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'projectName')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'taskId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'taskName')
    ..aE<$1.Period>(6, _omitFieldNames ? '' : 'period',
        enumValues: $1.Period.values)
    ..aOM<$1.Date>(7, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $1.Date.create)
    ..aOM<$1.Date>(8, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $1.Date.create)
    ..aInt64(9, _omitFieldNames ? '' : 'targetSeconds')
    ..aInt64(10, _omitFieldNames ? '' : 'actualSeconds')
    ..aD(11, _omitFieldNames ? '' : 'percentage')
    ..aInt64(12, _omitFieldNames ? '' : 'remainingSeconds')
    ..aOB(13, _omitFieldNames ? '' : 'met')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalProgress copyWith(void Function(GoalProgress) updates) =>
      super.copyWith((message) => updates(message as GoalProgress))
          as GoalProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoalProgress create() => GoalProgress._();
  @$core.override
  GoalProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GoalProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoalProgress>(create);
  static GoalProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get goalId => $_getI64(0);
  @$pb.TagNumber(1)
  set goalId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoalId() => $_clearField(1);

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

  @$pb.TagNumber(6)
  $1.Period get period => $_getN(5);
  @$pb.TagNumber(6)
  set period($1.Period value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriod() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriod() => $_clearField(6);

  /// Inclusive bounds of the period the progress was measured over.
  @$pb.TagNumber(7)
  $1.Date get periodStart => $_getN(6);
  @$pb.TagNumber(7)
  set periodStart($1.Date value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPeriodStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearPeriodStart() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Date ensurePeriodStart() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Date get periodEnd => $_getN(7);
  @$pb.TagNumber(8)
  set periodEnd($1.Date value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPeriodEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearPeriodEnd() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Date ensurePeriodEnd() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get targetSeconds => $_getI64(8);
  @$pb.TagNumber(9)
  set targetSeconds($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get actualSeconds => $_getI64(9);
  @$pb.TagNumber(10)
  set actualSeconds($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasActualSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearActualSeconds() => $_clearField(10);

  /// actual / target as a percentage; may exceed 100.
  @$pb.TagNumber(11)
  $core.double get percentage => $_getN(10);
  @$pb.TagNumber(11)
  set percentage($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPercentage() => $_has(10);
  @$pb.TagNumber(11)
  void clearPercentage() => $_clearField(11);

  /// target - actual; negative when the target has been exceeded.
  @$pb.TagNumber(12)
  $fixnum.Int64 get remainingSeconds => $_getI64(11);
  @$pb.TagNumber(12)
  set remainingSeconds($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRemainingSeconds() => $_has(11);
  @$pb.TagNumber(12)
  void clearRemainingSeconds() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get met => $_getBF(12);
  @$pb.TagNumber(13)
  set met($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMet() => $_has(12);
  @$pb.TagNumber(13)
  void clearMet() => $_clearField(13);
}

class GetGoalReportResponse extends $pb.GeneratedMessage {
  factory GetGoalReportResponse({
    $core.Iterable<GoalProgress>? progress,
    $core.String? timezone,
  }) {
    final result = create();
    if (progress != null) result.progress.addAll(progress);
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  GetGoalReportResponse._();

  factory GetGoalReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetGoalReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetGoalReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<GoalProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: GoalProgress.create)
    ..aOS(2, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetGoalReportResponse copyWith(
          void Function(GetGoalReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetGoalReportResponse))
          as GetGoalReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetGoalReportResponse create() => GetGoalReportResponse._();
  @$core.override
  GetGoalReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetGoalReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetGoalReportResponse>(create);
  static GetGoalReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GoalProgress> get progress => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get timezone => $_getSZ(1);
  @$pb.TagNumber(2)
  set timezone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimezone() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimezone() => $_clearField(2);
}

class GetActivityHeatmapRequest extends $pb.GeneratedMessage {
  factory GetActivityHeatmapRequest({
    $1.Date? from,
    $1.Date? to,
    $core.Iterable<$fixnum.Int64>? projectIds,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (projectIds != null) result.projectIds.addAll(projectIds);
    return result;
  }

  GetActivityHeatmapRequest._();

  factory GetActivityHeatmapRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActivityHeatmapRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActivityHeatmapRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'from', subBuilder: $1.Date.create)
    ..aOM<$1.Date>(2, _omitFieldNames ? '' : 'to', subBuilder: $1.Date.create)
    ..p<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'projectIds', $pb.PbFieldType.KU6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivityHeatmapRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivityHeatmapRequest copyWith(
          void Function(GetActivityHeatmapRequest) updates) =>
      super.copyWith((message) => updates(message as GetActivityHeatmapRequest))
          as GetActivityHeatmapRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActivityHeatmapRequest create() => GetActivityHeatmapRequest._();
  @$core.override
  GetActivityHeatmapRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActivityHeatmapRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActivityHeatmapRequest>(create);
  static GetActivityHeatmapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Date get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Date get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($1.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Date ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get projectIds => $_getList(2);
}

class HeatmapDay extends $pb.GeneratedMessage {
  factory HeatmapDay({
    $1.Date? date,
    $fixnum.Int64? totalSeconds,
    $fixnum.Int64? entryCount,
    $core.int? level,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (entryCount != null) result.entryCount = entryCount;
    if (level != null) result.level = level;
    return result;
  }

  HeatmapDay._();

  factory HeatmapDay.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeatmapDay.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeatmapDay',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'date', subBuilder: $1.Date.create)
    ..aInt64(2, _omitFieldNames ? '' : 'totalSeconds')
    ..aInt64(3, _omitFieldNames ? '' : 'entryCount')
    ..aI(4, _omitFieldNames ? '' : 'level')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeatmapDay clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeatmapDay copyWith(void Function(HeatmapDay) updates) =>
      super.copyWith((message) => updates(message as HeatmapDay)) as HeatmapDay;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeatmapDay create() => HeatmapDay._();
  @$core.override
  HeatmapDay createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeatmapDay getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeatmapDay>(create);
  static HeatmapDay? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get entryCount => $_getI64(2);
  @$pb.TagNumber(3)
  set entryCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntryCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntryCount() => $_clearField(3);

  /// Bucketed intensity from 0 (no activity) to 4 (busiest quartile), computed
  /// relative to the busiest day in the requested range.
  @$pb.TagNumber(4)
  $core.int get level => $_getIZ(3);
  @$pb.TagNumber(4)
  set level($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLevel() => $_clearField(4);
}

class GetActivityHeatmapResponse extends $pb.GeneratedMessage {
  factory GetActivityHeatmapResponse({
    $core.Iterable<HeatmapDay>? days,
    $fixnum.Int64? maxSeconds,
    $fixnum.Int64? totalSeconds,
    $core.String? timezone,
  }) {
    final result = create();
    if (days != null) result.days.addAll(days);
    if (maxSeconds != null) result.maxSeconds = maxSeconds;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  GetActivityHeatmapResponse._();

  factory GetActivityHeatmapResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetActivityHeatmapResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActivityHeatmapResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPM<HeatmapDay>(1, _omitFieldNames ? '' : 'days',
        subBuilder: HeatmapDay.create)
    ..aInt64(2, _omitFieldNames ? '' : 'maxSeconds')
    ..aInt64(3, _omitFieldNames ? '' : 'totalSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivityHeatmapResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivityHeatmapResponse copyWith(
          void Function(GetActivityHeatmapResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetActivityHeatmapResponse))
          as GetActivityHeatmapResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActivityHeatmapResponse create() => GetActivityHeatmapResponse._();
  @$core.override
  GetActivityHeatmapResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetActivityHeatmapResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActivityHeatmapResponse>(create);
  static GetActivityHeatmapResponse? _defaultInstance;

  /// One entry per day in the range, including days with no activity.
  @$pb.TagNumber(1)
  $pb.PbList<HeatmapDay> get days => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set maxSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get timezone => $_getSZ(3);
  @$pb.TagNumber(4)
  set timezone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimezone() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimezone() => $_clearField(4);
}

class GetStreaksRequest extends $pb.GeneratedMessage {
  factory GetStreaksRequest({
    $1.Date? from,
    $1.Date? to,
    $fixnum.Int64? minimumSeconds,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (minimumSeconds != null) result.minimumSeconds = minimumSeconds;
    return result;
  }

  GetStreaksRequest._();

  factory GetStreaksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStreaksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreaksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'from', subBuilder: $1.Date.create)
    ..aOM<$1.Date>(2, _omitFieldNames ? '' : 'to', subBuilder: $1.Date.create)
    ..aInt64(3, _omitFieldNames ? '' : 'minimumSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreaksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreaksRequest copyWith(void Function(GetStreaksRequest) updates) =>
      super.copyWith((message) => updates(message as GetStreaksRequest))
          as GetStreaksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStreaksRequest create() => GetStreaksRequest._();
  @$core.override
  GetStreaksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStreaksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStreaksRequest>(create);
  static GetStreaksRequest? _defaultInstance;

  /// Range to search within. Defaults to the last 365 days ending today.
  @$pb.TagNumber(1)
  $1.Date get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Date get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($1.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Date ensureTo() => $_ensure(1);

  /// A day counts towards a streak only if at least this many seconds were
  /// tracked. Zero means any tracked time counts.
  @$pb.TagNumber(3)
  $fixnum.Int64 get minimumSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set minimumSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinimumSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinimumSeconds() => $_clearField(3);
}

class Streak extends $pb.GeneratedMessage {
  factory Streak({
    $1.Date? startDate,
    $1.Date? endDate,
    $core.int? days,
    $fixnum.Int64? totalSeconds,
  }) {
    final result = create();
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (days != null) result.days = days;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    return result;
  }

  Streak._();

  factory Streak.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Streak.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Streak',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Date>(1, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Date.create)
    ..aOM<$1.Date>(2, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Date.create)
    ..aI(3, _omitFieldNames ? '' : 'days')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Streak clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Streak copyWith(void Function(Streak) updates) =>
      super.copyWith((message) => updates(message as Streak)) as Streak;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Streak create() => Streak._();
  @$core.override
  Streak createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Streak getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Streak>(create);
  static Streak? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Date get startDate => $_getN(0);
  @$pb.TagNumber(1)
  set startDate($1.Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Date ensureStartDate() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Date get endDate => $_getN(1);
  @$pb.TagNumber(2)
  set endDate($1.Date value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndDate() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Date ensureEndDate() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get days => $_getIZ(2);
  @$pb.TagNumber(3)
  set days($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearDays() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSeconds() => $_clearField(4);
}

class GetStreaksResponse extends $pb.GeneratedMessage {
  factory GetStreaksResponse({
    Streak? current,
    Streak? longest,
    $core.Iterable<Streak>? streaks,
    $core.int? activeDays,
    $core.String? timezone,
  }) {
    final result = create();
    if (current != null) result.current = current;
    if (longest != null) result.longest = longest;
    if (streaks != null) result.streaks.addAll(streaks);
    if (activeDays != null) result.activeDays = activeDays;
    if (timezone != null) result.timezone = timezone;
    return result;
  }

  GetStreaksResponse._();

  factory GetStreaksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStreaksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreaksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Streak>(1, _omitFieldNames ? '' : 'current',
        subBuilder: Streak.create)
    ..aOM<Streak>(2, _omitFieldNames ? '' : 'longest',
        subBuilder: Streak.create)
    ..pPM<Streak>(3, _omitFieldNames ? '' : 'streaks',
        subBuilder: Streak.create)
    ..aI(4, _omitFieldNames ? '' : 'activeDays')
    ..aOS(5, _omitFieldNames ? '' : 'timezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreaksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreaksResponse copyWith(void Function(GetStreaksResponse) updates) =>
      super.copyWith((message) => updates(message as GetStreaksResponse))
          as GetStreaksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStreaksResponse create() => GetStreaksResponse._();
  @$core.override
  GetStreaksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStreaksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStreaksResponse>(create);
  static GetStreaksResponse? _defaultInstance;

  /// Streak that includes today, if any.
  @$pb.TagNumber(1)
  Streak get current => $_getN(0);
  @$pb.TagNumber(1)
  set current(Streak value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrent() => $_clearField(1);
  @$pb.TagNumber(1)
  Streak ensureCurrent() => $_ensure(0);

  /// Longest streak found in the range.
  @$pb.TagNumber(2)
  Streak get longest => $_getN(1);
  @$pb.TagNumber(2)
  set longest(Streak value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLongest() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongest() => $_clearField(2);
  @$pb.TagNumber(2)
  Streak ensureLongest() => $_ensure(1);

  /// Every streak in the range, newest first.
  @$pb.TagNumber(3)
  $pb.PbList<Streak> get streaks => $_getList(2);

  /// Total number of days in the range with any tracked time.
  @$pb.TagNumber(4)
  $core.int get activeDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeDays($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get timezone => $_getSZ(4);
  @$pb.TagNumber(5)
  set timezone($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimezone() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimezone() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
