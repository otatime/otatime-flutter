import 'package:otatime_flutter/components/auth/my_user_model.dart';
import 'package:otatime_flutter/components/service/get_service.dart';

/// 현재 인증된 사용자의 프로필 정보를 서버로부터 가져오는 서비스입니다.
class MyUserService extends GetService<MyUserModel, Map<String, dynamic>> {
  /// 사용자 정보를 가져오기 위한 API 경로입니다.
  @override
  String get path => "/me";

  /// JSON 객체를 [MyUserModel] 인스턴스로 변환합니다.
  @override
  MyUserModel fromJson(Map<String, dynamic> json) {
    return MyUserModel.fromJson(json);
  }
}