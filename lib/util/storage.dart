import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static SharedPreferences _prefs;

  static Future<bool> init() async {
    if (_prefs != null) {
      return true;
    }

    _prefs = await SharedPreferences.getInstance();
    return _prefs != null;
  }

  static T get<T>(String key) => _prefs.get(key);
  static void setInt(String key, int value) => _prefs.setInt(key, value);
  static void setBool(String key, bool value) => _prefs.setBool(key, value);
  static void setString(String key, String value) =>
      _prefs.setString(key, value);
  static void setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
}
