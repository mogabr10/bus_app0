import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Secondary / outlined action button matching the Stitch design.
///
/// Features:
/// - Background surface color with 1px border
/// - Height `h-10` (40 px) — compact action style
/// - Optional leading icon (`text-[18px]`)
/// - Loading spinner state
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: AppSpacing.buttonHeightSm,
      width: isExpanded ? double.infinity : null,
      child: Material(
        color: AppColors.background(theme.brightness),
        borderRadius: AppSpacing.borderRadiusLg,
        child: InkWell(
          onTap: _enabled ? onPressed : null,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.border(theme.brightness),
              ),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: AppSpacing.iconSm,
                          color: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: theme.colorScheme.onSurface,
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
