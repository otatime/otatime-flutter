import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 앱 내에서 사용되는 보안 저장소 관련 초기화 및 바인딩을 담당합니다.
/// `flutter_secure_storage`를 앱 전역에서 단일 인스턴스로 사용할 수 있도록 제공합니다.
class SecureBinding {
  /// 앱 전역에서 사용되는 `FlutterSecureStorage`의 단일 인스턴스.
  static late final FlutterSecureStorage storage;

  /// 앱 시작 시 호출되어 보안 저장소 인스턴스를 초기화합니다.
  static Future<void> initializeAll() async {
    storage = FlutterSecureStorage();
  }
}