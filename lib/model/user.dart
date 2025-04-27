class User {
  final int id;
  final String name;
  final UserType type;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.type,
    this.imageUrl,
  });
}

enum UserType { coach, client }
