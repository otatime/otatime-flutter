import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

class PostMonthService extends GetService<PostResultModel, Map<String, dynamic>> {
  PostMonthService({required this.date});  

  late DateTime date;

  @override
  String get path => "/posts/month?month=${date.year}-${date.month.toString().padLeft(2, "0")}";

  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}