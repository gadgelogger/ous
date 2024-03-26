//テーマカラーの設定を保存するためのクラス
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesInstance {
  static late final SharedPreferences _prefs;
  static final SharedPreferencesInstance _instance =
      SharedPreferencesInstance._internal();
  factory SharedPreferencesInstance() => _instance;

  SharedPreferencesInstance._internal();

  SharedPreferences get prefs => _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
