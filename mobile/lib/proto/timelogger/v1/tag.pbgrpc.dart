// This is a generated file - do not edit.
//
// Generated from timelogger/v1/tag.proto.

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

import 'tag.pb.dart' as $0;

export 'tag.pb.dart';

/// TagService manages the free-form labels attached to time entries. Tags are
/// related to entries through a join table, so renaming a tag is reflected
/// everywhere it is used.
@$pb.GrpcServiceName('timelogger.v1.TagService')
class TagServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TagServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateTagResponse> createTag(
    $0.CreateTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createTag, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTagsResponse> listTags(
    $0.ListTagsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTags, request, options: options);
  }

  $grpc.ResponseFuture<$0.RenameTagResponse> renameTag(
    $0.RenameTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$renameTag, request, options: options);
  }

  /// DeleteTag removes the tag and all of its associations with time entries.
  /// The entries themselves are left untouched.
  $grpc.ResponseFuture<$0.DeleteTagResponse> deleteTag(
    $0.DeleteTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTag, request, options: options);
  }

  // method descriptors

  static final _$createTag =
      $grpc.ClientMethod<$0.CreateTagRequest, $0.CreateTagResponse>(
          '/timelogger.v1.TagService/CreateTag',
          ($0.CreateTagRequest value) => value.writeToBuffer(),
          $0.CreateTagResponse.fromBuffer);
  static final _$listTags =
      $grpc.ClientMethod<$0.ListTagsRequest, $0.ListTagsResponse>(
          '/timelogger.v1.TagService/ListTags',
          ($0.ListTagsRequest value) => value.writeToBuffer(),
          $0.ListTagsResponse.fromBuffer);
  static final _$renameTag =
      $grpc.ClientMethod<$0.RenameTagRequest, $0.RenameTagResponse>(
          '/timelogger.v1.TagService/RenameTag',
          ($0.RenameTagRequest value) => value.writeToBuffer(),
          $0.RenameTagResponse.fromBuffer);
  static final _$deleteTag =
      $grpc.ClientMethod<$0.DeleteTagRequest, $0.DeleteTagResponse>(
          '/timelogger.v1.TagService/DeleteTag',
          ($0.DeleteTagRequest value) => value.writeToBuffer(),
          $0.DeleteTagResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.TagService')
abstract class TagServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.TagService';

  TagServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateTagRequest, $0.CreateTagResponse>(
        'CreateTag',
        createTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateTagRequest.fromBuffer(value),
        ($0.CreateTagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTagsRequest, $0.ListTagsResponse>(
        'ListTags',
        listTags_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTagsRequest.fromBuffer(value),
        ($0.ListTagsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RenameTagRequest, $0.RenameTagResponse>(
        'RenameTag',
        renameTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RenameTagRequest.fromBuffer(value),
        ($0.RenameTagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteTagRequest, $0.DeleteTagResponse>(
        'DeleteTag',
        deleteTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteTagRequest.fromBuffer(value),
        ($0.DeleteTagResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateTagResponse> createTag_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateTagRequest> $request) async {
    return createTag($call, await $request);
  }

  $async.Future<$0.CreateTagResponse> createTag(
      $grpc.ServiceCall call, $0.CreateTagRequest request);

  $async.Future<$0.ListTagsResponse> listTags_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListTagsRequest> $request) async {
    return listTags($call, await $request);
  }

  $async.Future<$0.ListTagsResponse> listTags(
      $grpc.ServiceCall call, $0.ListTagsRequest request);

  $async.Future<$0.RenameTagResponse> renameTag_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RenameTagRequest> $request) async {
    return renameTag($call, await $request);
  }

  $async.Future<$0.RenameTagResponse> renameTag(
      $grpc.ServiceCall call, $0.RenameTagRequest request);

  $async.Future<$0.DeleteTagResponse> deleteTag_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteTagRequest> $request) async {
    return deleteTag($call, await $request);
  }

  $async.Future<$0.DeleteTagResponse> deleteTag(
      $grpc.ServiceCall call, $0.DeleteTagRequest request);
}
