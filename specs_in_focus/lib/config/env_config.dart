import 'dart:io';
import 'package:flutter/foundation.dart';

/// Environment Configuration for the app
/// This class centralizes all environment-specific configuration
class EnvConfig {
  /// Singleton instance
  static final EnvConfig _instance = EnvConfig._internal();

  /// Factory constructor to return the singleton instance
  factory EnvConfig() => _instance;

  /// Private constructor
  EnvConfig._internal();

  /// API URL based on platform and environment
  String get apiBaseUrl {
    if (kDebugMode) {
      // Debug mode (development)
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000/api'; // Android emulator
      } else if (Platform.isIOS) {
        return 'http://localhost:5000/api'; // iOS simulator
      } else {
        return 'http://localhost:5000/api'; // Web or desktop
      }
    } else {
      // Release mode (production)
      // Replace with actual production API URL when deployed
      return 'https://specs-in-focus-api.example.com/api';
    }
  }

  /// Auth token key for shared preferences
  String get authTokenKey => 'auth_token';

  /// User ID key for shared preferences
  String get userIdKey => 'user_id';

  /// App name
  String get appName => 'Specs In Focus';
}
