import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Payment transaction card matching the Stitch Payments Screen design.
///
/// Features:
/// - Leading icon with semantic colour circle
/// - Transaction title + date/time
/// - Amount with +/- sign
/// - Status badge (`ناجحة`, `قيد المعالجة`, `فشلت`)
/// - `rounded-xl` surface with border
class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.onTap,
  });

  final String title;

  /// E.g. `01 أكتوبر 2023 • 10:30 ص`
  final String date;

  /// Signed amount string, e.g. `-150.00`
  final String amount;

  final PaymentStatus status;
  final VoidCallback? onTap;

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
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ────────────────────────────────────────────────
              Container(
                width: AppSpacing.avatarSm + 8,
                height: AppSpacing.avatarSm + 8,
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status.icon,
                  size: AppSpacing.iconSm,
                  color: status.color,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // ── Info ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      date,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSub(theme.brightness),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Amount + Status ─────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: amount.startsWith('-')
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.12),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Text(
                      status.label,
                      style: AppTextStyles.micro.copyWith(
                        color: status.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PaymentStatus {
  success(AppColors.success, 'ناجحة', Icons.check_circle_outline),
  pending(AppColors.warning, 'قيد المعالجة', Icons.schedule),
  failed(AppColors.error, 'فشلت', Icons.error_outline);

  const PaymentStatus(this.color, this.label, this.icon);
  final Color color;
  final String label;
  final IconData icon;
}
