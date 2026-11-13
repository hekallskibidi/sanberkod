import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_exception.dart';

/// Centralized HTTP client configuration for the application.
class DioClient {
  late final Dio _dio;

  DioClient({Dio? dio}) : _dio = dio ?? Dio() {
    _configureOptions();

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (message) => debugPrint('[DIO CLIENT] $message'),
        ),
      );
    }
  }

  void _configureOptions() {
    _dio.options = BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      // Do not set Content-Type for GET requests. On Flutter Web it can
      // trigger a CORS preflight even though the request has no body.
      headers: const {'Accept': 'application/json'},
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _request<T>(
    Future<Response<T>> Function() requestCall,
  ) async {
    try {
      return await requestCall();
    } catch (error, stackTrace) {
      final failure = ErrorHandler.handle(error);
      Error.throwWithStackTrace(failure, stackTrace);
    }
  }

  void close({bool force = false}) {
    _dio.close(force: force);
  }
}
