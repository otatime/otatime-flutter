import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

/// 게시물 검색을 위한 서비스입니다.
class SearchService extends GetService<PostResultModel, Map<String, dynamic>> {
  /// 사용자가 입력한 검색 키워드.
  String keyword = "";

  /// 게시물 검색 API의 경로.
  @override
  String get path => "/posts/search?keyword=$keyword";

  /// JSON 데이터를 `PostResultModel` 객체로 변환합니다.
  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}