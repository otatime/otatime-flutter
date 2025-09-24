import 'package:otatime_flutter/components/secure/secure_binding.dart';

/// 앱에서 사용되는 인증 토큰의 유형을 정의하는 열거형.
enum TokenType {
  /// API 요청 시 인증에 사용되는 액세스 토큰.
  accessToken("access_token"),

  /// 액세스 토큰이 만료되었을 때 재발급을 위해 사용되는 리프레시 토큰.
  refreshToken("refresh_token");

  /// 보안 저장소에서 토큰을 식별하는 데 사용되는 키.
  final String key;

  const TokenType(this.key);
}

/// 인증 토큰을 안전하게 저장, 검색 및 삭제하기 위한 유틸리티 클래스입니다.
///
/// 이 클래스는 [FlutterSecureStorage]를 사용하여 토큰 값을 영구적으로 관리합니다.
class SecureToken {
  /// 주어진 종류로 토큰 값을 영구적으로 저장합니다.
  static Future<void> set(TokenType type, String value) async {
    await SecureBinding.storage.write(key: type.key, value: value);
  }

  /// 주어진 종류의 토큰 값을 반환합니다.
  static Future<String?> get(TokenType type) async {
    return await SecureBinding.storage.read(key: type.key);
  }

  /// 주어진 종류의 토큰 값을 영구적으로 삭제합니다.
  static Future<void> delete(TokenType type) async {
    await SecureBinding.storage.delete(key: type.key);
  }
}