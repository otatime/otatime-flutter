
class SignUpModel {
  const SignUpModel({
    required this.userId,
  });

  final int userId;

  factory SignUpModel.fromJson(Map<String, dynamic> obj) {
    return SignUpModel(userId: obj["userId"]);
  }
}