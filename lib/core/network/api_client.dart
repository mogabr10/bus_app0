import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'api_exceptions.dart';

/// Configured [Dio] singleton for all API calls.
///
/// Call [ApiClient.init] once at app startup to configure base options,
/// interceptors (auth, logging, retry), etc.
class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  /// Initialise the Dio instance with base URL and default headers.
  void init({String? authToken}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    _dio.interceptors.addAll([
      _LoggingInterceptor(),
    ]);
  }

  /// Update the auth token after login.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear the auth token on logout.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Add structured logging
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = ApiException.fromDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
        response: err.response,
      ),
    );
  }
}
