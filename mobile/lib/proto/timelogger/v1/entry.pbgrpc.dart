// This is a generated file - do not edit.
//
// Generated from timelogger/v1/entry.proto.

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

import 'entry.pb.dart' as $0;

export 'entry.pb.dart';

/// TimeEntryService manages completed (and in-progress) units of tracked work.
///
/// Time specification rules
/// ------------------------
/// A time entry is defined by any two of start_time, end_time and
/// duration_seconds; the server derives the third. The accepted combinations
/// are:
///
///   start + end       -> duration is computed as end - start
///   start + duration  -> end is computed as start + duration
///   end + duration    -> start is computed as end - duration
///   date + duration   -> start is midnight on that date in the user's
///                        timezone, end is start + duration
///   start only        -> the entry is left running (see TimerService)
///
/// Supplying all three is accepted only when they are mutually consistent;
/// otherwise the request is rejected with INVALID_ARGUMENT.
@$pb.GrpcServiceName('timelogger.v1.TimeEntryService')
class TimeEntryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TimeEntryServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateEntryResponse> createEntry(
    $0.CreateEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createEntry, request, options: options);
  }

  /// CreateEntries inserts many entries in a single transaction. Either all
  /// entries are stored or none are.
  $grpc.ResponseFuture<$0.CreateEntriesResponse> createEntries(
    $0.CreateEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createEntries, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListEntriesResponse> listEntries(
    $0.ListEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listEntries, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetEntryResponse> getEntry(
    $0.GetEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateEntryResponse> updateEntry(
    $0.UpdateEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateEntry, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteEntryResponse> deleteEntry(
    $0.DeleteEntryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteEntry, request, options: options);
  }

  /// CopyEntries duplicates existing entries onto another date, preserving
  /// their time of day, duration, project, task and tags.
  $grpc.ResponseFuture<$0.CopyEntriesResponse> copyEntries(
    $0.CopyEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$copyEntries, request, options: options);
  }

  // method descriptors

  static final _$createEntry =
      $grpc.ClientMethod<$0.CreateEntryRequest, $0.CreateEntryResponse>(
          '/timelogger.v1.TimeEntryService/CreateEntry',
          ($0.CreateEntryRequest value) => value.writeToBuffer(),
          $0.CreateEntryResponse.fromBuffer);
  static final _$createEntries =
      $grpc.ClientMethod<$0.CreateEntriesRequest, $0.CreateEntriesResponse>(
          '/timelogger.v1.TimeEntryService/CreateEntries',
          ($0.CreateEntriesRequest value) => value.writeToBuffer(),
          $0.CreateEntriesResponse.fromBuffer);
  static final _$listEntries =
      $grpc.ClientMethod<$0.ListEntriesRequest, $0.ListEntriesResponse>(
          '/timelogger.v1.TimeEntryService/ListEntries',
          ($0.ListEntriesRequest value) => value.writeToBuffer(),
          $0.ListEntriesResponse.fromBuffer);
  static final _$getEntry =
      $grpc.ClientMethod<$0.GetEntryRequest, $0.GetEntryResponse>(
          '/timelogger.v1.TimeEntryService/GetEntry',
          ($0.GetEntryRequest value) => value.writeToBuffer(),
          $0.GetEntryResponse.fromBuffer);
  static final _$updateEntry =
      $grpc.ClientMethod<$0.UpdateEntryRequest, $0.UpdateEntryResponse>(
          '/timelogger.v1.TimeEntryService/UpdateEntry',
          ($0.UpdateEntryRequest value) => value.writeToBuffer(),
          $0.UpdateEntryResponse.fromBuffer);
  static final _$deleteEntry =
      $grpc.ClientMethod<$0.DeleteEntryRequest, $0.DeleteEntryResponse>(
          '/timelogger.v1.TimeEntryService/DeleteEntry',
          ($0.DeleteEntryRequest value) => value.writeToBuffer(),
          $0.DeleteEntryResponse.fromBuffer);
  static final _$copyEntries =
      $grpc.ClientMethod<$0.CopyEntriesRequest, $0.CopyEntriesResponse>(
          '/timelogger.v1.TimeEntryService/CopyEntries',
          ($0.CopyEntriesRequest value) => value.writeToBuffer(),
          $0.CopyEntriesResponse.fromBuffer);
}

@$pb.GrpcServiceName('timelogger.v1.TimeEntryService')
abstract class TimeEntryServiceBase extends $grpc.Service {
  $core.String get $name => 'timelogger.v1.TimeEntryService';

  TimeEntryServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.CreateEntryRequest, $0.CreateEntryResponse>(
            'CreateEntry',
            createEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateEntryRequest.fromBuffer(value),
            ($0.CreateEntryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateEntriesRequest, $0.CreateEntriesResponse>(
            'CreateEntries',
            createEntries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateEntriesRequest.fromBuffer(value),
            ($0.CreateEntriesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListEntriesRequest, $0.ListEntriesResponse>(
            'ListEntries',
            listEntries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListEntriesRequest.fromBuffer(value),
            ($0.ListEntriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetEntryRequest, $0.GetEntryResponse>(
        'GetEntry',
        getEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetEntryRequest.fromBuffer(value),
        ($0.GetEntryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateEntryRequest, $0.UpdateEntryResponse>(
            'UpdateEntry',
            updateEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateEntryRequest.fromBuffer(value),
            ($0.UpdateEntryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteEntryRequest, $0.DeleteEntryResponse>(
            'DeleteEntry',
            deleteEntry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteEntryRequest.fromBuffer(value),
            ($0.DeleteEntryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CopyEntriesRequest, $0.CopyEntriesResponse>(
            'CopyEntries',
            copyEntries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CopyEntriesRequest.fromBuffer(value),
            ($0.CopyEntriesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateEntryResponse> createEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateEntryRequest> $request) async {
    return createEntry($call, await $request);
  }

  $async.Future<$0.CreateEntryResponse> createEntry(
      $grpc.ServiceCall call, $0.CreateEntryRequest request);

  $async.Future<$0.CreateEntriesResponse> createEntries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateEntriesRequest> $request) async {
    return createEntries($call, await $request);
  }

  $async.Future<$0.CreateEntriesResponse> createEntries(
      $grpc.ServiceCall call, $0.CreateEntriesRequest request);

  $async.Future<$0.ListEntriesResponse> listEntries_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListEntriesRequest> $request) async {
    return listEntries($call, await $request);
  }

  $async.Future<$0.ListEntriesResponse> listEntries(
      $grpc.ServiceCall call, $0.ListEntriesRequest request);

  $async.Future<$0.GetEntryResponse> getEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetEntryRequest> $request) async {
    return getEntry($call, await $request);
  }

  $async.Future<$0.GetEntryResponse> getEntry(
      $grpc.ServiceCall call, $0.GetEntryRequest request);

  $async.Future<$0.UpdateEntryResponse> updateEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateEntryRequest> $request) async {
    return updateEntry($call, await $request);
  }

  $async.Future<$0.UpdateEntryResponse> updateEntry(
      $grpc.ServiceCall call, $0.UpdateEntryRequest request);

  $async.Future<$0.DeleteEntryResponse> deleteEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteEntryRequest> $request) async {
    return deleteEntry($call, await $request);
  }

  $async.Future<$0.DeleteEntryResponse> deleteEntry(
      $grpc.ServiceCall call, $0.DeleteEntryRequest request);

  $async.Future<$0.CopyEntriesResponse> copyEntries_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CopyEntriesRequest> $request) async {
    return copyEntries($call, await $request);
  }

  $async.Future<$0.CopyEntriesResponse> copyEntries(
      $grpc.ServiceCall call, $0.CopyEntriesRequest request);
}
