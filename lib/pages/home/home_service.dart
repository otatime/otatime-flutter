import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

class PostService extends GetService<PostResultModel, Map<String, dynamic>> {
  PostService({
    this.category,
    this.location,
  });

  String? category;
  String? location;
  DateTime? startDate;
  DateTime? endDate;

  @override
  String get path => "/posts";

  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}

class PostBannerService extends GetService<PostResultModel, Map<String, dynamic>> {
  @override
  String get path => "/posts/banner";

  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}