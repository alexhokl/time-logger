// This is a generated file - do not edit.
//
// Generated from timelogger/v1/report.proto.

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

@$core.Deprecated('Use groupByDescriptor instead')
const GroupBy$json = {
  '1': 'GroupBy',
  '2': [
    {'1': 'GROUP_BY_UNSPECIFIED', '2': 0},
    {'1': 'GROUP_BY_PROJECT', '2': 1},
    {'1': 'GROUP_BY_TASK', '2': 2},
    {'1': 'GROUP_BY_TAG', '2': 3},
    {'1': 'GROUP_BY_DAY', '2': 4},
  ],
};

/// Descriptor for `GroupBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List groupByDescriptor = $convert.base64Decode(
    'CgdHcm91cEJ5EhgKFEdST1VQX0JZX1VOU1BFQ0lGSUVEEAASFAoQR1JPVVBfQllfUFJPSkVDVB'
    'ABEhEKDUdST1VQX0JZX1RBU0sQAhIQCgxHUk9VUF9CWV9UQUcQAxIQCgxHUk9VUF9CWV9EQVkQ'
    'BA==');

@$core.Deprecated('Use reportRowDescriptor instead')
const ReportRow$json = {
  '1': 'ReportRow',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'total_seconds', '3': 3, '4': 1, '5': 3, '10': 'totalSeconds'},
    {'1': 'entry_count', '3': 4, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'percentage', '3': 5, '4': 1, '5': 1, '10': 'percentage'},
  ],
};

/// Descriptor for `ReportRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportRowDescriptor = $convert.base64Decode(
    'CglSZXBvcnRSb3cSDgoCaWQYASABKARSAmlkEhQKBWxhYmVsGAIgASgJUgVsYWJlbBIjCg10b3'
    'RhbF9zZWNvbmRzGAMgASgDUgx0b3RhbFNlY29uZHMSHwoLZW50cnlfY291bnQYBCABKANSCmVu'
    'dHJ5Q291bnQSHgoKcGVyY2VudGFnZRgFIAEoAVIKcGVyY2VudGFnZQ==');

