import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/auth/my_user_model.dart';
import 'package:otatime_flutter/components/auth/my_user_service.dart';
import 'package:otatime_flutter/components/secure/secure_token.dart';

/// 현재 사용자의 인증 및 데이터 로드 상태를 나타내는 열거형입니다.
enum MyUserStatus {
  /// 초기 상태. 아무 작업도 수행되지 않았습니다.
  none,

  /// 사용자 정보를 서버로부터 불러오는 중입니다.
  loading,

  /// 사용자 정보를 성공적으로 불러왔습니다.
  loaded,

  /// 사용자가 로그아웃한 상태입니다.
  signOut,
}

/// 앱 전반에서 현재 로그인된 사용자의 상태와 데이터를 관리하는 정적 클래스입니다.
class MyUser {
  /// 현재 로그인된 사용자의 데이터 모델입니다.
  static MyUserModel? _data;
  
  /// 현재 로그인된 사용자의 데이터에 안전하게 접근하기 위한 getter입니다.
  static MyUserModel get data => _data!;

  /// 사용자 상태 변경을 감지하고 UI를 업데이트하기 위한 [ValueNotifier]입니다.
  static final statusNotifier = ValueNotifier(MyUserStatus.none);

  /// 현재 사용자의 상태를 반환합니다.
  static MyUserStatus get status => statusNotifier.value;

  /// 현재 사용자의 상태를 주어진 값으로 업데이트하고 리스너에게 알립니다.
  static set status(MyUserStatus newStatus) {
    statusNotifier.value = newStatus;
  }

  /// 사용자가 로그아웃 상태인지에 대한 여부를 반환합니다.
  static Future<bool> get isSignOut async {
    return await SecureToken.get(TokenType.accessToken) == null;
  }

  /// 주어진 액세스 토큰과 리프레시 토큰을 안전하게 저장하여 로그인 상태를 유지합니다.
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

  /// 로그인된 사용자의 정보를 서버로부터 불러옵니다. 이 과정에서 상태가 변경됩니다.
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
