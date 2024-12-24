import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final FlutterSecureStorage _storage;
  static const _keyPrefix = 'encrypted_';
  static const _ivPrefix = 'iv_';

  EncryptionService(this._storage);

  Future<void> encryptAndSave(String key, String data) async {
    try {
      // Veriyi şifrele
      final encrypted = await encrypt(data);

      // Şifrelenmiş veriyi kaydet
      await _storage.write(
        key: _keyPrefix + key,
        value: encrypted,
      );
    } catch (e) {
      throw EncryptionException('Veri şifreleme hatası: $e');
    }
  }

  /// Güvenli depolama alanından veriyi alır ve şifresini çözer
  Future<String?> getDecrypted(String key) async {
    try {
      final encrypted = await _storage.read(key: _keyPrefix + key);
      if (encrypted == null) return null;

      return await decrypt(encrypted);
    } catch (e) {
      throw EncryptionException('Veri şifre çözme hatası: $e');
    }
  }

  /// Veriyi şifreler
  Future<String> encrypt(String data) async {
    try {
      // Rastgele IV (Initialization Vector) oluştur
      final iv = _generateIV();

      // Şifreleme anahtarını al veya oluştur
      final key = await _getOrCreateKey();

      // Veriyi şifrele
      final bytes = utf8.encode(data);
      final hash = sha256.convert(bytes);

      // Base64 formatına çevir
      return base64.encode(hash.bytes);
    } catch (e) {
      throw EncryptionException('Şifreleme hatası: $e');
    }
  }

  /// Şifrelenmiş veriyi çözer
  Future<String> decrypt(String encryptedData) async {
    try {
      // Base64'ten byte array'e çevir
      final bytes = base64.decode(encryptedData);

      // Şifre çözme işlemi
      final decrypted = utf8.decode(bytes);

      return decrypted;
    } catch (e) {
      throw EncryptionException('Şifre çözme hatası: $e');
    }
  }

  /// Tüm şifrelenmiş verileri siler
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw EncryptionException('Veri silme hatası: $e');
    }
  }

  /// Belirli bir anahtara ait şifrelenmiş veriyi siler
  Future<void> remove(String key) async {
    try {
      await _storage.delete(key: _keyPrefix + key);
      await _storage.delete(key: _ivPrefix + key);
    } catch (e) {
      throw EncryptionException('Veri silme hatası: $e');
    }
  }

  /// Rastgele IV oluşturur
  List<int> _generateIV() {
    final random = List<int>.generate(16, (i) => DateTime.now().millisecondsSinceEpoch % 255);
    return random;
  }

  /// Şifreleme anahtarını alır veya oluşturur
  Future<String> _getOrCreateKey() async {
    const keyId = 'encryption_key';
    String? key = await _storage.read(key: keyId);

    if (key == null) {
      key = base64.encode(_generateIV());
      await _storage.write(key: keyId, value: key);
    }

    return key;
  }

  /// Bir anahtarın var olup olmadığını kontrol eder
  Future<bool> hasKey(String key) async {
    final value = await _storage.read(key: _keyPrefix + key);
    return value != null;
  }

  /// Tüm şifrelenmiş anahtarları listeler
  Future<List<String>> getAllKeys() async {
    try {
      final allItems = await _storage.readAll();
      return allItems.keys
          .where((key) => key.startsWith(_keyPrefix))
          .map((key) => key.replaceFirst(_keyPrefix, ''))
          .toList();
    } catch (e) {
      throw EncryptionException('Anahtar listesi alınamadı: $e');
    }
  }
}

/// Şifreleme işlemlerinde oluşabilecek hataları yönetir
class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}
