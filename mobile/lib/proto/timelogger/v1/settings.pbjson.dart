// This is a generated file - do not edit.
//
// Generated from timelogger/v1/settings.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use dayOfWeekDescriptor instead')
const DayOfWeek$json = {
  '1': 'DayOfWeek',
  '2': [
    {'1': 'DAY_OF_WEEK_UNSPECIFIED', '2': 0},
    {'1': 'DAY_OF_WEEK_MONDAY', '2': 1},
    {'1': 'DAY_OF_WEEK_TUESDAY', '2': 2},
    {'1': 'DAY_OF_WEEK_WEDNESDAY', '2': 3},
    {'1': 'DAY_OF_WEEK_THURSDAY', '2': 4},
    {'1': 'DAY_OF_WEEK_FRIDAY', '2': 5},
    {'1': 'DAY_OF_WEEK_SATURDAY', '2': 6},
    {'1': 'DAY_OF_WEEK_SUNDAY', '2': 7},
  ],
};

/// Descriptor for `DayOfWeek`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dayOfWeekDescriptor = $convert.base64Decode(
    'CglEYXlPZldlZWsSGwoXREFZX09GX1dFRUtfVU5TUEVDSUZJRUQQABIWChJEQVlfT0ZfV0VFS1'
    '9NT05EQVkQARIXChNEQVlfT0ZfV0VFS19UVUVTREFZEAISGQoVREFZX09GX1dFRUtfV0VETkVT'
    'REFZEAMSGAoUREFZX09GX1dFRUtfVEhVUlNEQVkQBBIWChJEQVlfT0ZfV0VFS19GUklEQVkQBR'
    'IYChREQVlfT0ZfV0VFS19TQVRVUkRBWRAGEhYKEkRBWV9PRl9XRUVLX1NVTkRBWRAH');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'timezone', '3': 1, '4': 1, '5': 9, '10': 'timezone'},
    {
      '1': 'week_starts_on',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.DayOfWeek',
      '10': 'weekStartsOn'
    },
    {'1': 'rounding_minutes', '3': 3, '4': 1, '5': 5, '10': 'roundingMinutes'},
    {
      '1': 'default_project_id',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'defaultProjectId'
    },
    {
      '1': 'default_project_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'defaultProjectName'
    },
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxIaCgh0aW1lem9uZRgBIAEoCVIIdGltZXpvbmUSPgoOd2Vla19zdGFydHNfb2'
    '4YAiABKA4yGC50aW1lbG9nZ2VyLnYxLkRheU9mV2Vla1IMd2Vla1N0YXJ0c09uEikKEHJvdW5k'
    'aW5nX21pbnV0ZXMYAyABKAVSD3JvdW5kaW5nTWludXRlcxIsChJkZWZhdWx0X3Byb2plY3RfaW'
    'QYBCABKARSEGRlZmF1bHRQcm9qZWN0SWQSMAoUZGVmYXVsdF9wcm9qZWN0X25hbWUYBSABKAlS'
    'EmRlZmF1bHRQcm9qZWN0TmFtZQ==');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEjMKCHNldHRpbmdzGAEgASgLMhcudGltZWxvZ2dlci52MS'
    '5TZXR0aW5nc1IIc2V0dGluZ3M=');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {'1': 'update_mask', '3': 1, '4': 3, '5': 9, '10': 'updateMask'},
    {
      '1': 'settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSHwoLdXBkYXRlX21hc2sYASADKAlSCnVwZGF0ZU1hc2'
    'sSMwoIc2V0dGluZ3MYAiABKAsyFy50aW1lbG9nZ2VyLnYxLlNldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEjMKCHNldHRpbmdzGAEgASgLMhcudGltZWxvZ2dlci'
        '52MS5TZXR0aW5nc1IIc2V0dGluZ3M=');
