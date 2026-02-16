/// Environment configuration for HavenApp
/// 
/// Switch between development, staging, and production environments
/// by setting the APP_ENVIRONMENT variable at build time.
/// 
/// Example: flutter run --dart-define=APP_ENVIRONMENT=production

enum Environment { development, staging, production }

class Config {
  static const Environment _environment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'development',
  ) == 'production'
      ? Environment.production
      : String.fromEnvironment('APP_ENVIRONMENT', defaultValue: 'development') ==
              'staging'
          ? Environment.staging
          : Environment.development;

  /// API Base URL based on environment
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.production:
        // Replace with your actual production domain
        return 'https://api.havenapp.com/api';
      case Environment.staging:
        // Replace with your staging domain
        return 'https://staging-api.havenapp.com/api';
      case Environment.development:
      default:
        return 'http://localhost:5000/api';
    }
  }

  /// Get environment name for logging
  static String get environmentName {
    switch (_environment) {
      case Environment.production:
        return 'Production';
      case Environment.staging:
        return 'Staging';
      case Environment.development:
      default:
        return 'Development';
    }
  }

  /// Whether in debug mode
  static bool get isDebug {
    return _environment == Environment.development;
  }

  /// Timeout duration for API requests
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Max retry attempts for failed requests
  static const int maxRetries = 3;

  /// Enable request/response logging
  static bool get enableLogging {
    return _environment == Environment.development;
  }
}
