// This is a generated file - do not edit.
//
// Generated from timelogger/v1/entry.proto.

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

@$core.Deprecated('Use timeEntryDescriptor instead')
const TimeEntry$json = {
  '1': 'TimeEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'project_name', '3': 4, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'task_id', '3': 5, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'task_name', '3': 6, '4': 1, '5': 9, '10': 'taskName'},
    {'1': 'tags', '3': 7, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'start_time',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTime'
    },
    {
      '1': 'end_time',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'endTime',
      '17': true
    },
    {'1': 'duration_seconds', '3': 10, '4': 1, '5': 3, '10': 'durationSeconds'},
    {'1': 'running', '3': 11, '4': 1, '5': 8, '10': 'running'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
  '8': [
    {'1': '_end_time'},
  ],
};

/// Descriptor for `TimeEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeEntryDescriptor = $convert.base64Decode(
    'CglUaW1lRW50cnkSDgoCaWQYASABKARSAmlkEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZXNjcm'
    'lwdGlvbhIdCgpwcm9qZWN0X2lkGAMgASgEUglwcm9qZWN0SWQSIQoMcHJvamVjdF9uYW1lGAQg'
    'ASgJUgtwcm9qZWN0TmFtZRIXCgd0YXNrX2lkGAUgASgEUgZ0YXNrSWQSGwoJdGFza19uYW1lGA'
    'YgASgJUgh0YXNrTmFtZRISCgR0YWdzGAcgAygJUgR0YWdzEjkKCnN0YXJ0X3RpbWUYCCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydFRpbWUSOgoIZW5kX3RpbWUYCSABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSABSB2VuZFRpbWWIAQESKQoQZHVyYXRpb25f'
    'c2Vjb25kcxgKIAEoA1IPZHVyYXRpb25TZWNvbmRzEhgKB3J1bm5pbmcYCyABKAhSB3J1bm5pbm'
    'cSOQoKY3JlYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0'
    'ZWRBdBI5Cgp1cGRhdGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdX'
    'BkYXRlZEF0QgsKCV9lbmRfdGltZQ==');

@$core.Deprecated('Use timeSpecDescriptor instead')
const TimeSpec$json = {
  '1': 'TimeSpec',
  '2': [
    {
      '1': 'start_time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'startTime',
      '17': true
    },
    {
      '1': 'end_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 1,
      '10': 'endTime',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'date',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '9': 3,
      '10': 'date',
      '17': true
    },
  ],
  '8': [
    {'1': '_start_time'},
    {'1': '_end_time'},
    {'1': '_duration_seconds'},
    {'1': '_date'},
  ],
};

/// Descriptor for `TimeSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSpecDescriptor = $convert.base64Decode(
    'CghUaW1lU3BlYxI+CgpzdGFydF90aW1lGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcEgAUglzdGFydFRpbWWIAQESOgoIZW5kX3RpbWUYAiABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wSAFSB2VuZFRpbWWIAQESLgoQZHVyYXRpb25fc2Vjb25kcxgDIAEoA0gCUg9kdX'
    'JhdGlvblNlY29uZHOIAQESLAoEZGF0ZRgEIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZUgDUgRk'
    'YXRliAEBQg0KC19zdGFydF90aW1lQgsKCV9lbmRfdGltZUITChFfZHVyYXRpb25fc2Vjb25kc0'
    'IHCgVfZGF0ZQ==');

@$core.Deprecated('Use createEntryRequestDescriptor instead')
const CreateEntryRequest$json = {
  '1': 'CreateEntryRequest',
  '2': [
    {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'task_id', '3': 3, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'time',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.TimeSpec',
      '10': 'time'
    },
  ],
};

/// Descriptor for `CreateEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEntryRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVFbnRyeVJlcXVlc3QSIAoLZGVzY3JpcHRpb24YASABKAlSC2Rlc2NyaXB0aW9uEh'
    '0KCnByb2plY3RfaWQYAiABKARSCXByb2plY3RJZBIXCgd0YXNrX2lkGAMgASgEUgZ0YXNrSWQS'
    'EgoEdGFncxgEIAMoCVIEdGFncxIrCgR0aW1lGAUgASgLMhcudGltZWxvZ2dlci52MS5UaW1lU3'
    'BlY1IEdGltZQ==');

