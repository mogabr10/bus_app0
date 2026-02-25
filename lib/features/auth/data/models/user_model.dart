import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.email,
    this.avatarUrl,
    this.token,
  });

  final String id;
  final String name;
  final String phone;
  final String role;
  final String? email;
  final String? avatarUrl;
  final String? token;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      token: json['token'] as String?,
    );
  }

  factory UserModel.fromSupabaseUser(supabase.User user) {
    final userMetadata = user.userMetadata ?? {};
    return UserModel(
      id: user.id,
      name: userMetadata['full_name'] as String? ?? '',
      phone: userMetadata['phone'] as String? ?? '',
      role: userMetadata['role'] as String? ?? 'parent',
      email: user.email,
      avatarUrl: userMetadata['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'role': role,
    'email': email,
    'avatar_url': avatarUrl,
  };

  User toEntity() => User(
    id: id,
    name: name,
    phone: phone,
    role: UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.parent,
    ),
    email: email,
    avatarUrl: avatarUrl,
  );
}
