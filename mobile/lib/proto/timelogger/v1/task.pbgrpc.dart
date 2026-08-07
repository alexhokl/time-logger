// This is a generated file - do not edit.
//
// Generated from timelogger/v1/task.proto.

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

import 'task.pb.dart' as $0;

export 'task.pb.dart';

/// TaskService manages the optional second level of grouping below a project.
@$pb.GrpcServiceName('timelogger.v1.TaskService')
class TaskServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TaskServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateTaskResponse> createTask(
    $0.CreateTaskRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTasksResponse> listTasks(
    $0.ListTasksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTasks, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetTaskResponse> getTask(
    $0.GetTaskRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateTaskResponse> updateTask(
    $0.UpdateTaskRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateTask, request, options: options);
  }

  /// DeleteTask detaches the task from any time entry referencing it (setting
  /// their task to none) before removing it.
  $grpc.ResponseFuture<$0.DeleteTaskResponse> deleteTask(
    $0.DeleteTaskRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.SetTaskArchivedResponse> setTaskArchived(
    $0.SetTaskArchivedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setTaskArchived, request, options: options);
  }

  // method descriptors

  static final _$createTask =
      $grpc.ClientMethod<$0.CreateTaskRequest, $0.CreateTaskResponse>(
          '/timelogger.v1.TaskService/CreateTask',
          ($0.CreateTaskRequest value) => value.writeToBuffer(),
          $0.CreateTaskResponse.fromBuffer);
  static final _$listTasks =
      $grpc.ClientMethod<$0.ListTasksRequest, $0.ListTasksResponse>(
          '/timelogger.v1.TaskService/ListTasks',
          ($0.ListTasksRequest value) => value.writeToBuffer(),
          $0.ListTasksResponse.fromBuffer);
  static final _$getTask =
      $grpc.ClientMethod<$0.GetTaskRequest, $0.GetTaskResponse>(
          '/timelogger.v1.TaskService/GetTask',
          ($0.GetTaskRequest value) => value.writeToBuffer(),
          $0.GetTaskResponse.fromBuffer);
  static final _$updateTask =
      $grpc.ClientMethod<$0.UpdateTaskRequest, $0.UpdateTaskResponse>(
          '/timelogger.v1.TaskService/UpdateTask',
          ($0.UpdateTaskRequest value) => value.writeToBuffer(),
          $0.UpdateTaskResponse.fromBuffer);
  static final _$deleteTask =
      $grpc.ClientMethod<$0.DeleteTaskRequest, $0.DeleteTaskResponse>(
          '/timelogger.v1.TaskService/DeleteTask',
          ($0.DeleteTaskRequest value) => value.writeToBuffer(),
          $0.DeleteTaskResponse.fromBuffer);
  static final _$setTaskArchived =
      $grpc.ClientMethod<$0.SetTaskArchivedRequest, $0.SetTaskArchivedResponse>(
          '/timelogger.v1.TaskService/SetTaskArchived',
          ($0.SetTaskArchivedRequest value) => value.writeToBuffer(),
          $0.SetTaskArchivedResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.TaskService')
abstract class TaskServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.TaskService';

  TaskServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateTaskRequest, $0.CreateTaskResponse>(
        'CreateTask',
        createTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateTaskRequest.fromBuffer(value),
        ($0.CreateTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTasksRequest, $0.ListTasksResponse>(
        'ListTasks',
        listTasks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTasksRequest.fromBuffer(value),
        ($0.ListTasksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTaskRequest, $0.GetTaskResponse>(
        'GetTask',
        getTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTaskRequest.fromBuffer(value),
        ($0.GetTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateTaskRequest, $0.UpdateTaskResponse>(
        'UpdateTask',
        updateTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateTaskRequest.fromBuffer(value),
        ($0.UpdateTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteTaskRequest, $0.DeleteTaskResponse>(
        'DeleteTask',
        deleteTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteTaskRequest.fromBuffer(value),
        ($0.DeleteTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetTaskArchivedRequest,
            $0.SetTaskArchivedResponse>(
        'SetTaskArchived',
        setTaskArchived_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetTaskArchivedRequest.fromBuffer(value),
        ($0.SetTaskArchivedResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateTaskResponse> createTask_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateTaskRequest> $request) async {
    return createTask($call, await $request);
  }

  $async.Future<$0.CreateTaskResponse> createTask(
      $grpc.ServiceCall call, $0.CreateTaskRequest request);

  $async.Future<$0.ListTasksResponse> listTasks_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListTasksRequest> $request) async {
    return listTasks($call, await $request);
  }

  $async.Future<$0.ListTasksResponse> listTasks(
      $grpc.ServiceCall call, $0.ListTasksRequest request);

  $async.Future<$0.GetTaskResponse> getTask_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTaskRequest> $request) async {
    return getTask($call, await $request);
  }

  $async.Future<$0.GetTaskResponse> getTask(
      $grpc.ServiceCall call, $0.GetTaskRequest request);

  $async.Future<$0.UpdateTaskResponse> updateTask_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateTaskRequest> $request) async {
    return updateTask($call, await $request);
  }

  $async.Future<$0.UpdateTaskResponse> updateTask(
      $grpc.ServiceCall call, $0.UpdateTaskRequest request);

  $async.Future<$0.DeleteTaskResponse> deleteTask_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteTaskRequest> $request) async {
    return deleteTask($call, await $request);
  }

  $async.Future<$0.DeleteTaskResponse> deleteTask(
      $grpc.ServiceCall call, $0.DeleteTaskRequest request);

  $async.Future<$0.SetTaskArchivedResponse> setTaskArchived_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetTaskArchivedRequest> $request) async {
    return setTaskArchived($call, await $request);
  }

  $async.Future<$0.SetTaskArchivedResponse> setTaskArchived(
      $grpc.ServiceCall call, $0.SetTaskArchivedRequest request);
}
