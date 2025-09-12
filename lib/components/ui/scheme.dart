import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/settings/user/theme_setting.dart';

/// 해당 클래스는 특정 테마에 대한 색상들을 정의합니다.
abstract class Scheme {
  Color get primary;
  Color get deepPrimary;
  Color get background;
  Color get backgroundInInput;
  Color get backgroundInPopup;
  Color get deepground;
  Color get rearground;
  Color get reargroundInBackground;
  Color get foreground;
  Color get foreground2;
  Color get foreground3;
  Color get border;
  Color get placeholder;
  Color get highlight;
  Color get barrier;
  Color get imageOverlayBackground;
  Color get imageOverlayForeground;

  static final Color transparent = Color.fromRGBO(0, 0, 0, 0);
  static final Color white = Color.fromRGBO(255, 255, 255, 1);
  static final Color black = Color.fromRGBO(0, 0, 0, 1);
  static final Color negative = Color(0xFFF03737);
  static final Color saturday = Color.fromRGBO(255, 45, 45, 1);
  static final Color sunday = Color.fromRGBO(0, 150, 255, 1);

  static final LightScheme _light = LightScheme();
  static final DarkScheme _dark = DarkScheme();

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

  static Theme themeOf(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => Theme.light,
      Brightness.dark => Theme.dark,
    };
  }
}

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
}

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
}