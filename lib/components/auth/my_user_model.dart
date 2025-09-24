/// 현재 로그인한 사용자의 정보를 담는 모델 클래스.
class MyUserModel {
  const MyUserModel({
    required this.userId,
    required this.email,
    required this.userName,
    required this.profileImageUrl,
    required this.adoptionCount,
  });

  /// 사용자의 고유 식별자.
  final int userId;

  /// 사용자의 이메일 주소.
  final String email;

  /// 사용자의 이름.
  final String userName;

  /// 사용자의 프로필 이미지 URL.
  final String? profileImageUrl;

  /// 사용자가 등록한 제보(채택) 수.
  final int adoptionCount;

  /// JSON 객체로부터 [MyUserModel] 인스턴스를 생성합니다.
  factory MyUserModel.fromJson(Map<String, dynamic> obj) {
    return MyUserModel(
      userId: obj["userId"],
      email: obj["email"],
      userName: obj["username"],
      profileImageUrl: obj["profileImageUrl"],
      adoptionCount: obj["adoptionCount"],
    );
  }
}
