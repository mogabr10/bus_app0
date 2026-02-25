import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import '../constants/app_spacing.dart';

/// Centralised theme factory for the School‑Bus app.
///
/// Produces Material 3 [ThemeData] objects for both light and dark modes,
/// wiring together [AppColors], [AppTextStyles] and [AppSpacing].
abstract final class AppTheme {
  // ───────────────────────────── Light Theme ─────────────────────────────

  static ThemeData get light {
    final colorScheme = AppColors.lightScheme;
    return _buildTheme(colorScheme, Brightness.light);
  }

  // ───────────────────────────── Dark Theme ──────────────────────────────

  static ThemeData get dark {
    final colorScheme = AppColors.darkScheme;
    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ──────────────────────────── Shared builder ────────────────────────────

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: AppTextStyles.fontFamilyDisplay,
      fontFamilyFallback: AppTextStyles.fontFamilyFallback,

      // ── Scaffold ──────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background(brightness),

      // ── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: AppSpacing.elevationNone,
        scrolledUnderElevation: AppSpacing.elevationSm,
        centerTitle: true,
        backgroundColor: AppColors.background(brightness),
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppSpacing.iconMd,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // ── Cards ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationSm,
        color: AppColors.surface(brightness),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
          side: BorderSide(
            color: AppColors.border(brightness),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button (Primary) ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryContent,
          minimumSize: const Size.fromHeight(AppSpacing.inputHeight),
          elevation: AppSpacing.elevationLg,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ── Outlined Button (Secondary) ───────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
          side: BorderSide(color: AppColors.border(brightness)),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          textStyle: AppTextStyles.buttonSmall,
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonSmall,
        ),
      ),

      // ── Input Decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface(brightness),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(color: AppColors.border(brightness)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(color: AppColors.border(brightness)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSub(brightness),
        ),
        labelStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSub(brightness),
        ),
        constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.95)
            : AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSub(brightness),
        selectedLabelStyle: AppTextStyles.micro,
        unselectedLabelStyle: AppTextStyles.micro,
        elevation: AppSpacing.elevationNone,
      ),

      // ── Navigation Bar (M3 variant) ───────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        height: AppSpacing.bottomNavHeight,
        backgroundColor: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.95)
            : AppColors.surfaceLight,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.micro.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.micro.copyWith(
            color: AppColors.textSub(brightness),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            );
          }
          return IconThemeData(
            color: AppColors.textSub(brightness),
            size: AppSpacing.iconMd,
          );
        }),
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.border(brightness),
        thickness: 1,
        space: 0,
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface(brightness),
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        side: BorderSide(color: AppColors.border(brightness)),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        labelStyle: AppTextStyles.labelMedium,
      ),

      // ── Progress Indicator ────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Color(0x33000000),
        linearMinHeight: AppSpacing.progressBarHeight,
      ),

      // ── Dialog ────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface(brightness),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSub(brightness),
        ),
      ),

      // ── SnackBar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
        contentTextStyle: AppTextStyles.labelLarge.copyWith(
          color: isDark ? AppColors.textMainLight : AppColors.textMainDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── ListTile ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTextStyles.labelLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSub(brightness),
        ),
      ),

      // ── Icon ──────────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppSpacing.iconMd,
      ),

      // ── Floating Action Button ────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryContent,
        elevation: AppSpacing.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    );
  }
}
