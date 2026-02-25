import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/live_tracking/presentation/screens/live_tracking_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/parent_dashboard/presentation/screens/parent_dashboard_screen.dart';
import '../../features/payments/presentation/screens/payment_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/supervisor_dashboard/presentation/screens/supervisor_dashboard_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _parentShellNavigatorKey = GlobalKey<NavigatorState>();
final _supervisorShellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _parentShellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(
            currentNavIndex: 0,
            onNavTap: (index) {},
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.parentHome,
            name: RouteNames.parentHome,
            builder: (context, state) => const ParentDashboardScreen(),
            routes: [
              GoRoute(
                path: RoutePaths.parentLiveTracking,
                name: RouteNames.parentLiveTracking,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const LiveTrackingScreen(),
              ),
              GoRoute(
                path: RoutePaths.parentStudentList,
                name: RouteNames.parentStudentList,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const StudentListScreen(),
              ),
              GoRoute(
                path: RoutePaths.parentChat,
                name: RouteNames.parentChat,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.booking,
            name: RouteNames.parentBooking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: RoutePaths.notifications,
            name: RouteNames.parentNotifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.payments,
            name: RouteNames.parentPayments,
            builder: (context, state) => const PaymentScreen(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _supervisorShellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(
            currentNavIndex: 0,
            onNavTap: (index) {},
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.supervisorHome,
            name: RouteNames.supervisorHome,
            builder: (context, state) => const SupervisorDashboardScreen(),
            routes: [
              GoRoute(
                path: RoutePaths.supervisorLiveTracking,
                name: RouteNames.supervisorLiveTracking,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const LiveTrackingScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.booking,
            name: RouteNames.supervisorBooking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: RoutePaths.notifications,
            name: RouteNames.supervisorNotifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.payments,
            name: RouteNames.supervisorPayments,
            builder: (context, state) => const PaymentScreen(),
          ),
        ],
      ),
    ],
  );
});
