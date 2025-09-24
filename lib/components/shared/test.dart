/// 애플리케이션 전반에서 사용되는 다양한 유효성 검사 유틸리티를 제공합니다.
class Test {
  /// 주어진 문자열이 이메일 형식인지에 대한 여부를 반환합니다.
  static bool isEmail(String input) {
    return RegExp(r"\w+@\w+\.\w+").hasMatch(input);
  }
}