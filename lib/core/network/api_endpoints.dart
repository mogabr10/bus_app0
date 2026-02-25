/// Centralised API endpoint constants.
///
/// Group endpoints by feature so they're easy to find and update.
abstract final class ApiEndpoints {
  /// Base URL — swap per environment (dev / staging / prod).
  static const String baseUrl = 'https://api.example.com/v1';

  // ── Auth ────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // ── Trips / Tracking ────────────────────────────────────────────────
  static const String trips = '/trips';
  static String tripById(String id) => '/trips/$id';
  static const String liveTracking = '/tracking/live';

  // ── Students ────────────────────────────────────────────────────────
  static const String students = '/students';
  static String studentById(String id) => '/students/$id';

  // ── Notifications ───────────────────────────────────────────────────
  static const String notifications = '/notifications';

  // ── Booking ─────────────────────────────────────────────────────────
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';

  // ── Payments ────────────────────────────────────────────────────────
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';

  // ── Chat ────────────────────────────────────────────────────────────
  static const String conversations = '/chat/conversations';
  static String messages(String conversationId) =>
      '/chat/conversations/$conversationId/messages';
}
