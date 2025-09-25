import 'package:otatime_flutter/components/service/post_service.dart';
import 'package:otatime_flutter/pages/sign_up/sign_up_model.dart';

/// 회원가입 요청을 처리하는 서비스.
class SignUpService extends PostService<SignUpModel, Map<String, dynamic>> {
  /// 회원가입에 필요한 사용자 정보를 받아 서비스를 생성합니다.
  SignUpService({
    required this.username,
    required this.email,
    required this.password,
  });

  /// 사용자 이름.
  final String username;

  /// 사용자 이메일.
  final String email;

  /// 사용자 비밀번호.
  final String password;

  /// 회원가입 API의 경로.
  @override
  String get path => "/join";

  /// API 요청에 사용될 본문(body).
  @override
  Object? get body => {
    "username": username,
    "email": email,
    "password": password,
  };

  /// JSON 응답을 [SignUpModel] 객체로 변환합니다.
  @override
  SignUpModel fromJson(Map<String, dynamic> json) {
    return SignUpModel.fromJson(json);
  }
}