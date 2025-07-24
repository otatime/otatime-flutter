import 'package:otatime_flutter/components/settings/base/enum_setting.dart';

enum Theme {
  device,
  light,
  dark
}

class ThemeSetting extends EnumSetting<Theme> {
  @override
  String get key => "theme";

  @override
  Theme get defaultValue => Theme.device;

  @override
  List<Theme> get values => Theme.values;
}