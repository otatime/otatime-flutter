
abstract class Setting<T> {
  /// 디스크에 저장된 현재 설정값을 역직렬화하여 이를 반환합니다.
  T getValue();

  /// 주어진 설정 값을 직렬화하여 디스크에 영구적으로 저장합니다.
  void setValue(T value);
}