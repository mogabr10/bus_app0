import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? schoolName,
    String? relationship,
  });
  Future<User> login({required String email, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
