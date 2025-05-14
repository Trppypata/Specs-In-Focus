import 'dart:io';
import 'package:http/http.dart' as http;

/// A stub class that mirrors the WebHttpClient API for non-web platforms
/// This just delegates to the regular http package
class WebHttpClient {
  /// Performs a regular HTTP POST request on non-web platforms
  static Future<http.Response> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }
}