@$core.Deprecated('Use periodReportDescriptor instead')
const PeriodReport$json = {
  '1': 'PeriodReport',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'to'
    },
    {
      '1': 'rows',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.ReportRow',
      '10': 'rows'
    },
    {'1': 'total_seconds', '3': 4, '4': 1, '5': 3, '10': 'totalSeconds'},
    {'1': 'entry_count', '3': 5, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'timezone', '3': 6, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `PeriodReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List periodReportDescriptor = $convert.base64Decode(
    'CgxQZXJpb2RSZXBvcnQSJwoEZnJvbRgBIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVIEZnJvbR'
    'IjCgJ0bxgCIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVICdG8SLAoEcm93cxgDIAMoCzIYLnRp'
    'bWVsb2dnZXIudjEuUmVwb3J0Um93UgRyb3dzEiMKDXRvdGFsX3NlY29uZHMYBCABKANSDHRvdG'
    'FsU2Vjb25kcxIfCgtlbnRyeV9jb3VudBgFIAEoA1IKZW50cnlDb3VudBIaCgh0aW1lem9uZRgG'
    'IAEoCVIIdGltZXpvbmU=');

@$core.Deprecated('Use reportOptionsDescriptor instead')
const ReportOptions$json = {
  '1': 'ReportOptions',
  '2': [
    {
      '1': 'group_by',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.GroupBy',
      '10': 'groupBy'
    },
    {'1': 'project_ids', '3': 2, '4': 3, '5': 4, '10': 'projectIds'},
    {'1': 'task_ids', '3': 3, '4': 3, '5': 4, '10': 'taskIds'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
  ],
};

/// Descriptor for `ReportOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportOptionsDescriptor = $convert.base64Decode(
    'Cg1SZXBvcnRPcHRpb25zEjEKCGdyb3VwX2J5GAEgASgOMhYudGltZWxvZ2dlci52MS5Hcm91cE'
    'J5Ugdncm91cEJ5Eh8KC3Byb2plY3RfaWRzGAIgAygEUgpwcm9qZWN0SWRzEhkKCHRhc2tfaWRz'
    'GAMgAygEUgd0YXNrSWRzEhIKBHRhZ3MYBCADKAlSBHRhZ3M=');

@$core.Deprecated('Use getDailyReportResponseDescriptor instead')
const GetDailyReportResponse$json = {
  '1': 'GetDailyReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PeriodReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetDailyReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReportResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXREYWlseVJlcG9ydFJlc3BvbnNlEjMKBnJlcG9ydBgBIAEoCzIbLnRpbWVsb2dnZXIudj'
        'EuUGVyaW9kUmVwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use getWeeklyReportResponseDescriptor instead')
const GetWeeklyReportResponse$json = {
  '1': 'GetWeeklyReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PeriodReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetWeeklyReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWeeklyReportResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRXZWVrbHlSZXBvcnRSZXNwb25zZRIzCgZyZXBvcnQYASABKAsyGy50aW1lbG9nZ2VyLn'
        'YxLlBlcmlvZFJlcG9ydFIGcmVwb3J0');

@$core.Deprecated('Use getMonthlyReportResponseDescriptor instead')
const GetMonthlyReportResponse$json = {
  '1': 'GetMonthlyReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PeriodReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetMonthlyReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMonthlyReportResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRNb250aGx5UmVwb3J0UmVzcG9uc2USMwoGcmVwb3J0GAEgASgLMhsudGltZWxvZ2dlci'
        '52MS5QZXJpb2RSZXBvcnRSBnJlcG9ydA==');

@$core.Deprecated('Use getRangeReportResponseDescriptor instead')
const GetRangeReportResponse$json = {
  '1': 'GetRangeReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PeriodReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetRangeReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRangeReportResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRSYW5nZVJlcG9ydFJlc3BvbnNlEjMKBnJlcG9ydBgBIAEoCzIbLnRpbWVsb2dnZXIudj'
        'EuUGVyaW9kUmVwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use getDailyReportRequestDescriptor instead')
const GetDailyReportRequest$json = {
  '1': 'GetDailyReportRequest',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'date',
      '17': true
    },
    {
      '1': 'options',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.ReportOptions',
      '10': 'options'
    },
  ],
  '8': [
    {'1': '_date'},
  ],
};

/// Descriptor for `GetDailyReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReportRequestDescriptor = $convert.base64Decode(
    'ChVHZXREYWlseVJlcG9ydFJlcXVlc3QSLAoEZGF0ZRgBIAEoCzITLnRpbWVsb2dnZXIudjEuRG'
    'F0ZUgAUgRkYXRliAEBEjYKB29wdGlvbnMYAiABKAsyHC50aW1lbG9nZ2VyLnYxLlJlcG9ydE9w'
    'dGlvbnNSB29wdGlvbnNCBwoFX2RhdGU=');

@$core.Deprecated('Use getWeeklyReportRequestDescriptor instead')
const GetWeeklyReportRequest$json = {
  '1': 'GetWeeklyReportRequest',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'date',
      '17': true
    },
    {
      '1': 'options',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.ReportOptions',
      '10': 'options'
    },
  ],
  '8': [
    {'1': '_date'},
  ],
};

/// Descriptor for `GetWeeklyReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWeeklyReportRequestDescriptor = $convert.base64Decode(
    'ChZHZXRXZWVrbHlSZXBvcnRSZXF1ZXN0EiwKBGRhdGUYASABKAsyEy50aW1lbG9nZ2VyLnYxLk'
    'RhdGVIAFIEZGF0ZYgBARI2CgdvcHRpb25zGAIgASgLMhwudGltZWxvZ2dlci52MS5SZXBvcnRP'
    'cHRpb25zUgdvcHRpb25zQgcKBV9kYXRl');

@$core.Deprecated('Use getMonthlyReportRequestDescriptor instead')
const GetMonthlyReportRequest$json = {
  '1': 'GetMonthlyReportRequest',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'date',
      '17': true
    },
    {
      '1': 'options',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.ReportOptions',
      '10': 'options'
    },
  ],
  '8': [
    {'1': '_date'},
  ],
};

