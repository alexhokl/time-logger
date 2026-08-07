// This is a generated file - do not edit.
//
// Generated from timelogger/v1/goal.proto.

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

@$core.Deprecated('Use goalDescriptor instead')
const Goal$json = {
  '1': 'Goal',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'project_name', '3': 3, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'task_id', '3': 4, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'task_name', '3': 5, '4': 1, '5': 9, '10': 'taskName'},
    {'1': 'target_hours', '3': 6, '4': 1, '5': 1, '10': 'targetHours'},
    {
      '1': 'period',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.Period',
      '10': 'period'
    },
    {
      '1': 'start_date',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'endDate',
      '17': true
    },
  ],
  '8': [
    {'1': '_end_date'},
  ],
};

/// Descriptor for `Goal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalDescriptor = $convert.base64Decode(
    'CgRHb2FsEg4KAmlkGAEgASgEUgJpZBIdCgpwcm9qZWN0X2lkGAIgASgEUglwcm9qZWN0SWQSIQ'
    'oMcHJvamVjdF9uYW1lGAMgASgJUgtwcm9qZWN0TmFtZRIXCgd0YXNrX2lkGAQgASgEUgZ0YXNr'
    'SWQSGwoJdGFza19uYW1lGAUgASgJUgh0YXNrTmFtZRIhCgx0YXJnZXRfaG91cnMYBiABKAFSC3'
    'RhcmdldEhvdXJzEi0KBnBlcmlvZBgHIAEoDjIVLnRpbWVsb2dnZXIudjEuUGVyaW9kUgZwZXJp'
    'b2QSMgoKc3RhcnRfZGF0ZRgIIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVIJc3RhcnREYXRlEj'
    'MKCGVuZF9kYXRlGAkgASgLMhMudGltZWxvZ2dlci52MS5EYXRlSABSB2VuZERhdGWIAQFCCwoJ'
    'X2VuZF9kYXRl');

@$core.Deprecated('Use createGoalRequestDescriptor instead')
const CreateGoalRequest$json = {
  '1': 'CreateGoalRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'target_hours', '3': 3, '4': 1, '5': 1, '10': 'targetHours'},
    {
      '1': 'period',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.Period',
      '10': 'period'
    },
    {
      '1': 'start_date',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'endDate',
      '17': true
    },
  ],
  '8': [
    {'1': '_end_date'},
  ],
};

/// Descriptor for `CreateGoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGoalRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVHb2FsUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgEUglwcm9qZWN0SWQSFwoHdG'
    'Fza19pZBgCIAEoBFIGdGFza0lkEiEKDHRhcmdldF9ob3VycxgDIAEoAVILdGFyZ2V0SG91cnMS'
    'LQoGcGVyaW9kGAQgASgOMhUudGltZWxvZ2dlci52MS5QZXJpb2RSBnBlcmlvZBIyCgpzdGFydF'
    '9kYXRlGAUgASgLMhMudGltZWxvZ2dlci52MS5EYXRlUglzdGFydERhdGUSMwoIZW5kX2RhdGUY'
    'BiABKAsyEy50aW1lbG9nZ2VyLnYxLkRhdGVIAFIHZW5kRGF0ZYgBAUILCglfZW5kX2RhdGU=');

@$core.Deprecated('Use createGoalResponseDescriptor instead')
const CreateGoalResponse$json = {
  '1': 'CreateGoalResponse',
  '2': [
    {
      '1': 'goal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Goal',
      '10': 'goal'
    },
  ],
};

/// Descriptor for `CreateGoalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGoalResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVHb2FsUmVzcG9uc2USJwoEZ29hbBgBIAEoCzITLnRpbWVsb2dnZXIudjEuR29hbF'
    'IEZ29hbA==');

@$core.Deprecated('Use listGoalsRequestDescriptor instead')
const ListGoalsRequest$json = {
  '1': 'ListGoalsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {
      '1': 'page',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageRequest',
      '10': 'page'
    },
  ],
};

/// Descriptor for `ListGoalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGoalsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0R29hbHNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKARSCXByb2plY3RJZBIfCgthY3'
    'RpdmVfb25seRgCIAEoCFIKYWN0aXZlT25seRIuCgRwYWdlGAMgASgLMhoudGltZWxvZ2dlci52'
    'MS5QYWdlUmVxdWVzdFIEcGFnZQ==');

