
class MyUserModel {
  const MyUserModel({
    required this.userId,
    required this.email,
    required this.userName,
    required this.profileImageUrl,
    required this.adoptionCount,
  });

  final int userId;
  final String email;
  final String userName;
  final String? profileImageUrl;
  final int adoptionCount;

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