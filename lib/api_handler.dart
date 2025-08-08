import 'dart:convert'; // Needed for json.encode and json.decode

import 'package:flutter_web_api/model.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUri = "https://localhost:7075/api/Users";

  /// Fetches the list of all users from the API

  Future<List<User>> getUserData() async {
    List<User> data = [];

    final uri = Uri.parse(baseUri);

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
          // notify the server that the body is a JSON string with UTF-8 encoding — which is expected and commonly used in REST APIs
        },
      );

      // Check for HTTP success status
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);

        data = jsonData.map((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }
    return data;
  }

  /// Updates the user with [userId] on the API

  Future<http.Response> updateUser({
    required int userId,
    required User user,
  }) async {
    final uri = Uri.parse("$baseUri/$userId");
    // example https://localhost:7075/api/Users/5
    // where userId = 5

    late http.Response response;

    try {
      response = await http.put(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      );
    } catch (e) {
      return response;
    }
    return response;
  }

  // function to add User
  // uses named parameter User
  Future<http.Response?> addUser({required User user}) async {
    final uri = Uri.parse(baseUri);
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      );
    } catch (e) {
      return response;
    }

    return null;
  }

  Future<http.Response?> deleteUser({required int userId}) async {
    final uri = Uri.parse("$baseUri/$userId");

    late http.Response response;

    try {
      response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      return response;
    }

    return null;
  }

  Future<User> getUserById({required int userId}) async {
    final uri = Uri.parse("$baseUri/$userId");
    User? user;

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        user = User.fromJson(jsonData);
      }
    } catch (e) {
      return user!;
    }
    return user!;
  }
}
