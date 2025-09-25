import 'package:otatime_flutter/components/service/post_service.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in_model.dart';

/// 사용자 로그인을 처리하는 서비스.
class SignInService extends PostService<SignInModel, Map<String, dynamic>> {
  SignInService({
    required this.email,
    required this.password,
  });

  /// 사용자 이메일.
  final String email;

  /// 사용자 비밀번호.
  final String password;

  /// 로그인 요청에 사용될 본문.
  @override
  Object? get body => {
    "email" : email,
    "password" : password,
  };

  /// 로그인 API의 엔드포인트 경로.
  @override
  String get path => "/login";

  /// JSON 응답을 [SignInModel]로 변환합니다.
  @override
  SignInModel fromJson(Map<String, dynamic> json) {
    return SignInModel.fromJson(json);
  }
}