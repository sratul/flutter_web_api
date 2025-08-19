import 'package:flutter_web_api/comment.dart';

class Post {
  final int? id;
  final String title;
  final String body;
  final String userId;
  int likeCount;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.likeCount,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> parsedComments = [];

    if (json['comments'] != null) {
      if (json['comments'] is List) {
        parsedComments = (json['comments'] as List)
            .map((item) => Comment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (json['comments'] is Map) {
        final commentsMap = json['comments'] as Map<String, dynamic>;
        parsedComments = commentsMap.entries
            .map(
              (entry) => Comment.fromJson(entry.value as Map<String, dynamic>),
            )
            .toList();
      }
    }
    return Post(
      id: json['id'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as String,
      likeCount: json['likeCount'] ?? 0,
      comments: parsedComments,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'userId': userId,
    'likeCount': likeCount,
    'comments': comments.map((x) => x.toJson()).toList(),
  };
}
