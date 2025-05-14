import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specs_in_focus/models/glasses_model.dart';
import 'package:specs_in_focus/config/env_config.dart';
import 'dart:io' if (dart.library.html) 'package:specs_in_focus/config/web_platform_stub.dart';

class ApiService {
  // Environment configuration
  final EnvConfig _config = EnvConfig();
  
  // Cache for glasses data
  List<Glasses>? _cachedGlasses;
  DateTime? _lastCacheTime;
  final Duration _cacheExpiration = const Duration(minutes: 10);

  // Get base URL from environment config
  String get baseUrl => _config.apiBaseUrl;

  // Headers with optimized implementation
  Map<String, String>? _cachedHeaders;
  Future<Map<String, String>> _getHeaders() async {
    if (_cachedHeaders != null) return _cachedHeaders!;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_config.authTokenKey);

    if (token != null) {
      _cachedHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      _cachedHeaders = {
        'Content-Type': 'application/json',
      };
    }
    
    return _cachedHeaders!;
  }
  
  // Clear cached headers when logging out
  void _clearCachedHeaders() {
    _cachedHeaders = null;
  }

  // Register user - optimized
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
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(),
        body: jsonEncode(requestBody),
      );

      if (response.statusCode >= 400) {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  // Login user - optimized
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      // Save token if login successful
      if (response.statusCode == 200 && responseData['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Access token and id from the nested data object
        final userData = responseData['data'];
        if (userData != null) {
          prefs.setString(_config.authTokenKey, userData['token']);
          prefs.setString(_config.userIdKey, userData['id']);
          // Clear cached headers to force refresh with new token
          _clearCachedHeaders();
        }
      }

      return responseData;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
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

  // Logout user - optimized
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_config.authTokenKey);
    await prefs.remove(_config.userIdKey);
    _clearCachedHeaders();
    _cachedGlasses = null;
  }

  // Get all glasses - with caching
  Future<List<Glasses>> getAllGlasses() async {
    // Return cached data if available and not expired
    if (_cachedGlasses != null && _lastCacheTime != null) {
      final now = DateTime.now();
      if (now.difference(_lastCacheTime!) < _cacheExpiration) {
        return _cachedGlasses!;
      }
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/glasses'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _cachedGlasses = data.map((json) => Glasses.fromJson(json)).toList();
        _lastCacheTime = DateTime.now();
        return _cachedGlasses!;
      } else {
        // Return local data as fallback if API fails
        return GlassesRepository.getAllGlasses();
      }
    } catch (e) {
      // Return local data as fallback
      return GlassesRepository.getAllGlasses();
    }
  }

  // Get glasses by face shape - optimized
  Future<List<Glasses>> getGlassesByFaceShape(String faceShape) async {
    try {
      // If we already have cached glasses, filter them instead of making a new request
      if (_cachedGlasses != null && _lastCacheTime != null) {
        final now = DateTime.now();
        if (now.difference(_lastCacheTime!) < _cacheExpiration) {
          return _cachedGlasses!
              .where((glasses) =>
                  glasses.faceShapeRecommendations
                      ?.contains(faceShape.toLowerCase()) ??
                  false)
              .toList();
        }
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/glasses/face-shape/$faceShape'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Glasses.fromJson(json)).toList();
      } else {
        // Filter local data as fallback
        return GlassesRepository.getAllGlasses()
            .where((glasses) =>
                glasses.faceShapeRecommendations
                    ?.contains(faceShape.toLowerCase()) ??
                false)
            .toList();
      }
    } catch (e) {
      // Filter local data as fallback
      return GlassesRepository.getAllGlasses()
          .where((glasses) =>
              glasses.faceShapeRecommendations
                  ?.contains(faceShape.toLowerCase()) ??
              false)
          .toList();
    }
  }

  // Seed sample data - optimized to not block UI
  Future<bool> seedSampleData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/seed'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
