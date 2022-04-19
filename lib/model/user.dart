class User {
  final String id;
  final String email;
  final String accessLevel;
  User({required this.id, required this.email, required this.accessLevel});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as String,
        email: json['email'] as String,
        accessLevel: json['access_level'] as String);
  }
  bool get isAdm => accessLevel == 'ADM';
  bool get isUser => accessLevel == 'USER';
}