@$core.Deprecated('Use createEntryResponseDescriptor instead')
const CreateEntryResponse$json = {
  '1': 'CreateEntryResponse',
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

/// Descriptor for `CreateEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEntryResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVFbnRyeVJlc3BvbnNlEi4KBWVudHJ5GAEgASgLMhgudGltZWxvZ2dlci52MS5UaW'
    '1lRW50cnlSBWVudHJ5');

@$core.Deprecated('Use createEntriesRequestDescriptor instead')
const CreateEntriesRequest$json = {
  '1': 'CreateEntriesRequest',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.CreateEntryRequest',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `CreateEntriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEntriesRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVFbnRyaWVzUmVxdWVzdBI7CgdlbnRyaWVzGAEgAygLMiEudGltZWxvZ2dlci52MS'
    '5DcmVhdGVFbnRyeVJlcXVlc3RSB2VudHJpZXM=');

@$core.Deprecated('Use createEntriesResponseDescriptor instead')
const CreateEntriesResponse$json = {
  '1': 'CreateEntriesResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `CreateEntriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createEntriesResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVFbnRyaWVzUmVzcG9uc2USMgoHZW50cmllcxgBIAMoCzIYLnRpbWVsb2dnZXIudj'
    'EuVGltZUVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use entryFilterDescriptor instead')
const EntryFilter$json = {
  '1': 'EntryFilter',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'from',
      '17': true
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 1,
      '10': 'to',
      '17': true
    },
    {'1': 'project_ids', '3': 3, '4': 3, '5': 4, '10': 'projectIds'},
    {'1': 'task_ids', '3': 4, '4': 3, '5': 4, '10': 'taskIds'},
    {'1': 'tags', '3': 5, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'search', '3': 6, '4': 1, '5': 9, '10': 'search'},
    {
      '1': 'running',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'running',
      '17': true
    },
  ],
  '8': [
    {'1': '_from'},
    {'1': '_to'},
    {'1': '_running'},
  ],
};

/// Descriptor for `EntryFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entryFilterDescriptor = $convert.base64Decode(
    'CgtFbnRyeUZpbHRlchIzCgRmcm9tGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcE'
    'gAUgRmcm9tiAEBEi8KAnRvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgBUgJ0'
    'b4gBARIfCgtwcm9qZWN0X2lkcxgDIAMoBFIKcHJvamVjdElkcxIZCgh0YXNrX2lkcxgEIAMoBF'
    'IHdGFza0lkcxISCgR0YWdzGAUgAygJUgR0YWdzEhYKBnNlYXJjaBgGIAEoCVIGc2VhcmNoEh0K'
    'B3J1bm5pbmcYByABKAhIAlIHcnVubmluZ4gBAUIHCgVfZnJvbUIFCgNfdG9CCgoIX3J1bm5pbm'
    'c=');

