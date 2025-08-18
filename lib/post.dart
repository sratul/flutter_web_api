class Post {
  final int? id;
  final String title;
  final String body;
  final String userId;
  int likeCount;
  // final List<String> comments;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.likeCount,
    // required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    userId: json['userId'],
    likeCount: json['likeCount'] ?? 0,
    // comments: json['comments'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'userId': userId,
  };
}
