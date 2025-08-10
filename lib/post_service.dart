import 'dart:convert';

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

  // Future<List<Post>> getPosts() async {
  //   final response = await http.get(Uri.parse(baseUri));
  // }

  // deletePost() etc
}
