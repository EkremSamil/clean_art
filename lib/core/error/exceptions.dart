/// Temel exception sınıfı
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Network ile ilgili hatalar
class NetworkException extends AppException {
  NetworkException([super.message = 'Ağ bağlantısı hatası']) : super(code: 'NETWORK_ERROR');
}

/// Timeout hataları
class TimeoutException extends AppException {
  TimeoutException([super.message = 'İstek zaman aşımına uğradı']) : super(code: 'TIMEOUT');
}

/// Server hataları (500)
class ServerException extends AppException {
  ServerException([super.message = 'Sunucu hatası']) : super(code: 'SERVER_ERROR');
}

/// Yetkilendirme hataları (401)
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Yetkisiz erişim']) : super(code: 'UNAUTHORIZED');
}

/// Erişim reddi hataları (403)
class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'Erişim reddedildi']) : super(code: 'FORBIDDEN');
}

/// Bulunamadı hataları (404)
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Kaynak bulunamadı']) : super(code: 'NOT_FOUND');
}

/// Geçersiz istek hataları (400)
class BadRequestException extends AppException {
  BadRequestException([super.message = 'Geçersiz istek']) : super(code: 'BAD_REQUEST');
}

/// İstek iptal edildi hataları
class RequestCancelledException extends AppException {
  RequestCancelledException([super.message = 'İstek iptal edildi']) : super(code: 'REQUEST_CANCELLED');
}

/// Cache ile ilgili hatalar
class CacheException extends AppException {
  CacheException([super.message = 'Önbellek hatası']) : super(code: 'CACHE_ERROR');
}

/// Parse hataları
class ParseException extends AppException {
  ParseException([super.message = 'Veri ayrıştırma hatası']) : super(code: 'PARSE_ERROR');
}

/// Validation hataları
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException(super.message, {this.errors}) : super(code: 'VALIDATION_ERROR', details: errors);
}

/// Beklenmeyen hatalar
class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'Beklenmeyen bir hata oluştu']) : super(code: 'UNEXPECTED_ERROR');
}

/// API response format hataları
class ApiResponseFormatException extends AppException {
  ApiResponseFormatException([super.message = 'API yanıt format hatası']) : super(code: 'API_RESPONSE_FORMAT_ERROR');
}

/// Token yenileme hataları
class TokenRefreshException extends AppException {
  TokenRefreshException([super.message = 'Token yenileme hatası']) : super(code: 'TOKEN_REFRESH_ERROR');
}