@$core.Deprecated('Use listEntriesRequestDescriptor instead')
const ListEntriesRequest$json = {
  '1': 'ListEntriesRequest',
  '2': [
    {
      '1': 'filter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.EntryFilter',
      '10': 'filter'
    },
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageRequest',
      '10': 'page'
    },
    {
      '1': 'order',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.timelogger.v1.SortOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `ListEntriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEntriesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0RW50cmllc1JlcXVlc3QSMgoGZmlsdGVyGAEgASgLMhoudGltZWxvZ2dlci52MS5Fbn'
    'RyeUZpbHRlclIGZmlsdGVyEi4KBHBhZ2UYAiABKAsyGi50aW1lbG9nZ2VyLnYxLlBhZ2VSZXF1'
    'ZXN0UgRwYWdlEi4KBW9yZGVyGAMgASgOMhgudGltZWxvZ2dlci52MS5Tb3J0T3JkZXJSBW9yZG'
    'Vy');

@$core.Deprecated('Use listEntriesResponseDescriptor instead')
const ListEntriesResponse$json = {
  '1': 'ListEntriesResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '10': 'entries'
    },
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageResponse',
      '10': 'page'
    },
    {'1': 'total_seconds', '3': 3, '4': 1, '5': 3, '10': 'totalSeconds'},
  ],
};

/// Descriptor for `ListEntriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEntriesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RW50cmllc1Jlc3BvbnNlEjIKB2VudHJpZXMYASADKAsyGC50aW1lbG9nZ2VyLnYxLl'
    'RpbWVFbnRyeVIHZW50cmllcxIvCgRwYWdlGAIgASgLMhsudGltZWxvZ2dlci52MS5QYWdlUmVz'
    'cG9uc2VSBHBhZ2USIwoNdG90YWxfc2Vjb25kcxgDIAEoA1IMdG90YWxTZWNvbmRz');

@$core.Deprecated('Use getEntryRequestDescriptor instead')
const GetEntryRequest$json = {
  '1': 'GetEntryRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `GetEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEntryRequestDescriptor =
    $convert.base64Decode('Cg9HZXRFbnRyeVJlcXVlc3QSDgoCaWQYASABKARSAmlk');

@$core.Deprecated('Use getEntryResponseDescriptor instead')
const GetEntryResponse$json = {
  '1': 'GetEntryResponse',
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

/// Descriptor for `GetEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEntryResponseDescriptor = $convert.base64Decode(
    'ChBHZXRFbnRyeVJlc3BvbnNlEi4KBWVudHJ5GAEgASgLMhgudGltZWxvZ2dlci52MS5UaW1lRW'
    '50cnlSBWVudHJ5');

@$core.Deprecated('Use updateEntryRequestDescriptor instead')
const UpdateEntryRequest$json = {
  '1': 'UpdateEntryRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'update_mask', '3': 2, '4': 3, '5': 9, '10': 'updateMask'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'project_id', '3': 4, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'task_id', '3': 5, '4': 1, '5': 4, '10': 'taskId'},
    {'1': 'tags', '3': 6, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'time',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.TimeSpec',
      '10': 'time'
    },
  ],
};

/// Descriptor for `UpdateEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateEntryRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVFbnRyeVJlcXVlc3QSDgoCaWQYASABKARSAmlkEh8KC3VwZGF0ZV9tYXNrGAIgAy'
    'gJUgp1cGRhdGVNYXNrEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIdCgpwcm9q'
    'ZWN0X2lkGAQgASgEUglwcm9qZWN0SWQSFwoHdGFza19pZBgFIAEoBFIGdGFza0lkEhIKBHRhZ3'
    'MYBiADKAlSBHRhZ3MSKwoEdGltZRgHIAEoCzIXLnRpbWVsb2dnZXIudjEuVGltZVNwZWNSBHRp'
    'bWU=');

@$core.Deprecated('Use updateEntryResponseDescriptor instead')
const UpdateEntryResponse$json = {
  '1': 'UpdateEntryResponse',
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

/// Descriptor for `UpdateEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateEntryResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVFbnRyeVJlc3BvbnNlEi4KBWVudHJ5GAEgASgLMhgudGltZWxvZ2dlci52MS5UaW'
    '1lRW50cnlSBWVudHJ5');

@$core.Deprecated('Use deleteEntryRequestDescriptor instead')
const DeleteEntryRequest$json = {
  '1': 'DeleteEntryRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `DeleteEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEntryRequestDescriptor =
    $convert.base64Decode('ChJEZWxldGVFbnRyeVJlcXVlc3QSDgoCaWQYASABKARSAmlk');

@$core.Deprecated('Use copyEntriesRequestDescriptor instead')
const CopyEntriesRequest$json = {
  '1': 'CopyEntriesRequest',
  '2': [
    {'1': 'entry_ids', '3': 1, '4': 3, '5': 4, '10': 'entryIds'},
    {
      '1': 'target_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Date',
      '10': 'targetDate'
    },
  ],
};

/// Descriptor for `CopyEntriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyEntriesRequestDescriptor = $convert.base64Decode(
    'ChJDb3B5RW50cmllc1JlcXVlc3QSGwoJZW50cnlfaWRzGAEgAygEUghlbnRyeUlkcxI0Cgt0YX'
    'JnZXRfZGF0ZRgCIAEoCzITLnRpbWVsb2dnZXIudjEuRGF0ZVIKdGFyZ2V0RGF0ZQ==');

@$core.Deprecated('Use copyEntriesResponseDescriptor instead')
const CopyEntriesResponse$json = {
  '1': 'CopyEntriesResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.TimeEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `CopyEntriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyEntriesResponseDescriptor = $convert.base64Decode(
    'ChNDb3B5RW50cmllc1Jlc3BvbnNlEjIKB2VudHJpZXMYASADKAsyGC50aW1lbG9nZ2VyLnYxLl'
    'RpbWVFbnRyeVIHZW50cmllcw==');

@$core.Deprecated('Use deleteEntryResponseDescriptor instead')
const DeleteEntryResponse$json = {
  '1': 'DeleteEntryResponse',
};

/// Descriptor for `DeleteEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEntryResponseDescriptor =
    $convert.base64Decode('ChNEZWxldGVFbnRyeVJlc3BvbnNl');
