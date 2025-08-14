import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

class SearchService extends GetService<PostResultModel, Map<String, dynamic>> {
  String keyword = "";

  @override
  String get path => "/posts/search?keyword=$keyword";

  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}