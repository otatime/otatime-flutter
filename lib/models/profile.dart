/// 사용자 프로필 데이터를 담는 모델 클래스.
class ProfileModel {
  const ProfileModel({
    required this.userId,
    required this.username,
    required this.profileImageUrl,
  });

  /// 사용자의 고유 식별자.
  final int userId;

  /// 사용자의 이름.
  final String username;

  /// 사용자 프로필 이미지의 URL.
  final String profileImageUrl;

  /// JSON 객체로부터 [ProfileModel] 인스턴스를 생성합니다.
  factory ProfileModel.fromJson(Map<String, dynamic> obj) {
    return ProfileModel(
      userId: obj["userId"],
      username: obj["username"],
      profileImageUrl: obj["profileImageUrl"],
    );
  }
}
