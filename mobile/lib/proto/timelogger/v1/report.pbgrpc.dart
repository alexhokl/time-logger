// This is a generated file - do not edit.
//
// Generated from timelogger/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'report.pb.dart' as $0;

export 'report.pb.dart';

/// ReportService aggregates tracked time. Every report bucketises entries using
/// day boundaries in the user's configured timezone, so a report for "today"
/// means the user's local day rather than a UTC day.
@$pb.GrpcServiceName('timelogger.v1.ReportService')
class ReportServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ReportServiceClient(super.channel, {super.options, super.interceptors});

  /// GetDailyReport summarises a single day (defaults to today).
  $grpc.ResponseFuture<$0.GetDailyReportResponse> getDailyReport(
    $0.GetDailyReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDailyReport, request, options: options);
  }

  /// GetWeeklyReport summarises the week containing the given date, using the
  /// user's configured first day of week.
  $grpc.ResponseFuture<$0.GetWeeklyReportResponse> getWeeklyReport(
    $0.GetWeeklyReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getWeeklyReport, request, options: options);
  }

  /// GetMonthlyReport summarises the calendar month containing the given date.
  $grpc.ResponseFuture<$0.GetMonthlyReportResponse> getMonthlyReport(
    $0.GetMonthlyReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMonthlyReport, request, options: options);
  }

  /// GetRangeReport summarises an arbitrary inclusive date range.
  $grpc.ResponseFuture<$0.GetRangeReportResponse> getRangeReport(
    $0.GetRangeReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRangeReport, request, options: options);
  }

  /// GetGoalReport compares tracked time against each goal's target for the
  /// goal's current (or requested) period.
  $grpc.ResponseFuture<$0.GetGoalReportResponse> getGoalReport(
    $0.GetGoalReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGoalReport, request, options: options);
  }

  /// GetActivityHeatmap returns one bucket per day over a range, suitable for
  /// rendering a contribution-graph style heatmap.
  $grpc.ResponseFuture<$0.GetActivityHeatmapResponse> getActivityHeatmap(
    $0.GetActivityHeatmapRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActivityHeatmap, request, options: options);
  }

  /// GetStreaks reports consecutive-day tracking streaks.
  $grpc.ResponseFuture<$0.GetStreaksResponse> getStreaks(
    $0.GetStreaksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStreaks, request, options: options);
  }

  // method descriptors

  static final _$getDailyReport =
      $grpc.ClientMethod<$0.GetDailyReportRequest, $0.GetDailyReportResponse>(
          '/timelogger.v1.ReportService/GetDailyReport',
          ($0.GetDailyReportRequest value) => value.writeToBuffer(),
          $0.GetDailyReportResponse.fromBuffer);
  static final _$getWeeklyReport =
      $grpc.ClientMethod<$0.GetWeeklyReportRequest, $0.GetWeeklyReportResponse>(
          '/timelogger.v1.ReportService/GetWeeklyReport',
          ($0.GetWeeklyReportRequest value) => value.writeToBuffer(),
          $0.GetWeeklyReportResponse.fromBuffer);
  static final _$getMonthlyReport = $grpc.ClientMethod<
          $0.GetMonthlyReportRequest, $0.GetMonthlyReportResponse>(
      '/timelogger.v1.ReportService/GetMonthlyReport',
      ($0.GetMonthlyReportRequest value) => value.writeToBuffer(),
      $0.GetMonthlyReportResponse.fromBuffer);
  static final _$getRangeReport =
      $grpc.ClientMethod<$0.GetRangeReportRequest, $0.GetRangeReportResponse>(
          '/timelogger.v1.ReportService/GetRangeReport',
          ($0.GetRangeReportRequest value) => value.writeToBuffer(),
          $0.GetRangeReportResponse.fromBuffer);
  static final _$getGoalReport =
      $grpc.ClientMethod<$0.GetGoalReportRequest, $0.GetGoalReportResponse>(
          '/timelogger.v1.ReportService/GetGoalReport',
          ($0.GetGoalReportRequest value) => value.writeToBuffer(),
          $0.GetGoalReportResponse.fromBuffer);
  static final _$getActivityHeatmap = $grpc.ClientMethod<
          $0.GetActivityHeatmapRequest, $0.GetActivityHeatmapResponse>(
      '/timelogger.v1.ReportService/GetActivityHeatmap',
      ($0.GetActivityHeatmapRequest value) => value.writeToBuffer(),
      $0.GetActivityHeatmapResponse.fromBuffer);
  static final _$getStreaks =
      $grpc.ClientMethod<$0.GetStreaksRequest, $0.GetStreaksResponse>(
          '/timelogger.v1.ReportService/GetStreaks',
          ($0.GetStreaksRequest value) => value.writeToBuffer(),
          $0.GetStreaksResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.ReportService')
abstract class ReportServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.ReportService';

  ReportServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetDailyReportRequest,
            $0.GetDailyReportResponse>(
        'GetDailyReport',
        getDailyReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDailyReportRequest.fromBuffer(value),
        ($0.GetDailyReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetWeeklyReportRequest,
            $0.GetWeeklyReportResponse>(
        'GetWeeklyReport',
        getWeeklyReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetWeeklyReportRequest.fromBuffer(value),
        ($0.GetWeeklyReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMonthlyReportRequest,
            $0.GetMonthlyReportResponse>(
        'GetMonthlyReport',
        getMonthlyReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMonthlyReportRequest.fromBuffer(value),
        ($0.GetMonthlyReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRangeReportRequest,
            $0.GetRangeReportResponse>(
        'GetRangeReport',
        getRangeReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRangeReportRequest.fromBuffer(value),
        ($0.GetRangeReportResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetGoalReportRequest, $0.GetGoalReportResponse>(
            'GetGoalReport',
            getGoalReport_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetGoalReportRequest.fromBuffer(value),
            ($0.GetGoalReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetActivityHeatmapRequest,
            $0.GetActivityHeatmapResponse>(
        'GetActivityHeatmap',
        getActivityHeatmap_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetActivityHeatmapRequest.fromBuffer(value),
        ($0.GetActivityHeatmapResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStreaksRequest, $0.GetStreaksResponse>(
        'GetStreaks',
        getStreaks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStreaksRequest.fromBuffer(value),
        ($0.GetStreaksResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetDailyReportResponse> getDailyReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDailyReportRequest> $request) async {
    return getDailyReport($call, await $request);
  }

  $async.Future<$0.GetDailyReportResponse> getDailyReport(
      $grpc.ServiceCall call, $0.GetDailyReportRequest request);

  $async.Future<$0.GetWeeklyReportResponse> getWeeklyReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetWeeklyReportRequest> $request) async {
    return getWeeklyReport($call, await $request);
  }

  $async.Future<$0.GetWeeklyReportResponse> getWeeklyReport(
      $grpc.ServiceCall call, $0.GetWeeklyReportRequest request);

  $async.Future<$0.GetMonthlyReportResponse> getMonthlyReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMonthlyReportRequest> $request) async {
    return getMonthlyReport($call, await $request);
  }

  $async.Future<$0.GetMonthlyReportResponse> getMonthlyReport(
      $grpc.ServiceCall call, $0.GetMonthlyReportRequest request);

  $async.Future<$0.GetRangeReportResponse> getRangeReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRangeReportRequest> $request) async {
    return getRangeReport($call, await $request);
  }

  $async.Future<$0.GetRangeReportResponse> getRangeReport(
      $grpc.ServiceCall call, $0.GetRangeReportRequest request);

  $async.Future<$0.GetGoalReportResponse> getGoalReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetGoalReportRequest> $request) async {
    return getGoalReport($call, await $request);
  }

  $async.Future<$0.GetGoalReportResponse> getGoalReport(
      $grpc.ServiceCall call, $0.GetGoalReportRequest request);

  $async.Future<$0.GetActivityHeatmapResponse> getActivityHeatmap_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetActivityHeatmapRequest> $request) async {
    return getActivityHeatmap($call, await $request);
  }

  $async.Future<$0.GetActivityHeatmapResponse> getActivityHeatmap(
      $grpc.ServiceCall call, $0.GetActivityHeatmapRequest request);

  $async.Future<$0.GetStreaksResponse> getStreaks_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStreaksRequest> $request) async {
    return getStreaks($call, await $request);
  }

  $async.Future<$0.GetStreaksResponse> getStreaks(
      $grpc.ServiceCall call, $0.GetStreaksRequest request);
}
