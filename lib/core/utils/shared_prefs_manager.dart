import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefsManager {
  final SharedPreferences _prefs;

  SharedPrefsManager(this._prefs);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  bool getBool(String key) => _prefs.getBool(key) ?? false;

  Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<bool> remove(String key) async => await _prefs.remove(key);

  Future<bool> clear() async => await _prefs.clear();
}
