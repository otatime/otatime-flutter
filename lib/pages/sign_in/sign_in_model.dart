
class SignInModel {
  const SignInModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userName,
    required this.profileImageUrl,
  });

  final String accessToken;
  final String refreshToken;
  final String userName;
  final String profileImageUrl;

  factory SignInModel.fromJson(Map<String, dynamic> obj) {
    return SignInModel(
      accessToken: obj["accessToken"],
      refreshToken: obj["refreshToken"],
      userName: obj["username"],
      profileImageUrl: obj["profileImageUrl"],
    );
  }
}