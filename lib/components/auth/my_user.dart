import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/auth/my_user_model.dart';
import 'package:otatime_flutter/components/auth/my_user_service.dart';
import 'package:otatime_flutter/components/secure/secure_token.dart';

enum MyUserStatus {
  none,
  loading,
  loaded,
  signOut,
}

class MyUser {
  static MyUserModel? _data;
  static MyUserModel get data => _data!;

  static final statusNotifier = ValueNotifier(MyUserStatus.none);
  static MyUserStatus get status => statusNotifier.value;
  static set status(MyUserStatus newStatus) {
    statusNotifier.value = newStatus;
  }

  /// 사용자가 로그아웃 상태인지에 대한 여부를 반환합니다.
  static Future<bool> get isSignOut async {
    return await SecureToken.get(TokenType.accessToken) == null;
  }

  static Future<void> signIn({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      SecureToken.set(TokenType.accessToken, accessToken),
      SecureToken.set(TokenType.refreshToken, refreshToken),
    ]);
  }

  /// 서버 측에 로그아웃 요청을 보내지는 않지만 클라이언트 측에서는
  /// 사용자가 로그아웃되었다는 것을 보장해야 할 때 주로 사용됩니다.
  static Future<void> ensureSignOut() async {
    await Future.wait([
      SecureToken.delete(TokenType.accessToken),
      SecureToken.delete(TokenType.refreshToken),
    ]);
  }

  static Future<void> load() async {
    if (await isSignOut) {
      status = MyUserStatus.signOut;
      return;
    }

    status = MyUserStatus.loading;
    final MyUserService service = MyUserService();
    await service.load();
    _data = service.data;
    status = MyUserStatus.loaded;
  }
}