/// Descriptor for `GetMonthlyReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMonthlyReportRequestDescriptor = $convert.base64Decode(
    'ChdHZXRNb250aGx5UmVwb3J0UmVxdWVzdBIsCgRkYXRlGAEgASgLMhMudGltZWxvZ2dlci52MS'
    '5EYXRlSABSBGRhdGWIAQESNgoHb3B0aW9ucxgCIAEoCzIcLnRpbWVsb2dnZXIudjEuUmVwb3J0'
    'T3B0aW9uc1IHb3B0aW9uc0IHCgVfZGF0ZQ==');

@$core.Deprecated('Use getRangeReportRequestDescriptor instead')
const GetRangeReportRequest$json = {
  '1': 'GetRangeReportRequest',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'to'
    },
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.ReportOptions',
      '10': 'options'
    },
  ],
};

/// Descriptor for `GetRangeReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRangeReportRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSYW5nZVJlcG9ydFJlcXVlc3QSJwoEZnJvbRgBIAEoCzITLnRpbWVsb2dnZXIudjEuRG'
    'F0ZVIEZnJvbRIjCgJ0bxgCIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVICdG8SNgoHb3B0aW9u'
    'cxgDIAEoCzIcLnRpbWVsb2dnZXIudjEuUmVwb3J0T3B0aW9uc1IHb3B0aW9ucw==');

@$core.Deprecated('Use getGoalReportRequestDescriptor instead')
const GetGoalReportRequest$json = {
  '1': 'GetGoalReportRequest',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'date',
      '17': true
    },
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
  ],
  '8': [
    {'1': '_date'},
  ],
};

/// Descriptor for `GetGoalReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalReportRequestDescriptor = $convert.base64Decode(
    'ChRHZXRHb2FsUmVwb3J0UmVxdWVzdBIsCgRkYXRlGAEgASgLMhMudGltZWxvZ2dlci52MS5EYX'
    'RlSABSBGRhdGWIAQESHQoKcHJvamVjdF9pZBgCIAEoBFIJcHJvamVjdElkQgcKBV9kYXRl');

@$core.Deprecated('Use goalProgressDescriptor instead')
const GoalProgress$json = {
  '1': 'GoalProgress',
  '2': [
    {'1': 'goal_id', '3': 1, '4': 1, '5': 4, '10': 'goalId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'project_name', '3': 3, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'task_id', '3': 4, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'task_name', '3': 5, '4': 1, '5': 9, '10': 'taskName'},
    {
      '1': 'period',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.Period',
      '10': 'period'
    },
    {
      '1': 'period_start',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'periodEnd'
    },
    {'1': 'target_seconds', '3': 9, '4': 1, '5': 3, '10': 'targetSeconds'},
    {'1': 'actual_seconds', '3': 10, '4': 1, '5': 3, '10': 'actualSeconds'},
    {'1': 'percentage', '3': 11, '4': 1, '5': 1, '10': 'percentage'},
    {
      '1': 'remaining_seconds',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'remainingSeconds'
    },
    {'1': 'met', '3': 13, '4': 1, '5': 8, '10': 'met'},
  ],
};

/// Descriptor for `GoalProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalProgressDescriptor = $convert.base64Decode(
    'CgxHb2FsUHJvZ3Jlc3MSFwoHZ29hbF9pZBgBIAEoBFIGZ29hbElkEh0KCnByb2plY3RfaWQYAi'
    'ABKARSCXByb2plY3RJZBIhCgxwcm9qZWN0X25hbWUYAyABKAlSC3Byb2plY3ROYW1lEhcKB3Rh'
    'c2tfaWQYBCABKARSBnRhc2tJZBIbCgl0YXNrX25hbWUYBSABKAlSCHRhc2tOYW1lEi0KBnBlcm'
    'lvZBgGIAEoDjIVLnRpbWVsb2dnZXIudjEuUGVyaW9kUgZwZXJpb2QSNgoMcGVyaW9kX3N0YXJ0'
    'GAcgASgLMhMudGltZWxvZ2dlci52MS5EYXRlUgtwZXJpb2RTdGFydBIyCgpwZXJpb2RfZW5kGA'
    'ggASgLMhMudGltZWxvZ2dlci52MS5EYXRlUglwZXJpb2RFbmQSJQoOdGFyZ2V0X3NlY29uZHMY'
    'CSABKANSDXRhcmdldFNlY29uZHMSJQoOYWN0dWFsX3NlY29uZHMYCiABKANSDWFjdHVhbFNlY2'
    '9uZHMSHgoKcGVyY2VudGFnZRgLIAEoAVIKcGVyY2VudGFnZRIrChFyZW1haW5pbmdfc2Vjb25k'
    'cxgMIAEoA1IQcmVtYWluaW5nU2Vjb25kcxIQCgNtZXQYDSABKAhSA21ldA==');

