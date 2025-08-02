import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

class HomeService extends GetService<HomeModel, Map<String, dynamic>> {
  HomeService({
    this.category,
    this.location,
  });

  String? category;
  String? location;

  @override
  String get path => "/posts";

  @override
  HomeModel fromJson(Map<String, dynamic> json) {
    return HomeModel.fromJson(json);
  }
}