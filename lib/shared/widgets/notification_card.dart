import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Notification list item matching the Stitch Notifications Screen design.
///
/// Features:
/// - Leading `h-8 w-8` icon circle with semantic colour
/// - Title (14 px medium) + description (12 px)
/// - Trailing timestamp (`text-[10px]`)
/// - `rounded-xl` surface with border
/// - Optional unread dot
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isUnread = false,
    this.onTap,
  });

  final String title;
  final String description;

  /// E.g. `منذ 15د` or `٠٧:٣٠ ص`.
  final String timestamp;

  final NotificationType type;
  final bool isUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppSpacing.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusLg,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon circle ─────────────────────────────────────────
              Container(
                width: AppSpacing.avatarSm,
                height: AppSpacing.avatarSm,
                decoration: BoxDecoration(
                  color: isDark
                      ? type.color.withValues(alpha: 0.2)
                      : type.lightBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  type.icon,
                  size: AppSpacing.iconSm,
                  color: isDark ? type.darkFg : type.color,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // ── Text content ────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight:
                            isUnread ? FontWeight.w700 : FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSub(theme.brightness),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // ── Timestamp ───────────────────────────────────────────
              Column(
                children: [
                  Text(
                    timestamp,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.textSub(theme.brightness),
                    ),
                  ),
                  if (isUnread) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Notification category with associated visual properties.
enum NotificationType {
  busArriving(
    Icons.notifications_active,
    AppColors.error,
    Color(0xFFFEE2E2), // red-100
    Color(0xFFF87171), // red-400
  ),
  studentArrived(
    Icons.check_circle,
    AppColors.info,
    Color(0xFFDBEAFE), // blue-100
    Color(0xFF60A5FA), // blue-400
  ),
  paymentSuccess(
    Icons.credit_card,
    AppColors.success,
    Color(0xFFDCFCE7), // green-100
    Color(0xFF4ADE80), // green-400
  ),
  busDelayed(
    Icons.schedule,
    AppColors.warning,
    Color(0xFFFEF9C3), // yellow-100
    Color(0xFFFACC15), // yellow-400
  ),
  systemUpdate(
    Icons.system_update,
    AppColors.accent,
    Color(0xFFF3E8FF), // purple-100
    Color(0xFFC084FC), // purple-400
  );

  const NotificationType(this.icon, this.color, this.lightBg, this.darkFg);
  final IconData icon;
  final Color color;

  /// Light background for the icon circle (light mode).
  final Color lightBg;

  /// Foreground colour in dark mode.
  final Color darkFg;
}
