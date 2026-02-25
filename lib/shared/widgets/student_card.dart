import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Student list item card matching the Stitch Student List Screen design.
///
/// Features:
/// - Circular avatar with initials fallback
/// - Name, class, and address info
/// - Optional status indicator dot (online/picked-up/absent)
/// - Trailing action icon
/// - `rounded-xl` surface with border
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.name,
    required this.className,
    this.address,
    this.avatarUrl,
    this.status,
    this.onTap,
    this.trailing,
  });

  final String name;
  final String className;
  final String? address;
  final String? avatarUrl;
  final StudentStatus? status;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            children: [
              // ── Avatar ──────────────────────────────────────────────
              _buildAvatar(theme),
              const SizedBox(width: AppSpacing.md),

              // ── Info ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      className,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSub(theme.brightness),
                      ),
                    ),
                    if (address != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSub(theme.brightness),
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Expanded(
                            child: Text(
                              address!,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSub(theme.brightness),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ── Trailing ────────────────────────────────────────────
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ] else ...[
                Icon(
                  Icons.chevron_left,
                  color: AppColors.textSub(theme.brightness),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final initials = name.split(' ').take(2).map((w) => w[0]).join();

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: avatarUrl == null
              ? Text(
                  initials,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        if (status != null)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: status!.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum StudentStatus {
  onBoard(AppColors.success, 'على متن الحافلة'),
  arrived(AppColors.info, 'وصل'),
  absent(AppColors.error, 'غائب'),
  waiting(AppColors.warning, 'في الانتظار');

  const StudentStatus(this.color, this.label);
  final Color color;
  final String label;
}
