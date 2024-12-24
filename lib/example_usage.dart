import 'package:flutter_training/core/security/encryption_service.dart';
import 'package:flutter_training/di/injection_container.dart';

void example() async {
  final encryptionService = sl<EncryptionService>();

  // Veri şifreleme ve kaydetme
  await encryptionService.encryptAndSave('userId', '12345');

  // Şifrelenmiş veriyi alma ve çözme
  final userId = await encryptionService.getDecrypted('userId');
  print('Çözülen userId: $userId'); // 12345

  // Anahtarın var olup olmadığını kontrol etme
  final hasUserId = await encryptionService.hasKey('userId');
  print('userId anahtarı var mı?: $hasUserId'); // true

  // Tüm anahtarları listeleme
  final allKeys = await encryptionService.getAllKeys();
  print('Tüm anahtarlar: $allKeys'); // ['userId', ...]

  // Belirli bir anahtarı silme
  await encryptionService.remove('userId');

  // Tüm şifrelenmiş verileri silme
  await encryptionService.clearAll();
}
