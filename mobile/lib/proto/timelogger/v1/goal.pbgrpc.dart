// This is a generated file - do not edit.
//
// Generated from timelogger/v1/goal.proto.

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

import 'goal.pb.dart' as $0;

export 'goal.pb.dart';

/// GoalService manages recurring targets for how much time should be spent on a
/// project or task within a period.
@$pb.GrpcServiceName('timelogger.v1.GoalService')
class GoalServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  GoalServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateGoalResponse> createGoal(
    $0.CreateGoalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createGoal, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListGoalsResponse> listGoals(
    $0.ListGoalsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listGoals, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetGoalResponse> getGoal(
    $0.GetGoalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGoal, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateGoalResponse> updateGoal(
    $0.UpdateGoalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateGoal, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteGoalResponse> deleteGoal(
    $0.DeleteGoalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteGoal, request, options: options);
  }

  // method descriptors

  static final _$createGoal =
      $grpc.ClientMethod<$0.CreateGoalRequest, $0.CreateGoalResponse>(
          '/timelogger.v1.GoalService/CreateGoal',
          ($0.CreateGoalRequest value) => value.writeToBuffer(),
          $0.CreateGoalResponse.fromBuffer);
  static final _$listGoals =
      $grpc.ClientMethod<$0.ListGoalsRequest, $0.ListGoalsResponse>(
          '/timelogger.v1.GoalService/ListGoals',
          ($0.ListGoalsRequest value) => value.writeToBuffer(),
          $0.ListGoalsResponse.fromBuffer);
  static final _$getGoal =
      $grpc.ClientMethod<$0.GetGoalRequest, $0.GetGoalResponse>(
          '/timelogger.v1.GoalService/GetGoal',
          ($0.GetGoalRequest value) => value.writeToBuffer(),
          $0.GetGoalResponse.fromBuffer);
  static final _$updateGoal =
      $grpc.ClientMethod<$0.UpdateGoalRequest, $0.UpdateGoalResponse>(
          '/timelogger.v1.GoalService/UpdateGoal',
          ($0.UpdateGoalRequest value) => value.writeToBuffer(),
          $0.UpdateGoalResponse.fromBuffer);
  static final _$deleteGoal =
      $grpc.ClientMethod<$0.DeleteGoalRequest, $0.DeleteGoalResponse>(
          '/timelogger.v1.GoalService/DeleteGoal',
          ($0.DeleteGoalRequest value) => value.writeToBuffer(),
          $0.DeleteGoalResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.GoalService')
abstract class GoalServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.GoalService';

  GoalServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateGoalRequest, $0.CreateGoalResponse>(
        'CreateGoal',
        createGoal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateGoalRequest.fromBuffer(value),
        ($0.CreateGoalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListGoalsRequest, $0.ListGoalsResponse>(
        'ListGoals',
        listGoals_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListGoalsRequest.fromBuffer(value),
        ($0.ListGoalsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetGoalRequest, $0.GetGoalResponse>(
        'GetGoal',
        getGoal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetGoalRequest.fromBuffer(value),
        ($0.GetGoalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateGoalRequest, $0.UpdateGoalResponse>(
        'UpdateGoal',
        updateGoal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateGoalRequest.fromBuffer(value),
        ($0.UpdateGoalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteGoalRequest, $0.DeleteGoalResponse>(
        'DeleteGoal',
        deleteGoal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteGoalRequest.fromBuffer(value),
        ($0.DeleteGoalResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateGoalResponse> createGoal_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateGoalRequest> $request) async {
    return createGoal($call, await $request);
  }

  $async.Future<$0.CreateGoalResponse> createGoal(
      $grpc.ServiceCall call, $0.CreateGoalRequest request);

  $async.Future<$0.ListGoalsResponse> listGoals_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListGoalsRequest> $request) async {
    return listGoals($call, await $request);
  }

  $async.Future<$0.ListGoalsResponse> listGoals(
      $grpc.ServiceCall call, $0.ListGoalsRequest request);

  $async.Future<$0.GetGoalResponse> getGoal_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetGoalRequest> $request) async {
    return getGoal($call, await $request);
  }

  $async.Future<$0.GetGoalResponse> getGoal(
      $grpc.ServiceCall call, $0.GetGoalRequest request);

  $async.Future<$0.UpdateGoalResponse> updateGoal_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateGoalRequest> $request) async {
    return updateGoal($call, await $request);
  }

  $async.Future<$0.UpdateGoalResponse> updateGoal(
      $grpc.ServiceCall call, $0.UpdateGoalRequest request);

  $async.Future<$0.DeleteGoalResponse> deleteGoal_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteGoalRequest> $request) async {
    return deleteGoal($call, await $request);
  }

  $async.Future<$0.DeleteGoalResponse> deleteGoal(
      $grpc.ServiceCall call, $0.DeleteGoalRequest request);
}
