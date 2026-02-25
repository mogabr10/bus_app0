import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Splash screen shown on app cold start.
///
/// Displays an animated logo with fade-in effect and automatically
/// navigates to the appropriate screen after a 3-second delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startNavigationTimer();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    context.go(RoutePaths.login);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.splashGradientDark
              : AppColors.splashGradientLight,
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  _buildLogo(isDark),
                  const SizedBox(height: AppSpacing.xl),
                  // App Name
                  _buildAppName(brightness),
                  const SizedBox(height: AppSpacing.sm),
                  // Tagline
                  _buildTagline(brightness),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: AppSpacing.avatarXl,
      height: AppSpacing.avatarXl,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: AppSpacing.elevationXl,
            spreadRadius: AppSpacing.elevationSm,
          ),
        ],
      ),
      child: Icon(
        Icons.directions_bus_rounded,
        size: AppSpacing.iconXl,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildAppName(Brightness brightness) {
    return Text(
      'School Bus',
      style: AppTextStyles.displayLarge.copyWith(
        color: brightness == Brightness.light
            ? AppColors.textMainLight
            : AppColors.textMainDark,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTagline(Brightness brightness) {
    return Text(
      'Safe rides for your children',
      style: AppTextStyles.bodyMedium.copyWith(
        color: brightness == Brightness.light
            ? AppColors.textSubLight
            : AppColors.textSubDark,
      ),
    );
  }
}
