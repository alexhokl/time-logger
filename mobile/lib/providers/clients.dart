import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_helper/grpc.dart';
import 'package:grpc/grpc.dart';
import 'package:sqflite/sqflite.dart';

import '../config/app_config.dart';
import '../data/catalog_repository.dart';
import '../data/local_database.dart';
import '../data/pending_entry_repository.dart';
import '../proto/timelogger/v1/entry.pbgrpc.dart';
import '../proto/timelogger/v1/goal.pbgrpc.dart';
import '../proto/timelogger/v1/project.pbgrpc.dart';
import '../proto/timelogger/v1/report.pbgrpc.dart';
import '../proto/timelogger/v1/settings.pbgrpc.dart';
import '../proto/timelogger/v1/tag.pbgrpc.dart';
import '../proto/timelogger/v1/task.pbgrpc.dart';
import '../proto/timelogger/v1/timer.pbgrpc.dart';

/// Holds the current connection settings.
///
/// Everything that talks to the server is derived from this, so changing the
/// host on the settings page tears down the old channel and rebuilds every
/// client automatically rather than requiring a restart.
class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() => AppConfig.initial;

  Future<void> loadFromDisk() async {
    state = await AppConfig.load();
  }

  Future<void> update(AppConfig config) async {
    await config.save();
    state = config;
  }
}

final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(
  AppConfigNotifier.new,
);

/// The gRPC channel.
///
/// The channel is disposed when the configuration changes so that sockets
/// opened against the previous host are not leaked. Riverpod's onDispose is
/// what makes that automatic.
final channelProvider = Provider<ClientChannel>((ref) {
  final config = ref.watch(appConfigProvider);

  final holder = GrpcChannelHolder(
    host: config.host,
    port: config.port,
    useTls: config.useTls,
  );

  ref.onDispose(holder.shutdown);
  return holder.channel;
});

// --- Service clients -------------------------------------------------------
//
// One provider per service. They are trivial, but declaring them individually
// means a widget depends only on the service it actually uses.

final projectClientProvider = Provider(
  (ref) => ProjectServiceClient(ref.watch(channelProvider)),
);
final taskClientProvider = Provider(
  (ref) => TaskServiceClient(ref.watch(channelProvider)),
);
final tagClientProvider = Provider(
  (ref) => TagServiceClient(ref.watch(channelProvider)),
);
final entryClientProvider = Provider(
  (ref) => TimeEntryServiceClient(ref.watch(channelProvider)),
);
final timerClientProvider = Provider(
  (ref) => TimerServiceClient(ref.watch(channelProvider)),
);
final goalClientProvider = Provider(
  (ref) => GoalServiceClient(ref.watch(channelProvider)),
);
final reportClientProvider = Provider(
  (ref) => ReportServiceClient(ref.watch(channelProvider)),
);
final settingsClientProvider = Provider(
  (ref) => SettingsServiceClient(ref.watch(channelProvider)),
);

// --- Local storage ---------------------------------------------------------

/// The opened SQLite database. Overridden in tests with an in-memory instance.
final databaseProvider = FutureProvider<Database>(
  (ref) => LocalDatabase.instance.database,
);

final catalogRepositoryProvider = FutureProvider<CatalogRepository>((ref) async {
  return CatalogRepository(await ref.watch(databaseProvider.future));
});

final pendingEntryRepositoryProvider = FutureProvider<PendingEntryRepository>((
  ref,
) async {
  return PendingEntryRepository(await ref.watch(databaseProvider.future));
});
