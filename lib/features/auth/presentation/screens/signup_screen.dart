import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../presentation/providers/auth_provider.dart';

/// Sign-up screen for parent registration.
///
/// Features:
/// - Full name, email, password, confirm password fields
/// - School dropdown selection
/// - Relationship selector (Father / Mother)
/// - Child name input with add another child functionality
/// - Form validation
/// - Responsive layout with SingleChildScrollView
/// - RTL friendly
/// - Material 3 design
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Text controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus nodes
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _selectedSchool = 'عمر سليمان';
  String _selectedRelationship = 'Father';
  final List<TextEditingController> _childNameControllers = [
    TextEditingController(),
  ];

  // Sample school list
  static const List<String> _schools = [
    'عمر سليمان',
    'مدرسة الأمل',
    'مدرسة النور',
    'مدرسة السلام',
    'مدرسة الفجر',
  ];

  static const List<String> _relationships = ['Father', 'Mother'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _scrollController.dispose();
    for (final controller in _childNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // ──────────────────────────── Validation ─────────────────────

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateChildName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Child name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // ──────────────────────────── Actions ─────────────────────────────────────

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _onSchoolChanged(String? value) {
    setState(() {
      _selectedSchool = value;
    });
  }

  void _onRelationshipChanged(String value) {
    setState(() {
      _selectedRelationship = value;
    });
  }

  void _addChild() {
    setState(() {
      _childNameControllers.add(TextEditingController());
    });
    // Scroll to bottom after adding new field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeChild(int index) {
    if (_childNameControllers.length > 1) {
      setState(() {
        _childNameControllers[index].dispose();
        _childNameControllers.removeAt(index);
      });
    }
  }

  Future<void> _onSignUpPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the sign up API via Riverpod provider
        await ref
            .read(authStateProvider.notifier)
            .signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              role: 'parent',
              schoolName: _selectedSchool,
              relationship: _selectedRelationship,
            );

        // Navigate to login screen after successful signup
        if (mounted) {
          context.go(RoutePaths.login);
        }
      } catch (e) {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup failed: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _onLoginTap() {
    context.pop();
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
        final maxWidth = constraints.maxWidth;
        final isTablet = maxWidth > 600;

        return Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: AppSpacing.screenPadding,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: _buildSignUpForm(context, theme, isTablet),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpForm(
    BuildContext context,
    ThemeData theme,
    bool isTablet,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          _buildHeader(theme),
          SizedBox(height: isTablet ? AppSpacing.xxl : AppSpacing.xl),

          // ── Full Name Field ───────────────────────────────────────────────
          AppTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            leadingIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            focusNode: _fullNameFocusNode,
            autofillHints: const [AutofillHints.name],
            validator: _validateFullName,
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Email Field ────────────────────────────────────────────────
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            leadingIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            textDirection: TextDirection.ltr,
            autofillHints: const [AutofillHints.email],
            validator: _validateEmail,
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Password Field ────────────────────────────────────────────────
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
            textInputAction: TextInputAction.next,
            focusNode: _passwordFocusNode,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.base),

          // ── Confirm Password Field ───────────────────────────────────────
          AppTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            leadingIcon: Icons.lock_outline,
            trailingIcon: _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onTrailingIconTap: _toggleConfirmPasswordVisibility,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.next,
            focusNode: _confirmPasswordFocusNode,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: AppSpacing.base),

          // ── School Dropdown ───────────────────────────────────────────────
          _buildSchoolDropdown(theme),
          const SizedBox(height: AppSpacing.base),

          // ── Relationship Selector ─────────────────────────────────────────
          _buildRelationshipSelector(theme),
          const SizedBox(height: AppSpacing.base),

          // ── Children Section ──────────────────────────────────────────────
          _buildChildrenSection(theme),
          const SizedBox(height: AppSpacing.lg),

          // ── Sign Up Button ────────────────────────────────────────────────
          PrimaryButton(
            label: 'Register',
            isLoading: _isLoading,
            onPressed: _onSignUpPressed,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Login Link ───────────────────────────────────────────────────
          _buildLoginLink(theme),
          const SizedBox(height: AppSpacing.base),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // App logo
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
          'Create Account',
          style: AppTextStyles.displayMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Sign up to get started',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildSchoolDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'School',
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: AppSpacing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface(theme.brightness),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.border(theme.brightness)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSchool,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSub(theme.brightness),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              dropdownColor: AppColors.surface(theme.brightness),
              borderRadius: AppSpacing.borderRadiusLg,
              items: _schools.map((String school) {
                return DropdownMenuItem<String>(
                  value: school,
                  child: Text(school, style: AppTextStyles.bodyMedium),
                );
              }).toList(),
              onChanged: _onSchoolChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship',
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(theme.brightness),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.border(theme.brightness)),
          ),
          child: Row(
            children: _relationships.map((relationship) {
              final isSelected = _selectedRelationship == relationship;
              return Expanded(
                child: _RelationshipOption(
                  label: relationship,
                  icon: relationship == 'Father' ? Icons.male : Icons.female,
                  isSelected: isSelected,
                  onTap: () => _onRelationshipChanged(relationship),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Children',
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Child name fields
        ...List.generate(_childNameControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.base),
            child: _ChildNameInput(
              controller: _childNameControllers[index],
              index: index,
              canRemove: _childNameControllers.length > 1,
              onRemove: () => _removeChild(index),
              validator: _validateChildName,
            ),
          );
        }),

        // Add another child button
        SecondaryButton(
          label: 'Add Another Child',
          icon: Icons.add,
          onPressed: _addChild,
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSub(theme.brightness),
          ),
        ),
        GestureDetector(
          onTap: _onLoginTap,
          child: Text(
            'Login',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

/// Internal widget for relationship selection options.
class _RelationshipOption extends StatelessWidget {
  const _RelationshipOption({
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

/// Internal widget for child name input with remove button.
class _ChildNameInput extends StatelessWidget {
  const _ChildNameInput({
    required this.controller,
    required this.index,
    required this.canRemove,
    required this.onRemove,
    required this.validator,
  });

  final TextEditingController controller;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final childNumber = index + 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Child name field
        Expanded(
          child: AppTextField(
            controller: controller,
            label: 'Child Name $childNumber',
            hint: 'Enter child\'s name',
            leadingIcon: Icons.child_care_outlined,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.givenName],
            validator: validator,
          ),
        ),

        // Remove button (if can remove)
        if (canRemove) ...[
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.inputHeight - AppSpacing.buttonHeightSm,
            ),
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                height: AppSpacing.buttonHeightSm,
                width: AppSpacing.buttonHeightSm,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: AppSpacing.iconSm,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
