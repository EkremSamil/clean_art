import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = _getErrorMessage(err);
    final newError = DioException(
      requestOptions: err.requestOptions,
      error: error,
      type: err.type,
      response: err.response,
    );
    handler.next(newError);
  }

  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Bağlantı zaman aşımına uğradı';

      case DioExceptionType.badResponse:
        return _handleResponseError(err.response?.statusCode);

      case DioExceptionType.cancel:
        return 'İstek iptal edildi';

      default:
        return 'Beklenmeyen bir hata oluştu';
    }
  }

  String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek';
      case 401:
        return 'Yetkisiz erişim';
      case 403:
        return 'Erişim reddedildi';
      case 404:
        return 'Bulunamadı';
      case 500:
        return 'Sunucu hatası';
      default:
        return 'Bir hata oluştu';
    }
  }
}
