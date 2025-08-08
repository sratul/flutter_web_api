class User {
  final int userId;

  final String name;

  final String email;

  // Primary constructor with required named parameters

  const User({required this.userId, required this.name, required this.email});

  // Named constructor for creating an 'empty' User, with default values
  const User.empty({this.userId = 0, this.name = '', this.email = ''});

  // Factory constructor to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) =>
      User(userId: json['userId'], name: json['name'], email: json['email']);

  // Convert a User instance into a JSON map
  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
  };
}
