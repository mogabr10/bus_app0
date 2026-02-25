import 'package:dio/dio.dart';

/// Typed API exception with user-friendly messages.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  final String message;
  final int? statusCode;
  final dynamic data;

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: _messageFromStatusCode(error.response?.statusCode),
          statusCode: error.response?.statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'لا يوجد اتصال بالإنترنت.',
        );
      default:
        return const ApiException(
          message: 'حدث خطأ غير متوقع.',
        );
    }
  }

  static String _messageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح.';
      case 401:
        return 'غير مصرح. يرجى تسجيل الدخول مرة أخرى.';
      case 403:
        return 'ليس لديك صلاحية للوصول.';
      case 404:
        return 'لم يتم العثور على البيانات المطلوبة.';
      case 500:
        return 'خطأ في الخادم. يرجى المحاولة لاحقاً.';
      default:
        return 'حدث خطأ غير متوقع.';
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
