import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/settings/user/theme_setting.dart';

/// 해당 클래스는 특정 테마에 대한 색상들을 정의합니다.
abstract class Scheme {
  Color get primary;
  Color get background;
  Color get deepground;
  Color get rearground;
  Color get foreground;
  Color get foreground2;
  Color get foreground3;
  Color get border;
  Color get placeholder;
  Color get highlight;

  static final Color transparent = Color.fromRGBO(0, 0, 0, 0);
  static final Color white = Color.fromRGBO(255, 255, 255, 1);
  static final Color black = Color.fromRGBO(0, 0, 0, 1);

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
}

class LightScheme extends Scheme {
  @override Color get primary => Color(0xFF0077FF);
  @override Color get background => Color.fromRGBO(255, 255, 255, 1);
  @override Color get deepground => Color.fromRGBO(245, 245, 245, 1);
  @override Color get rearground => Color.fromRGBO(235, 235, 235, 1);
  @override Color get foreground => Scheme.black;
  @override Color get foreground2 => Color.fromRGBO(100, 100, 100, 1);
  @override Color get foreground3 => Color.fromRGBO(150, 150, 150, 1);
  @override Color get border => Color.fromRGBO(0, 0, 0, 0.1);
  @override Color get placeholder => rearground;
  @override Color get highlight => Color.fromRGBO(0, 0, 0, 0.2);
}

class DarkScheme extends Scheme {
  @override Color get primary => Color(0xFF0077FF);
  @override Color get background => Color.fromRGBO(10, 10, 12, 1);
  @override Color get deepground => Color.fromRGBO(30, 30, 32, 1);
  @override Color get rearground => Color.fromRGBO(40, 40, 42, 1);
  @override Color get foreground => Scheme.white;
  @override Color get foreground2 => Color.fromRGBO(150, 150, 150, 1);
  @override Color get foreground3 => Color.fromRGBO(100, 100, 100, 1);
  @override Color get border => Color.fromRGBO(255, 255, 255, 0.1);
  @override Color get placeholder => rearground;
  @override Color get highlight => Color.fromRGBO(255, 255, 255, 0.2);
}