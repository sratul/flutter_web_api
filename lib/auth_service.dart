import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUri = "https://localhost:7075/api/auth";

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Login User and save token

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUri/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final token = body['token'];
      if (token != null) {
        // save token securely
        await secureStorage.write(key: "jwt_token", value: token);
        return true;
      }
    }
    return false;
  }

  // Register a new user
  Future<bool> register(String email, String password) async {
    final uri = Uri.parse('$baseUri/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Get token (for attaching in requests)
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  // Clear token on logout
  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
  }

  Future<http.Response> getProtectedData() async {
    final token = await AuthService().getToken();
    final uri = Uri.parse('https://localhost:7075/api/protected-endpoint');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}
