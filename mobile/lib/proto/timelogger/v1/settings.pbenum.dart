// This is a generated file - do not edit.
//
// Generated from timelogger/v1/settings.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// DayOfWeek is used to configure which day a reporting week starts on.
class DayOfWeek extends $pb.ProtobufEnum {
  static const DayOfWeek DAY_OF_WEEK_UNSPECIFIED =
      DayOfWeek._(0, _omitEnumNames ? '' : 'DAY_OF_WEEK_UNSPECIFIED');
  static const DayOfWeek DAY_OF_WEEK_MONDAY =
      DayOfWeek._(1, _omitEnumNames ? '' : 'DAY_OF_WEEK_MONDAY');
  static const DayOfWeek DAY_OF_WEEK_TUESDAY =
      DayOfWeek._(2, _omitEnumNames ? '' : 'DAY_OF_WEEK_TUESDAY');
  static const DayOfWeek DAY_OF_WEEK_WEDNESDAY =
      DayOfWeek._(3, _omitEnumNames ? '' : 'DAY_OF_WEEK_WEDNESDAY');
  static const DayOfWeek DAY_OF_WEEK_THURSDAY =
      DayOfWeek._(4, _omitEnumNames ? '' : 'DAY_OF_WEEK_THURSDAY');
  static const DayOfWeek DAY_OF_WEEK_FRIDAY =
      DayOfWeek._(5, _omitEnumNames ? '' : 'DAY_OF_WEEK_FRIDAY');
  static const DayOfWeek DAY_OF_WEEK_SATURDAY =
      DayOfWeek._(6, _omitEnumNames ? '' : 'DAY_OF_WEEK_SATURDAY');
  static const DayOfWeek DAY_OF_WEEK_SUNDAY =
      DayOfWeek._(7, _omitEnumNames ? '' : 'DAY_OF_WEEK_SUNDAY');

  static const $core.List<DayOfWeek> values = <DayOfWeek>[
    DAY_OF_WEEK_UNSPECIFIED,
    DAY_OF_WEEK_MONDAY,
    DAY_OF_WEEK_TUESDAY,
    DAY_OF_WEEK_WEDNESDAY,
    DAY_OF_WEEK_THURSDAY,
    DAY_OF_WEEK_FRIDAY,
    DAY_OF_WEEK_SATURDAY,
    DAY_OF_WEEK_SUNDAY,
  ];

  static final $core.List<DayOfWeek?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DayOfWeek? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DayOfWeek._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
