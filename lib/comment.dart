class Comment {
  final int? id;
  final String body;
  final String userId;
  final int? postId;
  final DateTime? createdAt;

  Comment({
    required this.id,
    required this.body,
    required this.userId,
    this.postId,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] as int?,
    body: json['body'] as String,
    userId: json['userId'] as String,
    postId: json['postId'] as int?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'body': body,
    'userId': userId,
    'postId': postId,
  };
}