@$core.Deprecated('Use getGoalReportResponseDescriptor instead')
const GetGoalReportResponse$json = {
  '1': 'GetGoalReportResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.GoalProgress',
      '10': 'progress'
    },
    {'1': 'timezone', '3': 2, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `GetGoalReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalReportResponseDescriptor = $convert.base64Decode(
    'ChVHZXRHb2FsUmVwb3J0UmVzcG9uc2USNwoIcHJvZ3Jlc3MYASADKAsyGy50aW1lbG9nZ2VyLn'
    'YxLkdvYWxQcm9ncmVzc1IIcHJvZ3Jlc3MSGgoIdGltZXpvbmUYAiABKAlSCHRpbWV6b25l');

@$core.Deprecated('Use getActivityHeatmapRequestDescriptor instead')
const GetActivityHeatmapRequest$json = {
  '1': 'GetActivityHeatmapRequest',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'to'
    },
    {'1': 'project_ids', '3': 3, '4': 3, '5': 4, '10': 'projectIds'},
  ],
};

/// Descriptor for `GetActivityHeatmapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActivityHeatmapRequestDescriptor = $convert.base64Decode(
    'ChlHZXRBY3Rpdml0eUhlYXRtYXBSZXF1ZXN0EicKBGZyb20YASABKAsyEy50aW1lbG9nZ2VyLn'
    'YxLkRhdGVSBGZyb20SIwoCdG8YAiABKAsyEy50aW1lbG9nZ2VyLnYxLkRhdGVSAnRvEh8KC3By'
    'b2plY3RfaWRzGAMgAygEUgpwcm9qZWN0SWRz');

@$core.Deprecated('Use heatmapDayDescriptor instead')
const HeatmapDay$json = {
  '1': 'HeatmapDay',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'date'
    },
    {'1': 'total_seconds', '3': 2, '4': 1, '5': 3, '10': 'totalSeconds'},
    {'1': 'entry_count', '3': 3, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'level', '3': 4, '4': 1, '5': 5, '10': 'level'},
  ],
};

/// Descriptor for `HeatmapDay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heatmapDayDescriptor = $convert.base64Decode(
    'CgpIZWF0bWFwRGF5EicKBGRhdGUYASABKAsyEy50aW1lbG9nZ2VyLnYxLkRhdGVSBGRhdGUSIw'
    'oNdG90YWxfc2Vjb25kcxgCIAEoA1IMdG90YWxTZWNvbmRzEh8KC2VudHJ5X2NvdW50GAMgASgD'
    'UgplbnRyeUNvdW50EhQKBWxldmVsGAQgASgFUgVsZXZlbA==');

