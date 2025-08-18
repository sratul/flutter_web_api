class Comment {
  int id;
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
    id: json['id'],
    body: json['body'],
    userId: json['userId'],
    postId: json['postId'],
  );
}
