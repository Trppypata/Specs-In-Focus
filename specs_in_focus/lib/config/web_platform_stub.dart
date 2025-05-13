import 'dart:convert';
import 'dart:html' as html;
import 'dart:async';
import 'package:http/http.dart' as http;

/// This class serves as a stub implementation of the Platform class for web platforms
/// since dart:io is not available in web contexts
class Platform {
  /// Always returns false on web
  static bool get isAndroid => false;

  /// Always returns false on web
  static bool get isIOS => false;

  /// Always returns false on web
  static bool get isMacOS => false;

  /// Always returns false on web
  static bool get isWindows => false;

  /// Always returns false on web
  static bool get isLinux => false;

  /// Always returns false on web
  static bool get isFuchsia => false;

  /// Returns 'web' on web platforms
  static String get operatingSystem => 'web';
}

/// A simplified HTTP client for web platforms
class WebHttpClient {
  /// Performs a POST request on web platforms
  static Future<http.Response> post(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      // For web, fallback to using standard http package
      // but with proper CORS handling
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      return response;
    } catch (e) {
      // Return a response with error details
      return http.Response(
        jsonEncode({
          'success': false,
          'message': 'Request failed: $e',
        }), 
        500,
      );
    }
  }
}
