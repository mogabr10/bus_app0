import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/user.dart' show UserRole;
import '../providers/auth_provider.dart';

/// Login screen with role selection toggle.
///
/// Features:
/// - Email/phone and password fields using [AppTextField]
/// - Role selection toggle (Parent / Supervisor)
/// - Form validation
/// - Responsive layout
/// - Clean separation of UI and logic
/// - Ready for Riverpod integration
///
/// TODO: Create LoginController with Riverpod for:
/// - State management (email, password, role, isLoading)
/// - Form validation logic
/// - Login API call
/// - Error handling
/// - Navigation on success
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  UserRole _selectedRole = UserRole.parent;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // TODO: Replace with Riverpod controller
  // final loginController = ref.watch(loginControllerProvider);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone is required';
    }
    // Check if it's email or phone
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
    // TODO: Update Riverpod controller state
    // ref.read(loginControllerProvider.notifier).setRole(role);
  }

  void _onLoginPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final authNotifier = ref.read(authStateProvider.notifier);
      await authNotifier.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final authState = ref.read(authStateProvider);

      authState.when(
        data: (user) {
          setState(() {
            _isLoading = false;
          });
          if (user != null) {
            if (user.role == UserRole.parent) {
              context.go(RouteNames.parentHome);
            } else {
              context.go(RouteNames.supervisorHome);
            }
          }
        },
        loading: () {},
        error: (error, stack) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login failed: $error')));
        },
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(theme.brightness),
      body: SafeArea(child: _buildResponsiveLayout(context, theme, isDark)),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isTablet = maxWidth > 600;

        return Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: _buildLoginForm(context, theme, isDark, isTablet),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    bool isTablet,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Logo / Title ────────────────────────────────────────────────
          _buildHeader(theme),
          SizedBox(height: isTablet ? AppSpacing.xxl : AppSpacing.xl),

          // ── Role Selection Toggle ───────────────────────────────────────
          _buildRoleToggle(theme, isDark),
          const SizedBox(height: AppSpacing.xl),

          // ── Email / Phone Field ─────────────────────────────────────────
          AppTextField(
            controller: _emailController,
            label: 'Email or Phone',
            hint: 'Enter your email or phone number',
            leadingIcon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            validator: _validateEmail,
            onChanged: (value) {
              // TODO: Update Riverpod controller state
              // ref.read(loginControllerProvider.notifier).setEmail(value);
            },
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Password Field ──────────────────────────────────────────────
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            leadingIcon: Icons.lock_outline,
            trailingIcon: _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onTrailingIconTap: _togglePasswordVisibility,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocusNode,
            autofillHints: const [AutofillHints.password],
            validator: _validatePassword,
            onChanged: (value) {
              // TODO: Update Riverpod controller state
              // ref.read(loginControllerProvider.notifier).setPassword(value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Forgot Password ─────────────────────────────────────────────
          _buildForgotPasswordLink(theme),
          const SizedBox(height: AppSpacing.xl),

          // ── Login Button ────────────────────────────────────────────────
          AppButton(
            label: 'Login',
            isLoading: _isLoading,
            onPressed: _onLoginPressed,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Sign Up Link ────────────────────────────────────────────────
          _buildSignUpLink(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // App logo placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppSpacing.borderRadiusXl,
          ),
          child: const Icon(
            Icons.directions_bus,
            size: 40,
            color: AppColors.primaryContent,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Welcome Back',
          style: AppTextStyles.displayMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Sign in to continue',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleToggle(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(theme.brightness),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border(theme.brightness)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RoleToggleOption(
              label: 'Parent',
              icon: Icons.family_restroom,
              isSelected: _selectedRole == UserRole.parent,
              onTap: () => _onRoleChanged(UserRole.parent),
            ),
          ),
          Expanded(
            child: _RoleToggleOption(
              label: 'Supervisor',
              icon: Icons.supervised_user_circle,
              isSelected: _selectedRole == UserRole.supervisor,
              onTap: () => _onRoleChanged(UserRole.supervisor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          debugPrint('Forgot Password tapped');
          context.push('/forgot-password');
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
        TextButton(
          onPressed: () {
            debugPrint('Sign Up tapped');
            context.push('/signup');
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Sign Up',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal widget for role toggle options.
class _RoleToggleOption extends StatelessWidget {
  const _RoleToggleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconMd,
              color: isSelected
                  ? AppColors.primaryContent
                  : AppColors.textSub(theme.brightness),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected
                    ? AppColors.primaryContent
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
