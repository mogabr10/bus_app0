import 'package:flutter/material.dart';

/// Typography scale and font families extracted from the Stitch design.
///
/// The design uses **Lexend** for display/English text and
/// **Noto Sans Arabic** for Arabic content.  Both families are referenced
/// via `fontFamilyFallback` so they work together for mixed‑language UIs.
abstract final class AppTextStyles {
  // ──────────────────────────── Font families ─────────────────────────────
  static const String fontFamilyDisplay = 'Lexend';
  static const String fontFamilyArabic = 'Noto Sans Arabic';

  static const List<String> fontFamilyFallback = [
    fontFamilyArabic,
    'sans-serif',
  ];

  // ──────────────────────────── Type scale ─────────────────────────────────
  // Mirrors the Tailwind text‑* utilities used in the Stitch screens.

  /// Splash screen title — `text-4xl` (36 px), bold.
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
  );

  /// Section / screen titles — `text-[28px]`, bold.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// Card headings / dashboard section titles — `text-xl` (20 px), bold.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// App bar titles — `text-lg` (18 px), bold.
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: -0.015 * 18,
  );

  /// Primary body — `text-base` (16 px), medium weight.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Secondary body / descriptions — `text-base` (16 px), normal weight.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Form labels / sub‑labels — `text-sm` (14 px), medium weight.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  /// Small labels / captions — `text-sm` (14 px), normal weight.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  /// Timestamps / supporting text — `text-xs` (12 px).
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  /// Bottom‑nav labels — `text-[10px]`, medium weight.
  static const TextStyle micro = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Button text — `text-base` (16 px), bold.
  static const TextStyle button = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  /// Small button text — `text-sm` (14 px), semibold.
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
  );

  // ──────────────────────────── Material 3 TextTheme ──────────────────────

  static TextTheme get textTheme => const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: headlineLarge,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: bodyLarge,
        titleLarge: headlineMedium,
        titleMedium: bodyLarge,
        titleSmall: labelLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: labelMedium,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
