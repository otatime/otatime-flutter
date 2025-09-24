import 'package:otatime_flutter/components/settings/setting.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';

/// [Setting]을 확장하여 열거형([Enum]) 기반의 설정을 관리하기 위한 추상 클래스입니다.
///
/// 열거형 값을 정수 인덱스로 변환하여 저장하고, 다시 열거형 값으로 변환하여
/// 불러오는 공통 로직을 제공합니다.
abstract class EnumSetting<T extends Enum> extends Setting<T> {
  /// 설정 저장을 위한 고유 키.
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