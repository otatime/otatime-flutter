extension StringExtension on String {
  /// 현재 문자열을 기반으로 SVG 에셋 경로를 생성하여 반환합니다.
  String get svg => "assets/svg/$this.svg";

  /// 현재 문자열을 기반으로 PNG 에셋 경로를 생성하여 반환합니다.
  String get png => "assets/image/$this.png";
}
