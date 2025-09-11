
class ProfileModel {
  const ProfileModel({
    required this.userId,
    required this.username,
    required this.profileImageUrl,
  });

  final int userId;
  final String username;
  final String profileImageUrl;

  factory ProfileModel.fromJson(Map<String, dynamic> obj) {
    return ProfileModel(
      userId: obj["userId"],
      username: obj["username"],
      profileImageUrl: obj["profileImageUrl"],
    );
  }
}