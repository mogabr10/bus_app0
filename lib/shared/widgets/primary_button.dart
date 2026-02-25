import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Primary CTA button with gradient background matching the Stitch design.
///
/// Features:
/// - Linear gradient (`#135bec` → `#3b82f6`)
/// - Blue shadow glow (`shadow-lg shadow-blue-500/30`)
/// - Press scale animation (`active:scale-[0.98]`)
/// - Loading spinner state
/// - Optional trailing icon
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
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

  /// When `true`, the button stretches to fill available width.
  final bool isExpanded;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.98);
  void _onTapUp(TapUpDetails _) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _enabled ? _onTapDown : null,
      onTapUp: _enabled ? _onTapUp : null,
      onTapCancel: _enabled ? _onTapCancel : null,
      onTap: _enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: AppSpacing.inputHeight,
          width: widget.isExpanded ? double.infinity : null,
          padding:
              widget.isExpanded ? null : AppSpacing.formPadding,
          decoration: BoxDecoration(
            gradient: _enabled ? AppColors.primaryGradient : null,
            color: _enabled ? null : Theme.of(context).disabledColor,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: _enabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryContent,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primaryContent,
                      ),
                    ),
                    if (widget.icon != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        widget.icon,
                        size: 20,
                        color: AppColors.primaryContent,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
