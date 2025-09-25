import 'package:otatime_flutter/components/service/get_service.dart';
import 'package:otatime_flutter/pages/home/home_model.dart';

/// 게시글 목록을 가져오는 서비스. 필터링 조건을 포함할 수 있습니다.
class PostService extends GetService<PostResultModel, Map<String, dynamic>> {
  PostService({
    this.category,
    this.location,
  });

  /// 검색할 게시글의 카테고리.
  String? category;

  /// 검색할 게시글의 지역.
  String? location;

  /// 검색 기간의 시작일.
  DateTime? startDate;

  /// 검색 기간의 종료일.
  DateTime? endDate;

  /// 게시글 목록을 요청하는 API 경로.
  @override
  String get path => "/posts";

  /// JSON 데이터를 PostResultModel 객체로 변환합니다.
  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}

/// 홈 화면 상단에 표시될 배너 게시글을 가져오는 서비스.
class PostBannerService extends GetService<PostResultModel, Map<String, dynamic>> {
  /// 배너 게시글을 요청하는 API 경로.
  @override
  String get path => "/posts/banner";

  /// JSON 데이터를 PostResultModel 객체로 변환합니다.
  @override
  PostResultModel fromJson(Map<String, dynamic> json) {
    return PostResultModel.fromJson(json);
  }
}