import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_api/comment.dart';
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
      print('${response.statusCode} Failed to create post: ${response.body}');
      return null;
    }
  }

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUri));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> body;

      if (decoded is Map<String, dynamic> && decoded.containsKey(r'$values')) {
        // Extract the list from the $values key
        body = decoded[r'$values'] as List<dynamic>;
      } else if (decoded is List<dynamic>) {
        body = decoded;
      } else {
        throw Exception('Unexpected JSON format');
      }

      for (var item in body) {
        print('Post comments field: ${item['comments']}');
      }

      List<Post> posts = body
          .map((dynamic item) => Post.fromJson(item as Map<String, dynamic>))
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

    print('${response.statusCode}');
    return response.statusCode == 204;
  }

  Future<bool> deleteComment(int postId, int commentId) async {
    final token = await  

    return false;
  }

  Future<bool> sendForgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$baseUri/auth/forgotpassword"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }

  Future<int?> likePost(int postId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse('$baseUri/$postId/like'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("${response.statusCode}");
      final data = jsonDecode(response.body);
      // API return: {likecount}

      return data['likeCount'] as int;
    }

    return null;
  }

  String? getUserIdFromToken(String? token) {
    if (token == null) return null;

    final parts = token.split('.');
    if (parts.length != 3) {
      // Invalid token
      return null;
    }

    final payload = parts[1];

    // Base64 decode (handle padding)
    String normalized = base64.normalize(payload);
    final payloadMap = json.decode(utf8.decode(base64Url.decode(normalized)));

    if (payloadMap is! Map<String, dynamic>) return null;

    // Usually user id is in 'sub' claim or sometimes 'userId'
    return payloadMap['sub'] ?? payloadMap['userId'];
  }

  Future<Comment?> postComment(Post post, String commentBody) async {
    print('Comment Started');
    final token = await secureStorage.read(key: 'jwt_token');

    final userId = getUserIdFromToken(token);

    final response = await http.post(
      Uri.parse('$baseUri/${post.id}/comments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        'body': commentBody,
        'postId': post.id,
        'userId': userId,
        // 'post': post,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Comment 200');
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        print(
          'Error response from API: ${errorBody['message'] ?? response.body}',
        );
      } catch (e) {
        print('Error parsing response body: $e');
        print('Raw response: ${response.body}');
      }
    }
    print('Comment statuscode:${response.statusCode}');
    return null;

    print('Comment Ended');
  }
}
