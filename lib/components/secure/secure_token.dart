import 'package:otatime_flutter/components/secure/secure_binding.dart';

enum TokenType {
  accessToken("access_token"),
  refreshToken("refresh_token");

  final String key;
  const TokenType(this.key);
}

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