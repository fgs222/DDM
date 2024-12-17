class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromData({required String id, required String email, required String name}) {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }
}
