import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
      return AuthStateNotifier(ref.watch(authRepositoryProvider));
    });

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthStateNotifier(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? schoolName,
    String? relationship,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
        schoolName: schoolName,
        relationship: relationship,
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.login(email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> checkAuth() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getCurrentUser());
  }
}
