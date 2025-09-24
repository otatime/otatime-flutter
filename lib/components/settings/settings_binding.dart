import 'package:otatime_flutter/components/settings/user/theme_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 전반에서 사용되는 설정을 초기화하고 관리합니다.
///
/// 앱 시작 시 [initializeAll]을 호출하여 모든 설정을 로드해야 합니다.
class SettingsBinding {
  /// 키-값 기반의 영구 저장소 인스턴스.
  static late final SharedPreferences prefs;

  /// 앱의 테마 설정을 관리하는 인스턴스.
  static late final ThemeSetting theme;

  /// 앱 실행에 필요한 모든 설정을 초기화합니다.
  static Future<void> initializeAll() async {
    prefs = await SharedPreferences.getInstance();
    theme = ThemeSetting();
  }
}