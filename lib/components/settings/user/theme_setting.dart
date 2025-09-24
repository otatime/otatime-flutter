import 'package:otatime_flutter/components/settings/base/enum_setting.dart';

/// 앱의 전체적인 테마 유형을 정의합니다.
enum Theme {
  /// OS 기기 설정을 따름.
  device,

  /// 라이트 모드.
  light,

  /// 다크 모드.
  dark
}

/// 앱의 테마 설정을 관리하는 클래스입니다.
class ThemeSetting extends EnumSetting<Theme> {
  @override
  /// SharedPreferences에 저장될 때 사용되는 키.
  String get key => "theme";

  @override
  /// 설정값이 없을 때 사용될 기본 테마.
  Theme get defaultValue => Theme.device;

  @override
  /// 선택 가능한 모든 테마 목록.
  List<Theme> get values => Theme.values;
}
