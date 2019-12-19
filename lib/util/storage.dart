import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs == null) {
      throw "SharedPreferences初始化失败";
    }
  }

  static T get<T>(String key) => _prefs.get(key);
  static Future<void> setInt(String key, int value) =>
      _prefs.setInt(key, value);
  static Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);
  static Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  static Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
}
