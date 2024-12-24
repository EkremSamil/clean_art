import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_training/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_training/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_training/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_training/core/constants/api_constants.dart';
import 'package:flutter_training/di/injection_container.dart';
import 'package:flutter_training/core/error/exceptions.dart';

class ApiClient {
  Dio _dio = sl<Dio>();
  final AuthInterceptor _authInterceptor;

  ApiClient(this._authInterceptor) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _authInterceptor,
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  // GET
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<T> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<T> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<T> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Dosya upload
  Future<T> upload<T>({
    required String path,
    required File file,
    Map<String, dynamic>? extraData,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        if (extraData != null) ...extraData,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Dosya download
  Future<void> download({
    required String url,
    required String savePath,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('İstek zaman aşımına uğradı: ${e.message}');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        return _handleResponseError(statusCode, data);

      case DioExceptionType.cancel:
        return RequestCancelledException();

      case DioExceptionType.connectionError:
        return NetworkException('Ağ bağlantısı hatası: ${e.message}');

      default:
        return UnexpectedException('Beklenmeyen bir hata: ${e.message}');
    }
  }

  Exception _handleResponseError(int? statusCode, dynamic data) {
    final message = data?['message'] as String? ?? 'Bir hata oluştu';

    switch (statusCode) {
      case 400:
        if (data?['errors'] is Map) {
          return ValidationException(message, errors: Map<String, String>.from(data!['errors']));
        }
        return BadRequestException(message);

      case 401:
        return UnauthorizedException(message);

      case 403:
        return ForbiddenException(message);

      case 404:
        return NotFoundException(message);

      case 500:
        return ServerException(message);

      default:
        return UnexpectedException(message);
    }
  }
}
