import 'package:otatime_flutter/components/settings/user/theme_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBinding {
  static late final SharedPreferences prefs;
  static late final ThemeSetting theme;

  static Future<void> initializeAll() async {
    prefs = await SharedPreferences.getInstance();
    theme = ThemeSetting();
  }
}