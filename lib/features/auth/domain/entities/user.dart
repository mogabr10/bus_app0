/// User entity — pure domain object, no serialization.
class User {
  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.email,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final String? email;
  final String? avatarUrl;
}

enum UserRole { parent, supervisor, driver, admin }
