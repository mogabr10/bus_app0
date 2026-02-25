import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Forgot password screen for password recovery.
///
/// Features:
/// - Email/phone input field
/// - Form validation
/// - Responsive layout
/// - Ready for Riverpod integration
///
/// TODO: Create ForgotPasswordController with Riverpod for:
/// - State management (email, isLoading)
/// - Form validation logic
/// - Password reset API call
/// - Error handling
/// - Navigation on success
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone is required';
    }
    final isEmail = value.contains('@');
    final isPhone = RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value);

    if (isEmail) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email';
      }
    } else if (!isPhone) {
      return 'Please enter a valid email or phone number';
    }
    return null;
  }

  void _onSubmitPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      // TODO: Call Riverpod controller reset password method
      // ref.read(forgotPasswordControllerProvider.notifier).resetPassword();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background(theme.brightness),
      body: SafeArea(child: _buildResponsiveLayout(context, theme)),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: _buildForm(context, theme, isTablet),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ThemeData theme, bool isTablet) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(theme),
          SizedBox(height: isTablet ? AppSpacing.xxl : AppSpacing.xl),

          AppTextField(
            controller: _emailController,
            label: 'Email or Phone',
            hint: 'Enter your email or phone number',
            leadingIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            focusNode: _emailFocusNode,
            autofillHints: const [AutofillHints.email],
            validator: _validateEmail,
            onChanged: (value) {
              // TODO: Update Riverpod controller state
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          Text(
            'We will send you a link to reset your password',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSub(theme.brightness),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          AppButton(
            label: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _onSubmitPressed,
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildBackToLoginLink(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppSpacing.borderRadiusXl,
          ),
          child: const Icon(
            Icons.lock_reset,
            size: 40,
            color: AppColors.primaryContent,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Forgot Password',
          style: AppTextStyles.displayMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Enter your email to reset your password',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remember your password? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text(
            'Login',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
