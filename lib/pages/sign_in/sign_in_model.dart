/// 로그인 성공 시 서버로부터 받는 사용자 인증 및 프로필 정보를 담는 모델.
class SignInModel {
  const SignInModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userName,
    required this.profileImageUrl,
  });

  /// API 요청 시 사용자 인증을 위해 사용되는 액세스 토큰.
  final String accessToken;

  /// 액세스 토큰이 만료되었을 때 재발급을 받기 위한 리프레시 토큰.
  final String refreshToken;

  /// 사용자 이름.
  final String userName;

  /// 사용자 프로필 이미지 URL. 없을 수도 있음.
  final String? profileImageUrl;

  /// JSON 객체로부터 [SignInModel] 인스턴스를 생성합니다.
  factory SignInModel.fromJson(Map<String, dynamic> obj) {
    return SignInModel(
      accessToken: obj["accessToken"],
      refreshToken: obj["refreshToken"],
      userName: obj["username"],
      profileImageUrl: obj["profileImageUrl"],
    );
  }
}
