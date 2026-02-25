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
import '../../features/parent/presentation/screens/parent_home_screen.dart';
import '../../features/payments/presentation/screens/payment_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/supervisor_dashboard/presentation/screens/supervisor_dashboard_screen.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
      // Parent routes
      GoRoute(
        path: '/parent/home',
        name: RouteNames.parentHome,
        builder: (context, state) => const ParentHomeScreen(),
      ),
      GoRoute(
        path: '/parent/booking',
        name: RouteNames.parentBooking,
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/parent/notifications',
        name: RouteNames.parentNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/parent/payments',
        name: RouteNames.parentPayments,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/parent/live-tracking',
        name: RouteNames.parentLiveTracking,
        builder: (context, state) => const LiveTrackingScreen(),
      ),
      GoRoute(
        path: '/parent/student-list',
        name: RouteNames.parentStudentList,
        builder: (context, state) => const StudentListScreen(),
      ),
      GoRoute(
        path: '/parent/chat',
        name: RouteNames.parentChat,
        builder: (context, state) => const ChatScreen(),
      ),
      // Supervisor routes
      GoRoute(
        path: '/supervisor/home',
        name: RouteNames.supervisorHome,
        builder: (context, state) => const SupervisorDashboardScreen(),
      ),
      GoRoute(
        path: '/supervisor/booking',
        name: RouteNames.supervisorBooking,
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/supervisor/notifications',
        name: RouteNames.supervisorNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/supervisor/payments',
        name: RouteNames.supervisorPayments,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/supervisor/live-tracking',
        name: RouteNames.supervisorLiveTracking,
        builder: (context, state) => const LiveTrackingScreen(),
      ),
    ],
  );
});
