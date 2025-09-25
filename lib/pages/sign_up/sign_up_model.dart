/// 회원가입 응답 데이터를 표현하는 모델.
class SignUpModel {
  const SignUpModel({
    required this.userId,
  });

  /// 사용자의 고유 식별자.
  final int userId;

  /// JSON 객체로부터 `SignUpModel` 인스턴스를 생성합니다.
  factory SignUpModel.fromJson(Map<String, dynamic> obj) {
    return SignUpModel(userId: obj["userId"]);
  }
}