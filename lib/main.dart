import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: BusApp()));
}

class BusApp extends ConsumerStatefulWidget {
  const BusApp({super.key});

  @override
  ConsumerState<BusApp> createState() => _BusAppState();
}

class _BusAppState extends ConsumerState<BusApp> {
  bool _isSupabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    try {
      await SupabaseService.instance.initialize();
      if (mounted) {
        setState(() {
          _isSupabaseInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'حافلة المدرسة',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(goRouterProvider),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      debugShowCheckedModeBanner: false,
    );
  }
}
