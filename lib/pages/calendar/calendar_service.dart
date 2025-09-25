import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

/// 주어진 월에 해당하는 게시물 목록을 가져오는 서비스입니다.
class PostMonthService extends GetService<PostResultModel, Map<String, dynamic>> {
  PostMonthService({required this.date});

  /// 게시물을 조회할 기준 날짜.
  late DateTime date;

  /// 월별 게시물 조회를 위한 API 경로.
  @override
  String get path => "/posts/month?month=${date.year}-${date.month.toString().padLeft(2, "0")}";

  /// JSON 응답을 PostResultModel 객체로 변환합니다.
  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}