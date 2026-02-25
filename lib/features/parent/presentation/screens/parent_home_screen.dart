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
///       - Load active trip data
///       - Load notifications
///       - Handle navigation
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      navBadgeIndices: const {2}, // Notifications tab has badge
      body: _buildBody(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSub(Theme.of(context).brightness),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            // TODO: Replace with user name from state
            // Text(parent.name, ...)
            Text(
              'أحمد',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textMain(Theme.of(context).brightness),
              ),
            ),
          ],
        ),
        // Notification bell button
        Container(
          width: AppSpacing.buttonHeightSm,
          height: AppSpacing.buttonHeightSm,
          decoration: BoxDecoration(
            color: AppColors.surface(Theme.of(context).brightness),
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: AppColors.border(Theme.of(context).brightness),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: AppSpacing.iconMd,
            color: AppColors.textSub(Theme.of(context).brightness),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: AppSpacing.base,
        bottom: AppSpacing.bottomNavSafe,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Active Trip Status Card ────────────────────────────────────────
          _buildActiveTripSection(context),
          
          SizedBox(height: AppSpacing.xl),

          // ── Quick Actions Grid ────────────────────────────────────────────
          _buildQuickActionsSection(context),
          
          SizedBox(height: AppSpacing.xl),

          // ── Recent Notifications ──────────────────────────────────────────
          _buildNotificationsSection(context),
        ],
      ),
    );
  }

  Widget _buildActiveTripSection(BuildContext context) {
    // TODO: Replace with actual trip data from state
    // if (activeTrip == null) return _buildNoActiveTrip(context);
    
    return StatusCard(
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
        onPressed: () {
          // TODO: Navigate to live tracking
        },
      ),
      secondaryAction: StatusCardAction(
        label: 'تفاصيل الرحلة',
        onPressed: () {
          // TODO: Navigate to trip details
        },
      ),
      onTap: () {
        // TODO: Navigate to trip details
      },
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            'إجراءات سريعة',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textMain(Theme.of(context).brightness),
            ),
          ),
        ),
        
        SizedBox(height: AppSpacing.base),

        // Actions grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.5,
          children: [
            _QuickActionCard(
              icon: Icons.people_alt_outlined,
              label: 'طلابك',
              onTap: () {
                // TODO: Navigate to student list
              },
            ),
            _QuickActionCard(
              icon: Icons.map_outlined,
              label: 'تتبع الحافلات',
              onTap: () {
                // TODO: Navigate to live tracking
              },
            ),
            _QuickActionCard(
              icon: Icons.payment_outlined,
              label: 'الدفع',
              onTap: () {
                // TODO: Navigate to payments
              },
            ),
            _QuickActionCard(
              icon: Icons.chat_outlined,
              label: 'المحادثة',
              onTap: () {
                // TODO: Navigate to chat
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    // TODO: Replace with actual notifications from state
    final notifications = _getSampleNotifications();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإشعارات الأخيرة',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.textMain(Theme.of(context).brightness),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all notifications
                },
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
        
        SizedBox(height: AppSpacing.base),

        // Notifications list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
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

  void _onNavTap(int index) {
    // TODO: Handle navigation based on index
    // This should integrate with GoRouter
    setState(() => _currentNavIndex = index);
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
            border: Border.all(
              color: AppColors.border(brightness),
            ),
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
              SizedBox(height: AppSpacing.sm),
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
