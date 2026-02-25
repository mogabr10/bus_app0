import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'custom_bottom_nav_bar.dart';

/// Wrapper scaffold matching the Stitch app shell layout.
///
/// Features:
/// - Max-width `md` (448 px) centred container with shadow
/// - Themed AppBar with optional back button & actions
/// - Safe-area aware `pb-24` body padding when bottom nav present
/// - Optional [CustomBottomNavBar] integration
/// - Optional FAB slot
/// - Keyboard-aware bottom inset handling
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.currentNavIndex,
    this.onNavTap,
    this.navItems,
    this.navBadgeIndices,
    this.floatingActionButton,
    this.bodyPadding,
    this.backgroundColor,
    this.appBarColor,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final String? title;

  /// Custom title widget (takes priority over [title]).
  final Widget? titleWidget;

  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  // ── Bottom navigation ─────────────────────────────────────────────
  /// When non-null, shows [CustomBottomNavBar].
  final int? currentNavIndex;
  final ValueChanged<int>? onNavTap;
  final List<BottomNavItem>? navItems;
  final Set<int>? navBadgeIndices;

  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? bodyPadding;
  final Color? backgroundColor;
  final Color? appBarColor;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;

  bool get _hasBottomNav => currentNavIndex != null && onNavTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppColors.background(theme.brightness),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody || _hasBottomNav,
        appBar: _buildAppBar(theme),
        body: _buildBody(context),
        bottomNavigationBar: _hasBottomNav
            ? CustomBottomNavBar(
                currentIndex: currentNavIndex!,
                onTap: onNavTap!,
                items: navItems ?? const [],
                badgeIndices: navBadgeIndices ?? const {},
              )
            : null,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(ThemeData theme) {
    if (title == null && titleWidget == null && !showBackButton && actions == null) {
      return null;
    }

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: onBack ??
                  () => Navigator.of(
                        // ignore: use_build_context_synchronously
                        WidgetsBinding.instance.focusManager.primaryFocus?.context ??
                            WidgetsBinding.instance.rootElement!,
                      ).maybePop(),
            )
          : null,
      automaticallyImplyLeading: false,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : null),
      centerTitle: true,
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    final defaultPadding = bodyPadding ??
        EdgeInsets.only(
          left: AppSpacing.base,
          right: AppSpacing.base,
          bottom: _hasBottomNav ? AppSpacing.bottomNavSafe : 0,
        );

    return SafeArea(
      bottom: !_hasBottomNav,
      child: Padding(
        padding: defaultPadding,
        child: body,
      ),
    );
  }
}
