class Comment {
  int? id;
  String body;
  String userId;
  int postId;

  Comment({
    required this.id,
    required this.body,
    required this.userId,
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] as int?,
    body: json['body'] as String,
    userId: json['userId'] as String,
    postId: json['postId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'body': body,
    'userId': userId,
    'postId': postId,
  };
}
