import 'package:flutter/material.dart';

/// Spacing, border‑radius, and elevation constants extracted from the
/// Stitch project's Tailwind configuration.
///
/// All values follow the standard 4‑point grid used in the design.
abstract final class AppSpacing {
  // ──────────────────────────── Base spacing ──────────────────────────────
  /// 2 px — `gap-0.5`.
  static const double xxs = 2;

  /// 4 px — `gap-1`, `p-1`.
  static const double xs = 4;

  /// 8 px — `gap-2`, `p-2`.
  static const double sm = 8;

  /// 12 px — `gap-3`, `p-3`.
  static const double md = 12;

  /// 16 px — `gap-4`, `p-4`.
  static const double base = 16;

  /// 20 px — `gap-5`, `p-5`.
  static const double lg = 20;

  /// 24 px — `gap-6`, `p-6`, `space-y-6`.
  static const double xl = 24;

  /// 32 px — `gap-8`.
  static const double xxl = 32;

  /// 48 px — `p-12`, `mb-12`.
  static const double xxxl = 48;

  /// 96 px — `pb-24` (bottom‑nav safe area compensation).
  static const double bottomNavSafe = 96;

  // ──────────────────────────── Edge insets ───────────────────────────────
  /// Standard screen padding (`px-4` = 16 px horizontal).
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: base);

  /// Standard screen padding with vertical (`p-4`).
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(base);

  /// Card / section internal padding (`p-5` = 20 px).
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Form field area padding (`px-6` = 24 px horizontal).
  static const EdgeInsets formPadding =
      EdgeInsets.symmetric(horizontal: xl);

  /// Bottom navigation safe padding (`pb-24 pt-3 px-4`).
  static const EdgeInsets bottomNavPadding = EdgeInsets.only(
    left: base,
    right: base,
    top: md,
    bottom: lg,
  );

  // ──────────────────────────── Border radii ─────────────────────────────
  /// 4 px — Tailwind `rounded` (DEFAULT).
  static const double radiusSm = 4;

  /// 8 px — Tailwind `rounded-lg`.
  static const double radiusMd = 8;

  /// 12 px — Tailwind `rounded-xl`.
  static const double radiusLg = 12;

  /// 16 px — Tailwind `rounded-2xl` (card containers).
  static const double radiusXl = 16;

  /// 9999 px — Tailwind `rounded-full`.
  static const double radiusFull = 9999;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(radiusFull));

  // ──────────────────────────── Elevation ─────────────────────────────────
  /// No elevation — flat surfaces.
  static const double elevationNone = 0;

  /// Subtle shadow (`shadow-sm`).
  static const double elevationSm = 1;

  /// Default card shadow (`shadow`).
  static const double elevationMd = 2;

  /// Prominent shadow (`shadow-lg`).
  static const double elevationLg = 4;

  /// Heavy shadow (`shadow-xl`).
  static const double elevationXl = 8;

  /// Maximum shadow (`shadow-2xl`).
  static const double elevationXxl = 12;

  // ──────────────────────────── Component sizes ──────────────────────────
  /// Standard touch target height (buttons, inputs) — `h-14` = 56 px.
  static const double inputHeight = 56;

  /// Compact button height — `h-10` = 40 px.
  static const double buttonHeightSm = 40;

  /// Icon sizes used in Material Symbols Outlined.
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 40;
  static const double iconXl = 64;

  /// Avatar / profile picture sizes.
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 80;
  static const double avatarXl = 128;

  /// Bottom navigation bar total height.
  static const double bottomNavHeight = 72;

  /// Progress bar height — `h-2` = 8 px, `h-1.5` = 6 px.
  static const double progressBarHeight = 8;
  static const double progressBarHeightSm = 6;
}