@$core.Deprecated('Use listGoalsResponseDescriptor instead')
const ListGoalsResponse$json = {
  '1': 'ListGoalsResponse',
  '2': [
    {
      '1': 'goals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.Goal',
      '10': 'goals'
    },
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageResponse',
      '10': 'page'
    },
  ],
};

/// Descriptor for `ListGoalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGoalsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0R29hbHNSZXNwb25zZRIpCgVnb2FscxgBIAMoCzITLnRpbWVsb2dnZXIudjEuR29hbF'
    'IFZ29hbHMSLwoEcGFnZRgCIAEoCzIbLnRpbWVsb2dnZXIudjEuUGFnZVJlc3BvbnNlUgRwYWdl');

@$core.Deprecated('Use getGoalRequestDescriptor instead')
const GetGoalRequest$json = {
  '1': 'GetGoalRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `GetGoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalRequestDescriptor =
    $convert.base64Decode('Cg5HZXRHb2FsUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use getGoalResponseDescriptor instead')
const GetGoalResponse$json = {
  '1': 'GetGoalResponse',
  '2': [
    {
      '1': 'goal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Goal',
      '10': 'goal'
    },
  ],
};

/// Descriptor for `GetGoalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRHb2FsUmVzcG9uc2USJwoEZ29hbBgBIAEoCzITLnRpbWVsb2dnZXIudjEuR29hbFIEZ2'
    '9hbA==');

@$core.Deprecated('Use updateGoalRequestDescriptor instead')
const UpdateGoalRequest$json = {
  '1': 'UpdateGoalRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'update_mask', '3': 2, '4': 3, '5': 9, '10': 'updateMask'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'task_id', '3': 4, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'target_hours', '3': 5, '4': 1, '5': 1, '10': 'targetHours'},
    {
      '1': 'period',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.Period',
      '10': 'period'
    },
    {
      '1': 'start_date',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'endDate',
      '17': true
    },
  ],
  '8': [
    {'1': '_end_date'},
  ],
};

/// Descriptor for `UpdateGoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGoalRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVHb2FsUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSHwoLdXBkYXRlX21hc2sYAiADKA'
    'lSCnVwZGF0ZU1hc2sSHQoKcHJvamVjdF9pZBgDIAEoBFIJcHJvamVjdElkEhcKB3Rhc2tfaWQY'
    'BCABKARSBnRhc2tJZBIhCgx0YXJnZXRfaG91cnMYBSABKAFSC3RhcmdldEhvdXJzEi0KBnBlcm'
    'lvZBgGIAEoDjIVLnRpbWVsb2dnZXIudjEuUGVyaW9kUgZwZXJpb2QSMgoKc3RhcnRfZGF0ZRgH'
    'IAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVIJc3RhcnREYXRlEjMKCGVuZF9kYXRlGAggASgLMh'
    'MudGltZWxvZ2dlci52MS5EYXRlSABSB2VuZERhdGWIAQFCCwoJX2VuZF9kYXRl');

@$core.Deprecated('Use updateGoalResponseDescriptor instead')
const UpdateGoalResponse$json = {
  '1': 'UpdateGoalResponse',
  '2': [
    {
      '1': 'goal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Goal',
      '10': 'goal'
    },
  ],
};

/// Descriptor for `UpdateGoalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGoalResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVHb2FsUmVzcG9uc2USJwoEZ29hbBgBIAEoCzITLnRpbWVsb2dnZXIudjEuR29hbF'
    'IEZ29hbA==');

@$core.Deprecated('Use deleteGoalRequestDescriptor instead')
const DeleteGoalRequest$json = {
  '1': 'DeleteGoalRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `DeleteGoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteGoalRequestDescriptor =
    $convert.base64Decode('ChFEZWxldGVHb2FsUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use deleteGoalResponseDescriptor instead')
const DeleteGoalResponse$json = {
  '1': 'DeleteGoalResponse',
};

/// Descriptor for `DeleteGoalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteGoalResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVHb2FsUmVzcG9uc2U=');
