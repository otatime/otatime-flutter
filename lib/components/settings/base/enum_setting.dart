import 'package:otatime_flutter/components/settings/setting.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';

abstract class EnumSetting<T extends Enum> extends Setting<T> {
  String get key;

  /// 설정 값은 항상 null이 될 수 없으므로 기본 값을 정의할 필요가 있습니다.
  T get defaultValue;

  /// 설정 값에서 정의될 수 있는 모든 열거형 값들을 리스트 형태로 반환합니다.
  List<T> get values;

  @override
  T getValue() {
    final int index = SettingsBinding.prefs.getInt(key) ?? defaultValue.index;
    return values[index];
  }

  @override
  void setValue(T newValue) async {
    await SettingsBinding.prefs.setInt(key, newValue.index);
  }
}