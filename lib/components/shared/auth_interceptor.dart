import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/api/interface/api_result.dart';
import 'package:otatime_flutter/components/auth/my_user.dart';
import 'package:otatime_flutter/components/secure/secure_token.dart';
import 'package:otatime_flutter/components/shared/network.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in_model.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.remove("authorization");

    // API 요청 시, 인증을 위해 정의된 액세스 토큰을 헤더에 삽입합니다.
    final String? accessToken = await SecureToken.get(TokenType.accessToken);
    if (accessToken != null) {
      options.headers["authorization"] = _authHeaderOf(accessToken);
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {

    // 사용자 인증 실패 시.
    if (err.response?.statusCode == 401) {
      return await _handleUnauthorized(err, handler);
    }

    return super.onError(err, handler);
  }

  /// 인증이 실패했을 경우, 리프레시 토큰을 사용하여 액세스 토큰을 갱신하고 요청을 재시도합니다.
  /// 리프레시 토큰이 없거나 갱신에 실패한 경우, 기존 오류를 그대로 전달합니다.
  Future<void> _handleUnauthorized(DioException error, ErrorInterceptorHandler handler) async {
    final String? refreshToken = await SecureToken.get(TokenType.refreshToken);

    // 리프레시 토큰이 존재한다면, 이를 사용하여 액세스 토큰을 갱신하고 재요청합니다.
    if (refreshToken != null) {
      try {
        await _refreshAccessToken(refreshToken);
      } catch (_) {

        // 리프레시 토큰으로도 엑세스 토큰 발급을 실패 했을 떄 사용자를 로그아웃 처리하도록 보장.
        MyUser.ensureSignOut();
        return handler.reject(error);
      }

      final Response retryed = await kDio.fetch(error.requestOptions);
      return handler.resolve(retryed);
    }

    handler.reject(error);
  }

  /// 주어진 리프레시 토큰을 사용하여 액세스 토큰에 대한 재발급을 요청합니다.
  Future<void> _refreshAccessToken(String refreshToken) async {
    final Options options = Options(
      headers: {"authorization": _authHeaderOf(refreshToken)},
    );

    final Response response = await kDio.post("/re-issue", options: options);
    final APIResult<SignInModel> dto = APIResult.fromJson(response.data);

    await MyUser.signIn(
      accessToken: dto.result.accessToken,
      refreshToken: dto.result.refreshToken,
    );
  }

  /// 주어진 엑세스 토큰 문자열을 `authorization` 헤더의 유효한 값으로 변환합니다.
  String _authHeaderOf(String accessToken) => "Bearer $accessToken";
}