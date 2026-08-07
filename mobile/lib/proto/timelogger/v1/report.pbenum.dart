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

import 'package:protobuf/protobuf.dart' as $pb;

/// GroupBy selects the dimension a period report is broken down by.
class GroupBy extends $pb.ProtobufEnum {
  static const GroupBy GROUP_BY_UNSPECIFIED =
      GroupBy._(0, _omitEnumNames ? '' : 'GROUP_BY_UNSPECIFIED');
  static const GroupBy GROUP_BY_PROJECT =
      GroupBy._(1, _omitEnumNames ? '' : 'GROUP_BY_PROJECT');
  static const GroupBy GROUP_BY_TASK =
      GroupBy._(2, _omitEnumNames ? '' : 'GROUP_BY_TASK');
  static const GroupBy GROUP_BY_TAG =
      GroupBy._(3, _omitEnumNames ? '' : 'GROUP_BY_TAG');
  static const GroupBy GROUP_BY_DAY =
      GroupBy._(4, _omitEnumNames ? '' : 'GROUP_BY_DAY');

  static const $core.List<GroupBy> values = <GroupBy>[
    GROUP_BY_UNSPECIFIED,
    GROUP_BY_PROJECT,
    GROUP_BY_TASK,
    GROUP_BY_TAG,
    GROUP_BY_DAY,
  ];

  static final $core.List<GroupBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static GroupBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GroupBy._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
