
class Test {
  /// 주어진 문자열이 이메일 형식인지에 대한 여부를 반환합니다.
  static bool isEmail(String input) {
    return RegExp(r"\w+@\w+\.\w+").hasMatch(input);
  }
}