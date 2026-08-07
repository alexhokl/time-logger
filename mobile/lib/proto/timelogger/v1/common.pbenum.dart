// This is a generated file - do not edit.
//
// Generated from timelogger/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Period identifies a repeating time window used by goals and reports.
class Period extends $pb.ProtobufEnum {
  static const Period PERIOD_UNSPECIFIED =
      Period._(0, _omitEnumNames ? '' : 'PERIOD_UNSPECIFIED');
  static const Period PERIOD_DAILY =
      Period._(1, _omitEnumNames ? '' : 'PERIOD_DAILY');
  static const Period PERIOD_WEEKLY =
      Period._(2, _omitEnumNames ? '' : 'PERIOD_WEEKLY');
  static const Period PERIOD_MONTHLY =
      Period._(3, _omitEnumNames ? '' : 'PERIOD_MONTHLY');

  static const $core.List<Period> values = <Period>[
    PERIOD_UNSPECIFIED,
    PERIOD_DAILY,
    PERIOD_WEEKLY,
    PERIOD_MONTHLY,
  ];

  static final $core.List<Period?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Period? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Period._(super.value, super.name);
}

/// SortOrder controls the direction of the primary sort key of a List RPC.
class SortOrder extends $pb.ProtobufEnum {
  static const SortOrder SORT_ORDER_UNSPECIFIED =
      SortOrder._(0, _omitEnumNames ? '' : 'SORT_ORDER_UNSPECIFIED');
  static const SortOrder SORT_ORDER_ASC =
      SortOrder._(1, _omitEnumNames ? '' : 'SORT_ORDER_ASC');
  static const SortOrder SORT_ORDER_DESC =
      SortOrder._(2, _omitEnumNames ? '' : 'SORT_ORDER_DESC');

  static const $core.List<SortOrder> values = <SortOrder>[
    SORT_ORDER_UNSPECIFIED,
    SORT_ORDER_ASC,
    SORT_ORDER_DESC,
  ];

  static final $core.List<SortOrder?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SortOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SortOrder._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
