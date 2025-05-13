import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for API
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // Headers
  static Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

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
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    // Save token if login successful
    if (response.statusCode == 200 && data['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['data']['token']);
      prefs.setString('userId', data['data']['id']);
    }

    return data;
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _getHeaders(),
    );

    return jsonDecode(response.body);
  }

  // Update user
  static Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: await _getHeaders(),
      body: jsonEncode(userData),
    );

    return jsonDecode(response.body);
  }

  // Logout user
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
  }
}
