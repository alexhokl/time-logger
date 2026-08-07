// This is a generated file - do not edit.
//
// Generated from timelogger/v1/timer.proto.

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

@$core.Deprecated('Use startTimerRequestDescriptor instead')
const StartTimerRequest$json = {
  '1': 'StartTimerRequest',
  '2': [
    {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'task_id', '3': 3, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'start_time',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'startTime',
      '17': true
    },
  ],
  '8': [
    {'1': '_start_time'},
  ],
};

/// Descriptor for `StartTimerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTimerRequestDescriptor = $convert.base64Decode(
    'ChFTdGFydFRpbWVyUmVxdWVzdBIgCgtkZXNjcmlwdGlvbhgBIAEoCVILZGVzY3JpcHRpb24SHQ'
    'oKcHJvamVjdF9pZBgCIAEoBFIJcHJvamVjdElkEhcKB3Rhc2tfaWQYAyABKARSBnRhc2tJZBIS'
    'CgR0YWdzGAQgAygJUgR0YWdzEj4KCnN0YXJ0X3RpbWUYBSABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wSABSCXN0YXJ0VGltZYgBAUINCgtfc3RhcnRfdGltZQ==');

@$core.Deprecated('Use startTimerResponseDescriptor instead')
const StartTimerResponse$json = {
  '1': 'StartTimerResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `StartTimerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTimerResponseDescriptor = $convert.base64Decode(
    'ChJTdGFydFRpbWVyUmVzcG9uc2USLgoFZW50cnkYASABKAsyGC50aW1lbG9nZ2VyLnYxLlRpbW'
    'VFbnRyeVIFZW50cnk=');

@$core.Deprecated('Use stopTimerRequestDescriptor instead')
const StopTimerRequest$json = {
  '1': 'StopTimerRequest',
  '2': [
    {
      '1': 'end_time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'endTime',
      '17': true
    },
    {
      '1': 'description',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'description',
      '17': true
    },
  ],
  '8': [
    {'1': '_end_time'},
    {'1': '_description'},
  ],
};

/// Descriptor for `StopTimerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopTimerRequestDescriptor = $convert.base64Decode(
    'ChBTdG9wVGltZXJSZXF1ZXN0EjoKCGVuZF90aW1lGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcEgAUgdlbmRUaW1liAEBEiUKC2Rlc2NyaXB0aW9uGAIgASgJSAFSC2Rlc2NyaXB0'
    'aW9uiAEBQgsKCV9lbmRfdGltZUIOCgxfZGVzY3JpcHRpb24=');

@$core.Deprecated('Use stopTimerResponseDescriptor instead')
const StopTimerResponse$json = {
  '1': 'StopTimerResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `StopTimerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopTimerResponseDescriptor = $convert.base64Decode(
    'ChFTdG9wVGltZXJSZXNwb25zZRIuCgVlbnRyeRgBIAEoCzIYLnRpbWVsb2dnZXIudjEuVGltZU'
    'VudHJ5UgVlbnRyeQ==');

@$core.Deprecated('Use getRunningTimerRequestDescriptor instead')
const GetRunningTimerRequest$json = {
  '1': 'GetRunningTimerRequest',
};

/// Descriptor for `GetRunningTimerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunningTimerRequestDescriptor =
    $convert.base64Decode('ChZHZXRSdW5uaW5nVGltZXJSZXF1ZXN0');

@$core.Deprecated('Use getRunningTimerResponseDescriptor instead')
const GetRunningTimerResponse$json = {
  '1': 'GetRunningTimerResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '9': 0,
      '10': 'entry',
      '17': true
    },
  ],
  '8': [
    {'1': '_entry'},
  ],
};

/// Descriptor for `GetRunningTimerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunningTimerResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRSdW5uaW5nVGltZXJSZXNwb25zZRIzCgVlbnRyeRgBIAEoCzIYLnRpbWVsb2dnZXIudj'
        'EuVGltZUVudHJ5SABSBWVudHJ5iAEBQggKBl9lbnRyeQ==');

@$core.Deprecated('Use cancelRunningTimerRequestDescriptor instead')
const CancelRunningTimerRequest$json = {
  '1': 'CancelRunningTimerRequest',
};

/// Descriptor for `CancelRunningTimerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRunningTimerRequestDescriptor =
    $convert.base64Decode('ChlDYW5jZWxSdW5uaW5nVGltZXJSZXF1ZXN0');

@$core.Deprecated('Use cancelRunningTimerResponseDescriptor instead')
const CancelRunningTimerResponse$json = {
  '1': 'CancelRunningTimerResponse',
};

/// Descriptor for `CancelRunningTimerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRunningTimerResponseDescriptor =
    $convert.base64Decode('ChpDYW5jZWxSdW5uaW5nVGltZXJSZXNwb25zZQ==');
