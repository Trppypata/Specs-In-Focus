import 'dart:io'
    if (dart.library.html) 'package:specs_in_focus/config/web_platform_stub.dart';
import 'package:flutter/foundation.dart';

/// Environment Configuration for the app
/// This class centralizes all environment-specific configuration
class EnvConfig {
  /// Singleton instance
  static final EnvConfig _instance = EnvConfig._internal();

  /// Factory constructor to return the singleton instance
  factory EnvConfig() => _instance;

  // Cache the API base URL
  String? _apiBaseUrl;

  /// Private constructor
  EnvConfig._internal() {
    // Initialize the API base URL during construction
    _initApiBaseUrl();
  }

  void _initApiBaseUrl() {
    if (kDebugMode) {
      // Debug mode (development)
      if (kIsWeb) {
        _apiBaseUrl = 'http://localhost:5000/api'; // Web
      } else if (Platform.isAndroid) {
        // Try the real IP first, if that fails (timeout), the app will try the 10.0.2.2
        _apiBaseUrl =
            'http://192.168.0.102:5000/api'; // Use your actual IP address here for physical devices
      } else if (Platform.isIOS) {
        _apiBaseUrl = 'http://localhost:5000/api'; // iOS simulator
      } else {
        _apiBaseUrl = 'http://localhost:5000/api'; // Desktop
      }
    } else {
      // Release mode (production)
      _apiBaseUrl = 'https://specs-in-focus-api.example.com/api';
    }
  }

  /// API URL based on platform and environment
  String get apiBaseUrl => _apiBaseUrl!;

  /// Auth token key for shared preferences
  String get authTokenKey => 'auth_token';

  /// User ID key for shared preferences
  String get userIdKey => 'user_id';

  /// App name
  String get appName => 'Specs In Focus';
}
