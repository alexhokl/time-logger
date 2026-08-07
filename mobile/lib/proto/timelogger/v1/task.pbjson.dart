// This is a generated file - do not edit.
//
// Generated from timelogger/v1/task.proto.

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

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'project_name', '3': 4, '4': 1, '5': 9, '10': 'projectName'},
    {'1': 'archived', '3': 5, '4': 1, '5': 8, '10': 'archived'},
    {'1': 'entry_count', '3': 6, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'total_seconds', '3': 7, '4': 1, '5': 3, '10': 'totalSeconds'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh0KCnByb2plY3RfaW'
    'QYAyABKARSCXByb2plY3RJZBIhCgxwcm9qZWN0X25hbWUYBCABKAlSC3Byb2plY3ROYW1lEhoK'
    'CGFyY2hpdmVkGAUgASgIUghhcmNoaXZlZBIfCgtlbnRyeV9jb3VudBgGIAEoA1IKZW50cnlDb3'
    'VudBIjCg10b3RhbF9zZWNvbmRzGAcgASgDUgx0b3RhbFNlY29uZHM=');

@$core.Deprecated('Use createTaskRequestDescriptor instead')
const CreateTaskRequest$json = {
  '1': 'CreateTaskRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
  ],
};

/// Descriptor for `CreateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVUYXNrUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEh0KCnByb2plY3RfaWQYAi'
    'ABKARSCXByb2plY3RJZA==');

@$core.Deprecated('Use createTaskResponseDescriptor instead')
const CreateTaskResponse$json = {
  '1': 'CreateTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CreateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVUYXNrUmVzcG9uc2USJwoEdGFzaxgBIAEoCzITLnRpbWVsb2dnZXIudjEuVGFza1'
    'IEdGFzaw==');

@$core.Deprecated('Use listTasksRequestDescriptor instead')
const ListTasksRequest$json = {
  '1': 'ListTasksRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 4, '10': 'projectId'},
    {'1': 'include_archived', '3': 2, '4': 1, '5': 8, '10': 'includeArchived'},
    {'1': 'include_stats', '3': 3, '4': 1, '5': 8, '10': 'includeStats'},
    {
      '1': 'page',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageRequest',
      '10': 'page'
    },
  ],
};

/// Descriptor for `ListTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFza3NSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKARSCXByb2plY3RJZBIpChBpbm'
    'NsdWRlX2FyY2hpdmVkGAIgASgIUg9pbmNsdWRlQXJjaGl2ZWQSIwoNaW5jbHVkZV9zdGF0cxgD'
    'IAEoCFIMaW5jbHVkZVN0YXRzEi4KBHBhZ2UYBCABKAsyGi50aW1lbG9nZ2VyLnYxLlBhZ2VSZX'
    'F1ZXN0UgRwYWdl');

@$core.Deprecated('Use listTasksResponseDescriptor instead')
const ListTasksResponse$json = {
  '1': 'ListTasksResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.Task',
      '10': 'tasks'
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

/// Descriptor for `ListTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VGFza3NSZXNwb25zZRIpCgV0YXNrcxgBIAMoCzITLnRpbWVsb2dnZXIudjEuVGFza1'
    'IFdGFza3MSLwoEcGFnZRgCIAEoCzIbLnRpbWVsb2dnZXIudjEuUGFnZVJlc3BvbnNlUgRwYWdl');

@$core.Deprecated('Use getTaskRequestDescriptor instead')
const GetTaskRequest$json = {
  '1': 'GetTaskRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'include_stats', '3': 2, '4': 1, '5': 8, '10': 'includeStats'},
  ],
};

/// Descriptor for `GetTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTaskRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSIwoNaW5jbHVkZV9zdGF0cxgCIAEoCF'
    'IMaW5jbHVkZVN0YXRz');

@$core.Deprecated('Use getTaskResponseDescriptor instead')
const GetTaskResponse$json = {
  '1': 'GetTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `GetTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTaskResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRUYXNrUmVzcG9uc2USJwoEdGFzaxgBIAEoCzITLnRpbWVsb2dnZXIudjEuVGFza1IEdG'
    'Fzaw==');

@$core.Deprecated('Use updateTaskRequestDescriptor instead')
const UpdateTaskRequest$json = {
  '1': 'UpdateTaskRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'update_mask', '3': 2, '4': 3, '5': 9, '10': 'updateMask'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'project_id', '3': 4, '4': 1, '5': 4, '10': 'projectId'},
  ],
};

/// Descriptor for `UpdateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSHwoLdXBkYXRlX21hc2sYAiADKA'
    'lSCnVwZGF0ZU1hc2sSEgoEbmFtZRgDIAEoCVIEbmFtZRIdCgpwcm9qZWN0X2lkGAQgASgEUglw'
    'cm9qZWN0SWQ=');

@$core.Deprecated('Use updateTaskResponseDescriptor instead')
const UpdateTaskResponse$json = {
  '1': 'UpdateTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `UpdateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVUYXNrUmVzcG9uc2USJwoEdGFzaxgBIAEoCzITLnRpbWVsb2dnZXIudjEuVGFza1'
    'IEdGFzaw==');

@$core.Deprecated('Use deleteTaskRequestDescriptor instead')
const DeleteTaskRequest$json = {
  '1': 'DeleteTaskRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTaskRequestDescriptor =
    $convert.base64Decode('ChFEZWxldGVUYXNrUmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use setTaskArchivedRequestDescriptor instead')
const SetTaskArchivedRequest$json = {
  '1': 'SetTaskArchivedRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'archived', '3': 2, '4': 1, '5': 8, '10': 'archived'},
  ],
};

/// Descriptor for `SetTaskArchivedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTaskArchivedRequestDescriptor =
    $convert.base64Decode(
        'ChZTZXRUYXNrQXJjaGl2ZWRSZXF1ZXN0Eg4KAmlkGAEgASgEUgJpZBIaCghhcmNoaXZlZBgCIA'
        'EoCFIIYXJjaGl2ZWQ=');

@$core.Deprecated('Use setTaskArchivedResponseDescriptor instead')
const SetTaskArchivedResponse$json = {
  '1': 'SetTaskArchivedResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `SetTaskArchivedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTaskArchivedResponseDescriptor =
    $convert.base64Decode(
        'ChdTZXRUYXNrQXJjaGl2ZWRSZXNwb25zZRInCgR0YXNrGAEgASgLMhMudGltZWxvZ2dlci52MS'
        '5UYXNrUgR0YXNr');

@$core.Deprecated('Use deleteTaskResponseDescriptor instead')
const DeleteTaskResponse$json = {
  '1': 'DeleteTaskResponse',
};

/// Descriptor for `DeleteTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTaskResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVUYXNrUmVzcG9uc2U=');
