import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  SupabaseClient? _client;
  bool _isInitialized = false;

  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load .env from assets for web, or from root for other platforms
      await dotenv.load(fileName: '.env');

      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (url == null || anonKey == null) {
        throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env',
        );
      }

      await Supabase.initialize(url: url, anonKey: anonKey);
      _client = Supabase.instance.client;
      _isInitialized = true;

      if (kDebugMode) {
        print('Supabase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Supabase initialization error: $e');
      }
      rethrow;
    }
  }
}
