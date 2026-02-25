import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Custom bottom navigation bar matching the Stitch design.
///
/// Features:
/// - Fixed bottom, max-width constrained
/// - Frosted glass effect (`backdrop-blur-md bg-surface-dark/95`)
/// - Top border separator
/// - 4 destinations with Material Symbols icons
/// - Active tab uses `text-primary`, inactive uses `text-sub`
/// - `text-[10px]` labels always visible
/// - Notification badge dot on configurable tab
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [],
    this.badgeIndices = const {},
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Override default tabs. If empty, uses the standard 4 tabs.
  final List<BottomNavItem> items;

  /// Indices of tabs that should show a notification badge dot.
  final Set<int> badgeIndices;

  List<BottomNavItem> get _items => items.isNotEmpty
      ? items
      : const [
          BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'الرئيسية',
          ),
          BottomNavItem(
            icon: Icons.directions_bus_outlined,
            activeIcon: Icons.directions_bus,
            label: 'الرحلات',
          ),
          BottomNavItem(
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: 'الإشعارات',
          ),
          BottomNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'الحساب',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.95)
                : AppColors.surfaceLight.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(
                color: AppColors.border(theme.brightness),
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: AppSpacing.base,
            right: AppSpacing.base,
            top: AppSpacing.md,
            bottom: AppSpacing.lg + bottomPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              final hasBadge = badgeIndices.contains(index);

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with optional badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: AppSpacing.iconMd,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textSub(theme.brightness),
                          ),
                          if (hasBadge)
                            Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.surfaceDark
                                        : AppColors.surfaceLight,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Label
                      Text(
                        item.label,
                        style: AppTextStyles.micro.copyWith(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSub(theme.brightness),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Data class for a bottom navigation tab item.
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
