import 'dart:async';

import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  AuthRemoteDatasource? _remoteDatasource;

  AuthRemoteDatasource get _remote {
    if (_remoteDatasource == null) {
      _remoteDatasource = AuthRemoteDatasource();
    }
    return _remoteDatasource!;
  }

  @override
  Stream<User?> get authStateChanges {
    return _remote.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user).toEntity();
    });
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? schoolName,
    String? relationship,
  }) async {
    final model = await _remote.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
      phone: phone,
      schoolName: schoolName,
      relationship: relationship,
    );
    return model.toEntity();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final model = await _remote.login(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = _remote.getCurrentUser();
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user).toEntity();
  }
}
