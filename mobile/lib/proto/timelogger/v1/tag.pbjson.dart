// This is a generated file - do not edit.
//
// Generated from timelogger/v1/tag.proto.

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

@$core.Deprecated('Use tagDescriptor instead')
const Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'entry_count', '3': 3, '4': 1, '5': 3, '10': 'entryCount'},
    {'1': 'total_seconds', '3': 4, '4': 1, '5': 3, '10': 'totalSeconds'},
  ],
};

/// Descriptor for `Tag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagDescriptor = $convert.base64Decode(
    'CgNUYWcSDgoCaWQYASABKARSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHwoLZW50cnlfY291bn'
    'QYAyABKANSCmVudHJ5Q291bnQSIwoNdG90YWxfc2Vjb25kcxgEIAEoA1IMdG90YWxTZWNvbmRz');

@$core.Deprecated('Use createTagRequestDescriptor instead')
const CreateTagRequest$json = {
  '1': 'CreateTagRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTagRequestDescriptor = $convert
    .base64Decode('ChBDcmVhdGVUYWdSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use createTagResponseDescriptor instead')
const CreateTagResponse$json = {
  '1': 'CreateTagResponse',
  '2': [
    {
      '1': 'tag',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Tag',
      '10': 'tag'
    },
  ],
};

/// Descriptor for `CreateTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTagResponseDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVUYWdSZXNwb25zZRIkCgN0YWcYASABKAsyEi50aW1lbG9nZ2VyLnYxLlRhZ1IDdG'
    'Fn');

@$core.Deprecated('Use listTagsRequestDescriptor instead')
const ListTagsRequest$json = {
  '1': 'ListTagsRequest',
  '2': [
    {'1': 'include_stats', '3': 1, '4': 1, '5': 8, '10': 'includeStats'},
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.PageRequest',
      '10': 'page'
    },
  ],
};

/// Descriptor for `ListTagsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTagsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0VGFnc1JlcXVlc3QSIwoNaW5jbHVkZV9zdGF0cxgBIAEoCFIMaW5jbHVkZVN0YXRzEi'
    '4KBHBhZ2UYAiABKAsyGi50aW1lbG9nZ2VyLnYxLlBhZ2VSZXF1ZXN0UgRwYWdl');

@$core.Deprecated('Use listTagsResponseDescriptor instead')
const ListTagsResponse$json = {
  '1': 'ListTagsResponse',
  '2': [
    {
      '1': 'tags',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.timelogger.v1.Tag',
      '10': 'tags'
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

/// Descriptor for `ListTagsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTagsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFnc1Jlc3BvbnNlEiYKBHRhZ3MYASADKAsyEi50aW1lbG9nZ2VyLnYxLlRhZ1IEdG'
    'FncxIvCgRwYWdlGAIgASgLMhsudGltZWxvZ2dlci52MS5QYWdlUmVzcG9uc2VSBHBhZ2U=');

@$core.Deprecated('Use renameTagRequestDescriptor instead')
const RenameTagRequest$json = {
  '1': 'RenameTagRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RenameTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameTagRequestDescriptor = $convert.base64Decode(
    'ChBSZW5hbWVUYWdSZXF1ZXN0Eg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use renameTagResponseDescriptor instead')
const RenameTagResponse$json = {
  '1': 'RenameTagResponse',
  '2': [
    {
      '1': 'tag',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.timelogger.v1.Tag',
      '10': 'tag'
    },
  ],
};

/// Descriptor for `RenameTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameTagResponseDescriptor = $convert.base64Decode(
    'ChFSZW5hbWVUYWdSZXNwb25zZRIkCgN0YWcYASABKAsyEi50aW1lbG9nZ2VyLnYxLlRhZ1IDdG'
    'Fn');

@$core.Deprecated('Use deleteTagRequestDescriptor instead')
const DeleteTagRequest$json = {
  '1': 'DeleteTagRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTagRequestDescriptor =
    $convert.base64Decode('ChBEZWxldGVUYWdSZXF1ZXN0Eg4KAmlkGAEgASgEUgJpZA==');

@$core.Deprecated('Use deleteTagResponseDescriptor instead')
const DeleteTagResponse$json = {
  '1': 'DeleteTagResponse',
};

/// Descriptor for `DeleteTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTagResponseDescriptor =
    $convert.base64Decode('ChFEZWxldGVUYWdSZXNwb25zZQ==');
