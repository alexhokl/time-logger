// This is a generated file - do not edit.
//
// Generated from timelogger/v1/project.proto.

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

@$core.Deprecated('Use projectDescriptor instead')
const Project$json = {
  '1': 'Project',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
    {'1': 'archived', '3': 4, '4': 1, '5': 8, '10': 'archived'},
    {'1': 'entry_count', '3': 5, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'total_seconds', '3': 6, '4': 1, '5': 3, '10': 'totalSeconds'},
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBWNvbG9yGA'
    'MgASgJUgVjb2xvchIaCghhcmNoaXZlZBgEIAEoCFIIYXJjaGl2ZWQSHwoLZW50cnlfY291bnQY'
    'BSABKANSCmVudHJ5Q291bnQSIwoNdG90YWxfc2Vjb25kcxgGIAEoA1IMdG90YWxTZWNvbmRz');

@$core.Deprecated('Use createProjectRequestDescriptor instead')
const CreateProjectRequest$json = {
  '1': 'CreateProjectRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 2, '4': 1, '5': 9, '10': 'color'},
  ],
};

/// Descriptor for `CreateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQcm9qZWN0UmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEhQKBWNvbG9yGAIgAS'
    'gJUgVjb2xvcg==');

@$core.Deprecated('Use createProjectResponseDescriptor instead')
const CreateProjectResponse$json = {
  '1': 'CreateProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `CreateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQcm9qZWN0UmVzcG9uc2USMAoHcHJvamVjdBgBIAEoCzIWLnRpbWVsb2dnZXIudj'
    'EuUHJvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
  '2': [
    {'1': 'include_archived', '3': 1, '4': 1, '5': 8, '10': 'includeArchived'},
    {'1': 'include_stats', '3': 2, '4': 1, '5': 8, '10': 'includeStats'},
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

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UHJvamVjdHNSZXF1ZXN0EikKEGluY2x1ZGVfYXJjaGl2ZWQYASABKAhSD2luY2x1ZG'
    'VBcmNoaXZlZBIjCg1pbmNsdWRlX3N0YXRzGAIgASgIUgxpbmNsdWRlU3RhdHMSLgoEcGFnZRgD'
    'IAEoCzIaLnRpbWVsb2dnZXIudjEuUGFnZVJlcXVlc3RSBHBhZ2U=');

@$core.Deprecated('Use listProjectsResponseDescriptor instead')
const ListProjectsResponse$json = {
  '1': 'ListProjectsResponse',
  '2': [
    {
      '1': 'projects',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.Project',
      '10': 'projects'
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

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRIyCghwcm9qZWN0cxgBIAMoCzIWLnRpbWVsb2dnZXIudj'
    'EuUHJvamVjdFIIcHJvamVjdHMSLwoEcGFnZRgCIAEoCzIbLnRpbWVsb2dnZXIudjEuUGFnZVJl'
    'c3BvbnNlUgRwYWdl');

@$core.Deprecated('Use getProjectRequestDescriptor instead')
const GetProjectRequest$json = {
  '1': 'GetProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'include_stats', '3': 2, '4': 1, '5': 8, '10': 'includeStats'},
  ],
};

/// Descriptor for `GetProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSIwoNaW5jbHVkZV9zdGF0cxgCIA'
    'EoCFIMaW5jbHVkZVN0YXRz');

@$core.Deprecated('Use getProjectResponseDescriptor instead')
const GetProjectResponse$json = {
  '1': 'GetProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `GetProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9qZWN0UmVzcG9uc2USMAoHcHJvamVjdBgBIAEoCzIWLnRpbWVsb2dnZXIudjEuUH'
    'JvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use updateProjectRequestDescriptor instead')
const UpdateProjectRequest$json = {
  '1': 'UpdateProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'update_mask', '3': 2, '4': 3, '5': 9, '10': 'updateMask'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '10': 'color'},
  ],
};

/// Descriptor for `UpdateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoBFICaWQSHwoLdXBkYXRlX21hc2sYAi'
    'ADKAlSCnVwZGF0ZU1hc2sSEgoEbmFtZRgDIAEoCVIEbmFtZRIUCgVjb2xvchgEIAEoCVIFY29s'
    'b3I=');

@$core.Deprecated('Use updateProjectResponseDescriptor instead')
const UpdateProjectResponse$json = {
  '1': 'UpdateProjectResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `UpdateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9qZWN0UmVzcG9uc2USMAoHcHJvamVjdBgBIAEoCzIWLnRpbWVsb2dnZXIudj'
    'EuUHJvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use deleteProjectRequestDescriptor instead')
const DeleteProjectRequest$json = {
  '1': 'DeleteProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `DeleteProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectRequestDescriptor = $convert
    .base64Decode('ChREZWxldGVQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use setProjectArchivedRequestDescriptor instead')
const SetProjectArchivedRequest$json = {
  '1': 'SetProjectArchivedRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'archived', '3': 2, '4': 1, '5': 8, '10': 'archived'},
  ],
};

/// Descriptor for `SetProjectArchivedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setProjectArchivedRequestDescriptor =
    $convert.base64Decode(
        'ChlTZXRQcm9qZWN0QXJjaGl2ZWRSZXF1ZXN0Eg4KAmlkGAEgASgEUgJpZBIaCghhcmNoaXZlZB'
        'gCIAEoCFIIYXJjaGl2ZWQ=');

@$core.Deprecated('Use setProjectArchivedResponseDescriptor instead')
const SetProjectArchivedResponse$json = {
  '1': 'SetProjectArchivedResponse',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Project',
      '10': 'project'
    },
  ],
};

/// Descriptor for `SetProjectArchivedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setProjectArchivedResponseDescriptor =
    $convert.base64Decode(
        'ChpTZXRQcm9qZWN0QXJjaGl2ZWRSZXNwb25zZRIwCgdwcm9qZWN0GAEgASgLMhYudGltZWxvZ2'
        'dlci52MS5Qcm9qZWN0Ugdwcm9qZWN0');

@$core.Deprecated('Use deleteProjectResponseDescriptor instead')
const DeleteProjectResponse$json = {
  '1': 'DeleteProjectResponse',
};

/// Descriptor for `DeleteProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVQcm9qZWN0UmVzcG9uc2U=');
