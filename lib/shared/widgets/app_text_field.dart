import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Text input field matching the Stitch login screen design.
///
/// Features:
/// - `h-14` (56 px) fixed height
/// - `rounded-xl` container with 1px border
/// - Focus ring: `border-primary` + `ring-1 ring-primary`
/// - Trailing icon with separator border
/// - Optional label above the field
/// - Optional helper / error below
/// - RTL-friendly: phone inputs can set [textDirection] to LTR.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.trailingIcon,
    this.leadingIcon,
    this.onTrailingIconTap,
    this.obscureText = false,
    this.keyboardType,
    this.textDirection,
    this.validator,
    this.onChanged,
    this.autofillHints,
    this.helperText,
    this.errorText,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final VoidCallback? onTrailingIconTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final String? helperText;
  final String? errorText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────────
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // ── Input row ─────────────────────────────────────────────────
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: textDirection,
          validator: validator,
          onChanged: onChanged,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          focusNode: focusNode,
          enabled: enabled,
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: leadingIcon != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                    child: Icon(leadingIcon, color: AppColors.textSubLight),
                  )
                : null,
            prefixIconConstraints: leadingIcon != null
                ? const BoxConstraints(minWidth: 56)
                : null,
            suffixIcon: trailingIcon != null
                ? GestureDetector(
                    onTap: onTrailingIconTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.base),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: AppColors.border(theme.brightness),
                          ),
                        ),
                      ),
                      child: Icon(
                        trailingIcon,
                        color: AppColors.textSub(theme.brightness),
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: trailingIcon != null
                ? const BoxConstraints(minWidth: 56)
                : null,
          ),
        ),
      ],
    );
  }
}
