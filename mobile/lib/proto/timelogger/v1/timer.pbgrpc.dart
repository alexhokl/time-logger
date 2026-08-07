// This is a generated file - do not edit.
//
// Generated from timelogger/v1/timer.proto.

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

import 'timer.pb.dart' as $0;

export 'timer.pb.dart';

/// TimerService drives the live stopwatch. A running timer is stored as an
/// ordinary time entry whose end_time is unset, so stopping a timer is simply a
/// matter of filling that field in.
///
/// At most one timer may run per user; this is enforced both by the handler and
/// by a partial unique index in the database.
@$pb.GrpcServiceName('timelogger.v1.TimerService')
class TimerServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TimerServiceClient(super.channel, {super.options, super.interceptors});

  /// StartTimer opens a new running entry. If a timer is already running the
  /// call fails with FAILED_PRECONDITION and the running entry is returned in
  /// the response details.
  $grpc.ResponseFuture<$0.StartTimerResponse> startTimer(
    $0.StartTimerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startTimer, request, options: options);
  }

  /// StopTimer closes the running entry. Fails with FAILED_PRECONDITION when no
  /// timer is running.
  $grpc.ResponseFuture<$0.StopTimerResponse> stopTimer(
    $0.StopTimerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$stopTimer, request, options: options);
  }

  /// GetRunningTimer returns the running entry, or an empty response when
  /// nothing is running. It never fails just because no timer is active.
  $grpc.ResponseFuture<$0.GetRunningTimerResponse> getRunningTimer(
    $0.GetRunningTimerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRunningTimer, request, options: options);
  }

  /// CancelRunningTimer discards the running entry without recording it.
  $grpc.ResponseFuture<$0.CancelRunningTimerResponse> cancelRunningTimer(
    $0.CancelRunningTimerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelRunningTimer, request, options: options);
  }

  // method descriptors

  static final _$startTimer =
      $grpc.ClientMethod<$0.StartTimerRequest, $0.StartTimerResponse>(
          '/timelogger.v1.TimerService/StartTimer',
          ($0.StartTimerRequest value) => value.writeToBuffer(),
          $0.StartTimerResponse.fromBuffer);
  static final _$stopTimer =
      $grpc.ClientMethod<$0.StopTimerRequest, $0.StopTimerResponse>(
          '/timelogger.v1.TimerService/StopTimer',
          ($0.StopTimerRequest value) => value.writeToBuffer(),
          $0.StopTimerResponse.fromBuffer);
  static final _$getRunningTimer =
      $grpc.ClientMethod<$0.GetRunningTimerRequest, $0.GetRunningTimerResponse>(
          '/timelogger.v1.TimerService/GetRunningTimer',
          ($0.GetRunningTimerRequest value) => value.writeToBuffer(),
          $0.GetRunningTimerResponse.fromBuffer);
  static final _$cancelRunningTimer = $grpc.ClientMethod<
          $0.CancelRunningTimerRequest, $0.CancelRunningTimerResponse>(
      '/timelogger.v1.TimerService/CancelRunningTimer',
      ($0.CancelRunningTimerRequest value) => value.writeToBuffer(),
      $0.CancelRunningTimerResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.TimerService')
abstract class TimerServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.TimerService';

  TimerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StartTimerRequest, $0.StartTimerResponse>(
        'StartTimer',
        startTimer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StartTimerRequest.fromBuffer(value),
        ($0.StartTimerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StopTimerRequest, $0.StopTimerResponse>(
        'StopTimer',
        stopTimer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StopTimerRequest.fromBuffer(value),
        ($0.StopTimerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRunningTimerRequest,
            $0.GetRunningTimerResponse>(
        'GetRunningTimer',
        getRunningTimer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRunningTimerRequest.fromBuffer(value),
        ($0.GetRunningTimerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelRunningTimerRequest,
            $0.CancelRunningTimerResponse>(
        'CancelRunningTimer',
        cancelRunningTimer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelRunningTimerRequest.fromBuffer(value),
        ($0.CancelRunningTimerResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.StartTimerResponse> startTimer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StartTimerRequest> $request) async {
    return startTimer($call, await $request);
  }

  $async.Future<$0.StartTimerResponse> startTimer(
      $grpc.ServiceCall call, $0.StartTimerRequest request);

  $async.Future<$0.StopTimerResponse> stopTimer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StopTimerRequest> $request) async {
    return stopTimer($call, await $request);
  }

  $async.Future<$0.StopTimerResponse> stopTimer(
      $grpc.ServiceCall call, $0.StopTimerRequest request);

  $async.Future<$0.GetRunningTimerResponse> getRunningTimer_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRunningTimerRequest> $request) async {
    return getRunningTimer($call, await $request);
  }

  $async.Future<$0.GetRunningTimerResponse> getRunningTimer(
      $grpc.ServiceCall call, $0.GetRunningTimerRequest request);

  $async.Future<$0.CancelRunningTimerResponse> cancelRunningTimer_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelRunningTimerRequest> $request) async {
    return cancelRunningTimer($call, await $request);
  }

  $async.Future<$0.CancelRunningTimerResponse> cancelRunningTimer(
      $grpc.ServiceCall call, $0.CancelRunningTimerRequest request);
}