@$core.Deprecated('Use getActivityHeatmapResponseDescriptor instead')
const GetActivityHeatmapResponse$json = {
  '1': 'GetActivityHeatmapResponse',
  '2': [
    {
      '1': 'days',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.HeatmapDay',
      '10': 'days'
    },
    {'1': 'max_seconds', '3': 2, '4': 1, '5': 3, '10': 'maxSeconds'},
    {'1': 'total_seconds', '3': 3, '4': 1, '5': 3, '10': 'totalSeconds'},
    {'1': 'timezone', '3': 4, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `GetActivityHeatmapResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActivityHeatmapResponseDescriptor = $convert.base64Decode(
    'ChpHZXRBY3Rpdml0eUhlYXRtYXBSZXNwb25zZRItCgRkYXlzGAEgAygLMhkudGltZWxvZ2dlci'
    '52MS5IZWF0bWFwRGF5UgRkYXlzEh8KC21heF9zZWNvbmRzGAIgASgDUgptYXhTZWNvbmRzEiMK'
    'DXRvdGFsX3NlY29uZHMYAyABKANSDHRvdGFsU2Vjb25kcxIaCgh0aW1lem9uZRgEIAEoCVIIdG'
    'ltZXpvbmU=');

@$core.Deprecated('Use getStreaksRequestDescriptor instead')
const GetStreaksRequest$json = {
  '1': 'GetStreaksRequest',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 0,
      '10': 'from',
      '17': true
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 1,
      '10': 'to',
      '17': true
    },
    {'1': 'minimum_seconds', '3': 3, '4': 1, '5': 3, '10': 'minimumSeconds'},
  ],
  '8': [
    {'1': '_from'},
    {'1': '_to'},
  ],
};

/// Descriptor for `GetStreaksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreaksRequestDescriptor = $convert.base64Decode(
    'ChFHZXRTdHJlYWtzUmVxdWVzdBIsCgRmcm9tGAEgASgLMhMudGltZWxvZ2dlci52MS5EYXRlSA'
    'BSBGZyb22IAQESKAoCdG8YAiABKAsyEy50aW1lbG9nZ2VyLnYxLkRhdGVIAVICdG+IAQESJwoP'
    'bWluaW11bV9zZWNvbmRzGAMgASgDUg5taW5pbXVtU2Vjb25kc0IHCgVfZnJvbUIFCgNfdG8=');

@$core.Deprecated('Use streakDescriptor instead')
const Streak$json = {
  '1': 'Streak',
  '2': [
    {
      '1': 'start_date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'endDate'
    },
    {'1': 'days', '3': 3, '4': 1, '5': 5, '10': 'days'},
    {'1': 'total_seconds', '3': 4, '4': 1, '5': 3, '10': 'totalSeconds'},
  ],
};

/// Descriptor for `Streak`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streakDescriptor = $convert.base64Decode(
    'CgZTdHJlYWsSMgoKc3RhcnRfZGF0ZRgBIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVIJc3Rhcn'
    'REYXRlEi4KCGVuZF9kYXRlGAIgASgLMhMudGltZWxvZ2dlci52MS5EYXRlUgdlbmREYXRlEhIK'
    'BGRheXMYAyABKAVSBGRheXMSIwoNdG90YWxfc2Vjb25kcxgEIAEoA1IMdG90YWxTZWNvbmRz');

@$core.Deprecated('Use getStreaksResponseDescriptor instead')
const GetStreaksResponse$json = {
  '1': 'GetStreaksResponse',
  '2': [
    {
      '1': 'current',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Streak',
      '9': 0,
      '10': 'current',
      '17': true
    },
    {
      '1': 'longest',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Streak',
      '9': 1,
      '10': 'longest',
      '17': true
    },
    {
      '1': 'streaks',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.Streak',
      '10': 'streaks'
    },
    {'1': 'active_days', '3': 4, '4': 1, '5': 5, '10': 'activeDays'},
    {'1': 'timezone', '3': 5, '4': 1, '5': 9, '10': 'timezone'},
  ],
  '8': [
    {'1': '_current'},
    {'1': '_longest'},
  ],
};

/// Descriptor for `GetStreaksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreaksResponseDescriptor = $convert.base64Decode(
    'ChJHZXRTdHJlYWtzUmVzcG9uc2USNAoHY3VycmVudBgBIAEoCzIVLnRpbWVsb2dnZXIudjEuU3'
    'RyZWFrSABSB2N1cnJlbnSIAQESNAoHbG9uZ2VzdBgCIAEoCzIVLnRpbWVsb2dnZXIudjEuU3Ry'
    'ZWFrSAFSB2xvbmdlc3SIAQESLwoHc3RyZWFrcxgDIAMoCzIVLnRpbWVsb2dnZXIudjEuU3RyZW'
    'FrUgdzdHJlYWtzEh8KC2FjdGl2ZV9kYXlzGAQgASgFUgphY3RpdmVEYXlzEhoKCHRpbWV6b25l'
    'GAUgASgJUgh0aW1lem9uZUIKCghfY3VycmVudEIKCghfbG9uZ2VzdA==');
