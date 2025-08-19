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

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    userId: json['userId'],
    likeCount: json['likeCount'] ?? 0,
    comments: json['comments'] != null
        ? List<Comment>.from(
            (json['comments'] as List<dynamic>).map(
              (x) => Comment.fromJson(x as Map<String, dynamic>),
            ),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'userId': userId,
    'comments': comments.map((x) => x.toJson()).toList(),
  };
}
