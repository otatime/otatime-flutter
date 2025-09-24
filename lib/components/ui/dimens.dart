/// 앱 전반의 UI 레이아웃에 일관된 크기 및 여백 값을 제공하는 클래스입니다.
class Dimens {
  /// 화면이나 주요 컨테이너의 외부 여백.
  static const double outerPadding = 15;

  /// 컴포넌트 내부의 여백.
  static const double innerPadding = 15;

  /// 일반적인 컨테이너의 모서리 둥글기 값.
  static const double borderRadius = 15;

  /// 보조적으로 사용되는 작은 모서리 둥글기 값.
  static const double borderRadius2 = 10;

  /// [Row] 위젯 내부 요소들 사이의 수평 간격.
  static const double rowSpacing = innerPadding / 2;

  /// [Column] 위젯 내부 요소들 사이의 수직 간격.
  static const double columnSpacing = rowSpacing;

  /// 카드 형태 UI의 테두리 선 두께.
  static const double cardLineWidth = 0.5;
}