import 'package:otatime_flutter/components/service/post_service.dart';
import 'package:otatime_flutter/pages/sign_up/sign_up_model.dart';

class SignUpService extends PostService<SignUpModel, Map<String, dynamic>> {
  SignUpService({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  @override
  String get path => "/join";

  @override
  Object? get body => {
    "username": username,
    "email": email,
    "password": password,
  };

  @override
  SignUpModel fromJson(Map<String, dynamic> json) {
    return SignUpModel.fromJson(json);
  }
}