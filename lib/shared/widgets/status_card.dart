import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Active trip / bus status card matching the Stitch dashboard design.
///
/// Features:
/// - Optional map image banner with gradient overlay
/// - Live status badge (`نشط الآن`)
/// - Title + subtitle (bus number, driver)
/// - Progress bar with remaining time
/// - Two action buttons (primary + secondary)
class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.statusLabel,
    this.statusColor,
    this.progress,
    this.progressLabel,
    this.progressValue,
    this.mapImageUrl,
    this.icon = Icons.directions_bus,
    this.primaryAction,
    this.secondaryAction,
    this.onTap,
  });

  final String title;
  final String subtitle;

  /// Badge text, e.g. `نشط الآن`.
  final String? statusLabel;

  /// Badge colour; defaults to [AppColors.success].
  final Color? statusColor;

  /// 0.0 – 1.0
  final double? progress;
  final String? progressLabel;
  final String? progressValue;

  /// Optional map / hero image URL.
  final String? mapImageUrl;
  final IconData icon;

  /// E.g. `('الموقع المباشر', Icons.location_on, onTap)`
  final StatusCardAction? primaryAction;
  final StatusCardAction? secondaryAction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = statusColor ?? AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Map banner ────────────────────────────────────────────
            if (mapImageUrl != null) _buildMapBanner(theme, badgeColor),

            // ── Content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTextStyles.headlineMedium),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              subtitle,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textSub(theme.brightness),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: AppSpacing.buttonHeightSm,
                        height: AppSpacing.buttonHeightSm,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                    ],
                  ),

                  // ── Progress ──────────────────────────────────────────
                  if (progress != null) ...[
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (progressLabel != null)
                          Text(
                            progressLabel!,
                            style: AppTextStyles.labelLarge,
                          ),
                        if (progressValue != null)
                          Text(
                            progressValue!,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: AppSpacing.borderRadiusFull,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: AppSpacing.progressBarHeight,
                        backgroundColor:
                            AppColors.background(theme.brightness),
                        color: AppColors.primary,
                      ),
                    ),
                  ],

                  // ── Action buttons ────────────────────────────────────
                  if (primaryAction != null || secondaryAction != null) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        if (primaryAction != null)
                          Expanded(
                            child: _ActionButton(
                              action: primaryAction!,
                              isPrimary: true,
                            ),
                          ),
                        if (primaryAction != null && secondaryAction != null)
                          const SizedBox(width: AppSpacing.md),
                        if (secondaryAction != null)
                          Expanded(
                            child: _ActionButton(
                              action: secondaryAction!,
                              isPrimary: false,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBanner(ThemeData theme, Color badgeColor) {
    return SizedBox(
      height: 128,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Map image
          Image.network(
            mapImageUrl!,
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.8),
            errorBuilder: (_, __, ___) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.map,
                size: 48,
                color: AppColors.textSub(theme.brightness),
              ),
            ),
          ),
          // Bottom gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
          // Status badge
          if (statusLabel != null)
            Positioned(
              bottom: AppSpacing.md,
              right: AppSpacing.base,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.2),
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(
                    color: badgeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  statusLabel!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Action tuple for [StatusCard] buttons.
class StatusCardAction {
  const StatusCardAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.isPrimary,
  });

  final StatusCardAction action;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: AppSpacing.buttonHeightSm,
      child: Material(
        color: isPrimary
            ? AppColors.primary
            : AppColors.background(theme.brightness),
        borderRadius: AppSpacing.borderRadiusLg,
        child: InkWell(
          onTap: action.onPressed,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Container(
            decoration: isPrimary
                ? null
                : BoxDecoration(
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: AppColors.border(theme.brightness),
                    ),
                  ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: AppSpacing.iconSm,
                    color: isPrimary
                        ? AppColors.primaryContent
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    action.label,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: isPrimary
                          ? AppColors.primaryContent
                          : theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
