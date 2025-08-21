import 'package:otatime_flutter/components/service/post_service.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in_model.dart';

class SignInService extends PostService<SignInModel, Map<String, dynamic>> {
  SignInService({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Object? get body => {
    "email" : email,
    "password" : password,
  };

  @override
  String get path => "/login";

  @override
  SignInModel fromJson(Map<String, dynamic> json) {
    return SignInModel.fromJson(json);
  }
}