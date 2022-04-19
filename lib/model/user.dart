class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'] as String, email: json['email'] as String);
  }
}
