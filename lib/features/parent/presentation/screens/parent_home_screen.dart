import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/notification_card.dart';
import '../../../../shared/widgets/status_card.dart';
import '../../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_scaffold.dart';

/// Parent home screen displaying dashboard with active trip, notifications, and actions.
///
/// Layout structure:
/// - AppBar with greeting and notification icon
/// - Scrollable content area:
///   - Active Trip Status Card
///   - Quick Actions Grid
///   - Recent Notifications List
/// - Bottom Navigation Bar
///
/// TODO: Integrate with Riverpod state management
///       - Load active trip data from backend
///       - Load user profile (name)
///       - Load notifications list
///       - Handle navigation with GoRouter
class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentNavIndex = 0;

  // TODO: Replace with actual state from Riverpod
  // final activeTrip = ref.watch(activeTripProvider);
  // final notifications = ref.watch(notificationsProvider);
  // final parentProfile = ref.watch(parentProfileProvider);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleWidget: _buildHeader(context),
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      navItems: const [
        BottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'الرئيسية',
        ),
        BottomNavItem(
          icon: Icons.directions_bus_outlined,
          activeIcon: Icons.directions_bus,
          label: 'الرحلات',
        ),
        BottomNavItem(
          icon: Icons.notifications_outlined,
          activeIcon: Icons.notifications,
          label: 'الإشعارات',
        ),
        BottomNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'الحساب',
        ),
      ],
      navBadgeIndices: const {2},
      body: _buildBody(context),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Header Section
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildGreeting(context), _buildNotificationButton(context)],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSub(brightness),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        // TODO: Replace with parent name from state
        // Text(parentProfile.name, ...)
        Text(
          'أحمد',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textMain(brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      width: AppSpacing.buttonHeightSm,
      height: AppSpacing.buttonHeightSm,
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border(brightness)),
      ),
      child: IconButton(
        icon: const Icon(Icons.notifications_outlined),
        iconSize: AppSpacing.iconMd,
        color: AppColors.textSub(brightness),
        onPressed: () {
          // TODO: Navigate to notifications screen
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Body Section
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: AppSpacing.base,
        bottom: AppSpacing.bottomNavSafe,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Active Trip Status Card
          _ActiveTripSection(),

          SizedBox(height: AppSpacing.xl),

          // Quick Actions Grid
          _QuickActionsSection(),

          SizedBox(height: AppSpacing.xl),

          // Recent Notifications
          _NotificationsSection(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Navigation Handler
  // ─────────────────────────────────────────────────────────────────────────────

  void _onNavTap(int index) {
    // TODO: Handle navigation with GoRouter
    // context.go(navRoutes[index]);
    setState(() => _currentNavIndex = index);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Active Trip Section
// ─────────────────────────────────────────────────────────────────────────────

/// Widget displaying the active trip status card.
///
/// TODO: Integrate with activeTripProvider
///       - Show loading state while fetching
///       - Handle empty state when no active trip
///       - Update progress in real-time
class _ActiveTripSection extends StatelessWidget {
  const _ActiveTripSection();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual trip data from state
    // if (activeTrip == null) return _buildNoActiveTrip(context);

    return const StatusCard(
      title: 'الحافلة رقم ٥',
      subtitle: 'السائق: محمد أحمد',
      statusLabel: 'نشط الآن',
      statusColor: AppColors.success,
      progress: 0.65,
      progressLabel: 'المسافة المتبقية',
      progressValue: '٣ كم',
      icon: Icons.directions_bus,
      primaryAction: StatusCardAction(
        label: 'تتبع مباشر',
        icon: Icons.location_on,
        onPressed: _navigateToLiveTracking,
      ),
      secondaryAction: StatusCardAction(
        label: 'تفاصيل الرحلة',
        onPressed: _navigateToTripDetails,
      ),
      onTap: _navigateToTripDetails,
    );
  }

  static void _navigateToLiveTracking() {
    // TODO: Navigate to live tracking screen
  }

  static void _navigateToTripDetails() {
    // TODO: Navigate to trip details screen
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions Section
// ─────────────────────────────────────────────────────────────────────────────

/// Widget displaying quick action grid.
///
/// TODO: Integrate with navigation routes
///       - Use GoRouter for navigation
///       - Pass selected student ID where needed
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            'إجراءات سريعة',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textMain(brightness),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // Actions grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.5,
          children: const [
            _QuickActionCard(
              icon: Icons.people_alt_outlined,
              label: 'طلابك',
              onTap: _navigateToStudents,
            ),
            _QuickActionCard(
              icon: Icons.map_outlined,
              label: 'تتبع الحافلات',
              onTap: _navigateToLiveTracking,
            ),
            _QuickActionCard(
              icon: Icons.payment_outlined,
              label: 'الدفع',
              onTap: _navigateToPayments,
            ),
            _QuickActionCard(
              icon: Icons.chat_outlined,
              label: 'المحادثة',
              onTap: _navigateToChat,
            ),
          ],
        ),
      ],
    );
  }

  static void _navigateToStudents() {
    // TODO: Navigate to student list screen
  }

  static void _navigateToLiveTracking() {
    // TODO: Navigate to live tracking screen
  }

  static void _navigateToPayments() {
    // TODO: Navigate to payment screen
  }

  static void _navigateToChat() {
    // TODO: Navigate to chat screen
  }
}

/// Quick action card widget for the grid.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: AppColors.surface(brightness),
      borderRadius: AppSpacing.borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusLg,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.border(brightness)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSpacing.iconLg,
                height: AppSpacing.iconLg,
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
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textMain(brightness),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifications Section
// ─────────────────────────────────────────────────────────────────────────────

/// Widget displaying recent notifications list.
///
/// TODO: Integrate with notificationsProvider
///       - Load actual notifications from backend
///       - Handle pagination for long lists
///       - Mark as read on tap
class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // TODO: Replace with actual notifications from state
    final notifications = _getSampleNotifications();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإشعارات الأخيرة',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.textMain(brightness),
                ),
              ),
              TextButton(
                onPressed: _navigateToAllNotifications,
                child: Text(
                  'عرض الكل',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // Notifications list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(
              title: notification['title'] as String,
              description: notification['description'] as String,
              timestamp: notification['timestamp'] as String,
              type: notification['type'] as NotificationType,
              isUnread: notification['isUnread'] as bool,
              onTap: () {
                // TODO: Handle notification tap
              },
            );
          },
        ),
      ],
    );
  }

  static void _navigateToAllNotifications() {
    // TODO: Navigate to all notifications screen
  }

  List<Map<String, dynamic>> _getSampleNotifications() {
    return [
      {
        'title': 'وصول الطالب',
        'description': 'تم وصول أحمد إلى المدرسة بنجاح',
        'timestamp': 'منذ ٣٠ دقيقة',
        'type': NotificationType.studentArrived,
        'isUnread': true,
      },
      {
        'title': 'تأخر الحافلة',
        'description': 'الحافلة ستتأخر ١٥ دقيقة عن الموعد المحدد',
        'timestamp': 'منذ ساعة',
        'type': NotificationType.busDelayed,
        'isUnread': true,
      },
      {
        'title': 'موعد الدفع',
        'description': 'موعد تجديد الاشتراك الشهري غداً',
        'timestamp': 'منذ ٢ ساعة',
        'type': NotificationType.paymentSuccess,
        'isUnread': false,
      },
    ];
  }
}
