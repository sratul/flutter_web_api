import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'post.dart';

class PostService {
  final String baseUri =
      "https://localhost:7075/api/posts"; // Adjust based on your backend URL
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Post?> createPost(String title, String body) async {
    final token = await secureStorage.read(key: 'jwt_token');

    final response = await http.post(
      Uri.parse(baseUri),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'body': body}),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to create post: ${response.body}');
      return null;
    }
  }

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUri));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Post> posts = body
          .map((dynamic item) => Post.fromJson(item))
          .toList();

      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<bool> updatePost(int id, String title, String body) async {
    final token = await secureStorage.read(key: 'jwt_token');

    final response = await http.put(
      Uri.parse('$baseUri/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'body': body}),
    );

    return response.statusCode == 204; //noncontent on success
  }
  // deletePost() etc

  Future<bool> deletePost(int id) async {
    final token = await secureStorage.read(key: 'jwt_token');
    final response = await http.delete(
      Uri.parse('$baseUri/$id'),
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 204;
  }

  Future<bool> sendForgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$baseUri/auth/forgotpassword"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }
}
