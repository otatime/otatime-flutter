import 'package:otatime_flutter/components/auth/my_user_model.dart';
import 'package:otatime_flutter/components/service/get_service.dart';

class MyUserService extends GetService<MyUserModel, Map<String, dynamic>> {
  @override
  String get path => "/me";

  @override
  MyUserModel fromJson(Map<String, dynamic> json) {
    return MyUserModel.fromJson(json);
  }
}