/// Build-time and user-configurable application settings.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Keys used in [SharedPreferences]. Centralised so a rename cannot silently
/// orphan a stored value.
class _Keys {
  static const serviceHost = 'serviceHost';
  static const servicePort = 'servicePort';
  static const useTls = 'useTls';
  static const pageSize = 'pageSize';
}

/// Connection settings for the gRPC server.
class AppConfig {
  const AppConfig({
    required this.host,
    required this.port,
    required this.useTls,
    required this.pageSize,
  });

  /// Host name of the server. The default points at the tailnet node, which is
  /// where the app is expected to be used.
  final String host;

  final int port;

  /// Whether to use TLS. The server terminates TLS itself on the tailnet, so
  /// this is on by default and only turned off to reach a local development
  /// server.
  final bool useTls;

  /// How many entries to request per page.
  final int pageSize;

  static const defaultHost = 'time-logger.some-name.ts.net';
  static const defaultPort = 443;
  static const defaultPageSize = 50;

  /// The short git commit the app was built from, injected at build time with
  /// `--dart-define=GIT_COMMIT=...`. Shown on the settings page so a bug report
  /// can be tied to an exact build.
  static const gitCommit = String.fromEnvironment(
    'GIT_COMMIT',
    defaultValue: 'dev',
  );

  static const initial = AppConfig(
    host: defaultHost,
    port: defaultPort,
    useTls: true,
    pageSize: defaultPageSize,
  );

  AppConfig copyWith({String? host, int? port, bool? useTls, int? pageSize}) {
    return AppConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      useTls: useTls ?? this.useTls,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  static Future<AppConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppConfig(
      host: prefs.getString(_Keys.serviceHost) ?? defaultHost,
      port: prefs.getInt(_Keys.servicePort) ?? defaultPort,
      useTls: prefs.getBool(_Keys.useTls) ?? true,
      pageSize: prefs.getInt(_Keys.pageSize) ?? defaultPageSize,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_Keys.serviceHost, host);
    await prefs.setInt(_Keys.servicePort, port);
    await prefs.setBool(_Keys.useTls, useTls);
    await prefs.setInt(_Keys.pageSize, pageSize);
  }

  @override
  bool operator ==(Object other) =>
      other is AppConfig &&
      other.host == host &&
      other.port == port &&
      other.useTls == useTls &&
      other.pageSize == pageSize;

  @override
  int get hashCode => Object.hash(host, port, useTls, pageSize);
}
