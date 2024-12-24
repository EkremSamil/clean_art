import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  String? getToken() => _prefs.getString('token');
}
