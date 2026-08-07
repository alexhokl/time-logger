// This is a generated file - do not edit.
//
// Generated from timelogger/v1/project.proto.

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

import 'project.pb.dart' as $0;

export 'project.pb.dart';

/// ProjectService manages the top-level grouping of tracked work.
@$pb.GrpcServiceName('timelogger.v1.ProjectService')
class ProjectServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProjectServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateProjectResponse> createProject(
    $0.CreateProjectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListProjectsResponse> listProjects(
    $0.ListProjectsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listProjects, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetProjectResponse> getProject(
    $0.GetProjectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateProjectResponse> updateProject(
    $0.UpdateProjectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProject, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteProjectResponse> deleteProject(
    $0.DeleteProjectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteProject, request, options: options);
  }

  /// SetProjectArchived hides a project from pickers without deleting its
  /// history. Archiving is the recommended alternative to DeleteProject for a
  /// project that already has time entries.
  $grpc.ResponseFuture<$0.SetProjectArchivedResponse> setProjectArchived(
    $0.SetProjectArchivedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setProjectArchived, request, options: options);
  }

  // method descriptors

  static final _$createProject =
      $grpc.ClientMethod<$0.CreateProjectRequest, $0.CreateProjectResponse>(
          '/timelogger.v1.ProjectService/CreateProject',
          ($0.CreateProjectRequest value) => value.writeToBuffer(),
          $0.CreateProjectResponse.fromBuffer);
  static final _$listProjects =
      $grpc.ClientMethod<$0.ListProjectsRequest, $0.ListProjectsResponse>(
          '/timelogger.v1.ProjectService/ListProjects',
          ($0.ListProjectsRequest value) => value.writeToBuffer(),
          $0.ListProjectsResponse.fromBuffer);
  static final _$getProject =
      $grpc.ClientMethod<$0.GetProjectRequest, $0.GetProjectResponse>(
          '/timelogger.v1.ProjectService/GetProject',
          ($0.GetProjectRequest value) => value.writeToBuffer(),
          $0.GetProjectResponse.fromBuffer);
  static final _$updateProject =
      $grpc.ClientMethod<$0.UpdateProjectRequest, $0.UpdateProjectResponse>(
          '/timelogger.v1.ProjectService/UpdateProject',
          ($0.UpdateProjectRequest value) => value.writeToBuffer(),
          $0.UpdateProjectResponse.fromBuffer);
  static final _$deleteProject =
      $grpc.ClientMethod<$0.DeleteProjectRequest, $0.DeleteProjectResponse>(
          '/timelogger.v1.ProjectService/DeleteProject',
          ($0.DeleteProjectRequest value) => value.writeToBuffer(),
          $0.DeleteProjectResponse.fromBuffer);
  static final _$setProjectArchived = $grpc.ClientMethod<
          $0.SetProjectArchivedRequest, $0.SetProjectArchivedResponse>(
      '/timelogger.v1.ProjectService/SetProjectArchived',
      ($0.SetProjectArchivedRequest value) => value.writeToBuffer(),
      $0.SetProjectArchivedResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.ProjectService')
abstract class ProjectServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.ProjectService';

  ProjectServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.CreateProjectRequest, $0.CreateProjectResponse>(
            'CreateProject',
            createProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateProjectRequest.fromBuffer(value),
            ($0.CreateProjectResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListProjectsRequest, $0.ListProjectsResponse>(
            'ListProjects',
            listProjects_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListProjectsRequest.fromBuffer(value),
            ($0.ListProjectsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetProjectRequest, $0.GetProjectResponse>(
        'GetProject',
        getProject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetProjectRequest.fromBuffer(value),
        ($0.GetProjectResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateProjectRequest, $0.UpdateProjectResponse>(
            'UpdateProject',
            updateProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateProjectRequest.fromBuffer(value),
            ($0.UpdateProjectResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteProjectRequest, $0.DeleteProjectResponse>(
            'DeleteProject',
            deleteProject_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteProjectRequest.fromBuffer(value),
            ($0.DeleteProjectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetProjectArchivedRequest,
            $0.SetProjectArchivedResponse>(
        'SetProjectArchived',
        setProjectArchived_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetProjectArchivedRequest.fromBuffer(value),
        ($0.SetProjectArchivedResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateProjectResponse> createProject_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateProjectRequest> $request) async {
    return createProject($call, await $request);
  }

  $async.Future<$0.CreateProjectResponse> createProject(
      $grpc.ServiceCall call, $0.CreateProjectRequest request);

  $async.Future<$0.ListProjectsResponse> listProjects_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListProjectsRequest> $request) async {
    return listProjects($call, await $request);
  }

  $async.Future<$0.ListProjectsResponse> listProjects(
      $grpc.ServiceCall call, $0.ListProjectsRequest request);

  $async.Future<$0.GetProjectResponse> getProject_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProjectRequest> $request) async {
    return getProject($call, await $request);
  }

  $async.Future<$0.GetProjectResponse> getProject(
      $grpc.ServiceCall call, $0.GetProjectRequest request);

  $async.Future<$0.UpdateProjectResponse> updateProject_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateProjectRequest> $request) async {
    return updateProject($call, await $request);
  }

  $async.Future<$0.UpdateProjectResponse> updateProject(
      $grpc.ServiceCall call, $0.UpdateProjectRequest request);

  $async.Future<$0.DeleteProjectResponse> deleteProject_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteProjectRequest> $request) async {
    return deleteProject($call, await $request);
  }

  $async.Future<$0.DeleteProjectResponse> deleteProject(
      $grpc.ServiceCall call, $0.DeleteProjectRequest request);

  $async.Future<$0.SetProjectArchivedResponse> setProjectArchived_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetProjectArchivedRequest> $request) async {
    return setProjectArchived($call, await $request);
  }

  $async.Future<$0.SetProjectArchivedResponse> setProjectArchived(
      $grpc.ServiceCall call, $0.SetProjectArchivedRequest request);
}
