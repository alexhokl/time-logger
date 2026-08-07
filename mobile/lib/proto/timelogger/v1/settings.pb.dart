// This is a generated file - do not edit.
//
// Generated from timelogger/v1/settings.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'settings.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'settings.pbenum.dart';

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.String? timezone,
    DayOfWeek? weekStartsOn,
    $core.int? roundingMinutes,
    $fixnum.Int64? defaultProjectId,
    $core.String? defaultProjectName,
  }) {
    final result = create();
    if (timezone != null) result.timezone = timezone;
    if (weekStartsOn != null) result.weekStartsOn = weekStartsOn;
    if (roundingMinutes != null) result.roundingMinutes = roundingMinutes;
    if (defaultProjectId != null) result.defaultProjectId = defaultProjectId;
    if (defaultProjectName != null)
      result.defaultProjectName = defaultProjectName;
    return result;
  }

  Settings._();

  factory Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'timezone')
    ..aE<DayOfWeek>(2, _omitFieldNames ? '' : 'weekStartsOn',
        enumValues: DayOfWeek.values)
    ..aI(3, _omitFieldNames ? '' : 'roundingMinutes')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'defaultProjectId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'defaultProjectName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings copyWith(void Function(Settings) updates) =>
      super.copyWith((message) => updates(message as Settings)) as Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  @$core.override
  Settings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  /// IANA timezone name, e.g. "Asia/Hong_Kong". All report day boundaries and
  /// date-only inputs are interpreted in this zone.
  @$pb.TagNumber(1)
  $core.String get timezone => $_getSZ(0);
  @$pb.TagNumber(1)
  set timezone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimezone() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimezone() => $_clearField(1);

  @$pb.TagNumber(2)
  DayOfWeek get weekStartsOn => $_getN(1);
  @$pb.TagNumber(2)
  set weekStartsOn(DayOfWeek value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWeekStartsOn() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeekStartsOn() => $_clearField(2);

  /// When non-zero, entry durations are rounded up to a multiple of this many
  /// minutes when they are reported. Storage always keeps the exact value.
  @$pb.TagNumber(3)
  $core.int get roundingMinutes => $_getIZ(2);
  @$pb.TagNumber(3)
  set roundingMinutes($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoundingMinutes() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoundingMinutes() => $_clearField(3);

  /// Project pre-selected by clients when starting a timer. Zero means none.
  @$pb.TagNumber(4)
  $fixnum.Int64 get defaultProjectId => $_getI64(3);
  @$pb.TagNumber(4)
  set defaultProjectId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultProjectId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultProjectId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get defaultProjectName => $_getSZ(4);
  @$pb.TagNumber(5)
  set defaultProjectName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDefaultProjectName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDefaultProjectName() => $_clearField(5);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => create();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    Settings? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse create() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(create);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $core.Iterable<$core.String>? updateMask,
    Settings? settings,
  }) {
    final result = create();
    if (updateMask != null) result.updateMask.addAll(updateMask);
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'updateMask')
    ..aOM<Settings>(2, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  /// Valid mask values: "timezone", "week_starts_on", "rounding_minutes",
  /// "default_project_id".
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get updateMask => $_getList(0);

  @$pb.TagNumber(2)
  Settings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(Settings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  Settings ensureSettings() => $_ensure(1);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    Settings? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'timelogger.v1'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(create);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
