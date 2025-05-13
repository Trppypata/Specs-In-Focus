import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specs_in_focus/models/glasses_model.dart';
import 'package:specs_in_focus/config/env_config.dart';
import 'package:specs_in_focus/config/web_platform_stub.dart'
    if (dart.library.io) 'package:specs_in_focus/config/io_platform_stub.dart';

class ApiService {
  // Environment configuration
  final EnvConfig _config = EnvConfig();

  // Get base URL from environment config
  String get baseUrl => _config.apiBaseUrl;

  // Headers
  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_config.authTokenKey);

    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }

    return {
      'Content-Type': 'application/json',
    };
  }

  // Register user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      final requestBody = {
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
      };

      print('Sending registration request to: $baseUrl/auth/register');
      print('Request body: ${jsonEncode(requestBody)}');

      http.Response response;

      // Use the appropriate HTTP client based on platform
      if (kIsWeb) {
        // Use the web-specific HTTP client on web platforms
        response = await WebHttpClient.post(
          '$baseUrl/auth/register',
          headers: await _getHeaders(),
          body: jsonEncode(requestBody),
        );
      } else {
        // Use the standard HTTP client on non-web platforms
        response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          headers: await _getHeaders(),
          body: jsonEncode(requestBody),
        );
      }

      print('Registration response status code: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      print('Registration error: $e');
      // Provide more detailed error info to help debugging
      String errorDetails = e.toString();
      if (e is http.ClientException) {
        errorDetails =
            'Network error: ${e.message}. This might be due to CORS or server connectivity issues.';
      }

      return {
        'success': false,
        'message': 'Connection error: $errorDetails',
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = {
        'email': email,
        'password': password,
      };

      print('Sending login request to: $baseUrl/auth/login');
      print('Request body: ${jsonEncode(requestBody)}');

      http.Response response;

      // Use the appropriate HTTP client based on platform
      if (kIsWeb) {
        // Use the web-specific HTTP client on web platforms
        response = await WebHttpClient.post(
          '$baseUrl/auth/login',
          headers: await _getHeaders(),
          body: jsonEncode(requestBody),
        );
      } else {
        // Use the standard HTTP client on non-web platforms
        response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: await _getHeaders(),
          body: jsonEncode(requestBody),
        );
      }

      print('Login response status code: ${response.statusCode}');
      print('Login response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      // Save token if login successful
      if (response.statusCode == 200 && responseData['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Access token and id from the nested data object
        final userData = responseData['data'];
        if (userData != null) {
          print('User data: $userData'); // Debug print
          prefs.setString(_config.authTokenKey, userData['token']);
          prefs.setString(_config.userIdKey, userData['id']);
        }
      }

      return responseData;
    } catch (e) {
      print('Login error: $e');
      // Provide more detailed error info to help debugging
      String errorDetails = e.toString();
      if (e is http.ClientException) {
        errorDetails =
            'Network error: ${e.message}. This might be due to CORS or server connectivity issues.';
      }

      return {
        'success': false,
        'message': 'Connection error: $errorDetails',
      };
    }
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _getHeaders(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Get user error: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // Update user
  Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Update user error: $e');
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // Logout user
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_config.authTokenKey);
    prefs.remove(_config.userIdKey);
  }

  // Get all glasses
  Future<List<Glasses>> getAllGlasses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/glasses'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Glasses.fromJson(json)).toList();
      } else {
        print('Failed to load glasses: ${response.statusCode}');
        // Return local data as fallback if API fails
        return GlassesRepository.getAllGlasses();
      }
    } catch (e) {
      print('Error fetching glasses: $e');
      // Return local data as fallback
      return GlassesRepository.getAllGlasses();
    }
  }

  // Get glasses by face shape
  Future<List<Glasses>> getGlassesByFaceShape(String faceShape) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/glasses/face-shape/$faceShape'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Glasses.fromJson(json)).toList();
      } else {
        print('Failed to load glasses by face shape: ${response.statusCode}');
        // Filter local data as fallback
        return GlassesRepository.getAllGlasses()
            .where((glasses) =>
                glasses.faceShapeRecommendations
                    ?.contains(faceShape.toLowerCase()) ??
                false)
            .toList();
      }
    } catch (e) {
      print('Error fetching glasses by face shape: $e');
      // Filter local data as fallback
      return GlassesRepository.getAllGlasses()
          .where((glasses) =>
              glasses.faceShapeRecommendations
                  ?.contains(faceShape.toLowerCase()) ??
              false)
          .toList();
    }
  }

  // Seed sample data
  Future<bool> seedSampleData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/seed'));

      if (response.statusCode == 200) {
        print('Sample data seeded successfully');
        return true;
      } else {
        print('Failed to seed sample data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error seeding sample data: $e');
      return false;
    }
  }
}
