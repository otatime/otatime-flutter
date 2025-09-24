import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/settings/user/theme_setting.dart';

/// 앱의 라이트/다크 테마에 따라 UI에 사용될 색상들을 정의하는 추상 클래스입니다.
///
/// 이 클래스를 통해 앱 전체의 색상 일관성을 유지하고, 테마 변경을 쉽게 관리할 수 있습니다.
abstract class Scheme {
  /// 앱의 주요 상호작용 요소나 하이라이트에 사용되는 기본 색상.
  Color get primary;
  /// `primary` 색상보다 연하거나 투명도가 있는 버전으로, 주로 배경이나 효과에 사용.
  Color get deepPrimary;
  /// 앱의 가장 기본적인 배경색.
  Color get background;
  /// 입력 필드(InputField)의 배경색.
  Color get backgroundInInput;
  /// 팝업 창의 배경색.
  Color get backgroundInPopup;
  /// 기본 배경(`background`) 위에 표시되는 카드나 섹션 등의 배경색.
  Color get deepground;
  /// `deepground`보다 더 깊은 계층의 UI 요소 배경색.
  Color get rearground;
  /// `background` 위에 표시되는 `rearground` 색상.
  Color get reargroundInBackground;
  /// `background` 위에 표시되는 주된 텍스트나 아이콘 색상.
  Color get foreground;
  /// 보조적인 텍스트나 아이콘에 사용되는 색상.
  Color get foreground2;
  /// 가장 옅은 텍스트나 아이콘, 비활성화된 요소에 사용되는 색상.
  Color get foreground3;
  /// UI 요소들의 경계선을 나타내는 색상.
  Color get border;
  /// 이미지나 콘텐츠가 로드되기 전에 표시되는 영역의 배경색.
  Color get placeholder;
  /// 사용자가 항목을 터치하거나 선택했을 때 나타나는 하이라이트 효과 색상.
  Color get highlight;
  /// 모달 팝업이나 바텀 시트 뒤에 표시되는 어두운 배경색.
  Color get barrier;
  /// 이미지 위에 텍스트를 표시할 때 가독성을 높이기 위한 배경 오버레이 색상.
  Color get imageOverlayBackground;
  /// 이미지 위에 텍스트를 표시할 때 사용되는 텍스트 색상.
  Color get imageOverlayForeground;
  /// 콘텐츠를 구분하는 데 사용되는 라인 색상.
  Color get separatedLine;

  /// 투명 색상.
  static final Color transparent = Color.fromRGBO(0, 0, 0, 0);
  /// 흰색.
  static final Color white = Color.fromRGBO(255, 255, 255, 1);
  /// 검은색.
  static final Color black = Color.fromRGBO(0, 0, 0, 1);
  /// 오류나 부정적인 상태를 나타내는 색상.
  static final Color negative = Color(0xFFF03737);
  /// 달력에서 토요일을 나타내는 색상.
  static final Color saturday = Color.fromRGBO(255, 45, 45, 1);
  /// 달력에서 일요일을 나타내는 색상.
  static final Color sunday = Color.fromRGBO(0, 150, 255, 1);

  /// 라이트 테마 [Scheme] 인스턴스.
  static final LightScheme _light = LightScheme();
  /// 다크 테마 [Scheme] 인스턴스.
  static final DarkScheme _dark = DarkScheme();

  /// 디바이스의 현재 시스템 테마(밝기)를 가져옵니다.
  static Brightness get device {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  /// 현재 설정된 테마에 따라 적절한 [Scheme] 인스턴스를 반환합니다.
  static Scheme get current {
    return switch (SettingsBinding.theme.getValue()) {
      Theme.device => device == Brightness.light ? _light : _dark,
      Theme.light => _light,
      Theme.dark => _dark
    };
  }

  /// 주어진 [Brightness]에 해당하는 [Theme] 열거형 값을 반환합니다.
  static Theme themeOf(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => Theme.light,
      Brightness.dark => Theme.dark,
    };
  }
}

/// 라이트 모드에 대한 색상 구성표입니다.
class LightScheme extends Scheme {
  @override Color get primary => Color(0xFF0077FF);
  @override Color get deepPrimary => primary.withAlpha(30);
  @override Color get background => Color.fromRGBO(245, 247, 250, 1);
  @override Color get backgroundInInput => deepground;
  @override Color get backgroundInPopup => background.withAlpha(200);
  @override Color get deepground => Scheme.white;
  @override Color get rearground => Color.fromRGBO(245, 245, 245, 1);
  @override Color get reargroundInBackground => Color.fromRGBO(235, 235, 235, 1);
  @override Color get foreground => Scheme.black;
  @override Color get foreground2 => Color.fromRGBO(120, 120, 120, 1);
  @override Color get foreground3 => Color.fromRGBO(180, 180, 180, 1);
  @override Color get border => Color.fromRGBO(0, 0, 0, 0.1);
  @override Color get placeholder => reargroundInBackground;
  @override Color get highlight => Color.fromRGBO(100, 100, 100, 0.1);
  @override Color get barrier => Scheme.black.withAlpha(150);
  @override Color get imageOverlayBackground => Scheme.black.withAlpha(100);
  @override Color get imageOverlayForeground => Scheme.white.withAlpha(150);
  @override Color get separatedLine => Color.fromRGBO(235, 237, 240, 1);
}

/// 다크 모드에 대한 색상 구성표입니다.
class DarkScheme extends Scheme {
  @override Color get primary => Color(0xFF0077FF);
  @override Color get deepPrimary => primary.withAlpha(50);
  @override Color get background => Color.fromRGBO(12, 12, 14, 1);
  @override Color get backgroundInInput => Scheme.black;
  @override Color get backgroundInPopup => rearground.withAlpha(200);
  @override Color get deepground => Color.fromRGBO(30, 30, 33, 1);
  @override Color get rearground => Color.fromRGBO(40, 40, 43, 1);
  @override Color get reargroundInBackground => rearground;
  @override Color get foreground => Scheme.white;
  @override Color get foreground2 => Color.fromRGBO(150, 150, 150, 1);
  @override Color get foreground3 => Color.fromRGBO(100, 100, 100, 1);
  @override Color get border => Color.fromRGBO(255, 255, 255, 0.1);
  @override Color get placeholder => rearground;
  @override Color get highlight => Color.fromRGBO(255, 255, 255, 0.1);
  @override Color get barrier => Scheme.black.withAlpha(150);
  @override Color get imageOverlayBackground => Scheme.black.withAlpha(100);
  @override Color get imageOverlayForeground => Scheme.white.withAlpha(150);
  @override Color get separatedLine => Scheme.black;
}