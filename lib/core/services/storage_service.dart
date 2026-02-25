import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for local key-value storage.
class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Keys ───────────────────────────────────────────────────────────
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserRole = 'user_role';
  static const String _keyOnboarded = 'onboarded';
  static const String _keyThemeMode = 'theme_mode';

  // ── Auth ───────────────────────────────────────────────────────────
  String? get authToken => _prefs.getString(_keyAuthToken);
  Future<bool> setAuthToken(String token) =>
      _prefs.setString(_keyAuthToken, token);
  Future<bool> clearAuthToken() => _prefs.remove(_keyAuthToken);

  // ── User Role ─────────────────────────────────────────────────────
  String? get userRole => _prefs.getString(_keyUserRole);
  Future<bool> setUserRole(String role) =>
      _prefs.setString(_keyUserRole, role);

  // ── Onboarding ────────────────────────────────────────────────────
  bool get hasOnboarded => _prefs.getBool(_keyOnboarded) ?? false;
  Future<bool> setOnboarded(bool value) =>
      _prefs.setBool(_keyOnboarded, value);

  // ── Theme ─────────────────────────────────────────────────────────
  String? get themeMode => _prefs.getString(_keyThemeMode);
  Future<bool> setThemeMode(String mode) =>
      _prefs.setString(_keyThemeMode, mode);

  // ── Clear All ─────────────────────────────────────────────────────
  Future<bool> clearAll() => _prefs.clear();
}
