import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource() {
    if (!SupabaseService.instance.isInitialized) {
      throw Exception(
        'Supabase is not initialized. Please initialize Supabase first.',
      );
    }
    _client = SupabaseService.instance.client;
  }

  late final SupabaseClient _client;

  Stream<User?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      return event.session?.user;
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? schoolName,
    String? relationship,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': role,
        if (phone != null) 'phone': phone,
        if (schoolName != null) 'school_name': schoolName,
        if (relationship != null) 'relationship': relationship,
      },
    );

    if (response.user == null) {
      throw Exception('Sign up failed: No user returned');
    }

    return UserModel.fromSupabaseUser(response.user!);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed: No user returned');
    }

    return UserModel.fromSupabaseUser(response.user!);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }
}
