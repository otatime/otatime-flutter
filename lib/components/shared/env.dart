import 'package:flutter_dotenv/flutter_dotenv.dart';

/// `.env` 파일에 정의된 환경 변수를 관리하는 정적 클래스입니다.
class Env {
  /// 주어진 키에 해당하는 환경 변수 값을 반환합니다.
  static String get(String key) {
    return dotenv.get(key);
  }

  /// `.env` 파일을 로드하여 환경 변수를 초기화합니다.
  /// 이 메서드는 앱이 시작될 때 호출되어야 합니다.
  static Future<void> initializeAll() async {
    await dotenv.load(fileName: ".env");
  }
}
