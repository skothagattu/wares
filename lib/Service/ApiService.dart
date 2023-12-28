import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = "https://localhost:44363/api/";
  VoidCallback? onLogout;

  ApiService({this.onLogout});

  Future<http.Response> _handleResponse(http.Response response) async {
    final prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 401) {
      // Token is expired or invalid
      await prefs.remove('token');
      await prefs.remove('roles');
      onLogout?.call();
    }
    return response;
  }
  Future<http.Response> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return await http.post(
      Uri.parse('$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
  }

  Future<http.Response> put(String endpoint, dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    print(prefs);
    return await http.put(
      Uri.parse('$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
  }
  Future<http.Response> delete(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

// Add delete method as needed
}
