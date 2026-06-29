/// Backend configuration values.
///
/// These are set at build time using `--dart-define` flags, e.g.:
///   flutter build apk --dart-define=POCKETBASE_URL=https://pb.example.com
///   flutter build apk --dart-define=API_BASE_URL=https://api.example.com
///   flutter build apk --dart-define=APP_ENV=production
class BackendConfig {
  static const pocketBaseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'http://127.0.0.1:8095',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => appEnv == 'development';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProduction => appEnv == 'production';
}
