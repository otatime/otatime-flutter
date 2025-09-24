import 'package:otatime_flutter/models/profile.dart';

/// 게시물 데이터를 담는 모델 클래스.
class PostModel {
  const PostModel({
    required this.postId,
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.sector,
    required this.type,
    required this.region,
    required this.location,
    required this.isLiked,
    required this.dDay,
    required this.writer,
  });

  /// 게시물의 고유 식별자.
  final int postId;

  /// 게시물의 제목.
  final String title;

  /// 게시물에 표시될 이미지의 URL.
  final String imageUrl;

  /// 행사 또는 이벤트 시작일.
  final DateTime startDate;

  /// 행사 또는 이벤트 종료일.
  final DateTime endDate;

  /// 게시물의 분야 (예: 애니메이션, 게임).
  final String sector;

  /// 게시물의 유형 (예: 행사, 팝업 스토어).
  final String type;

  /// 행사가 열리는 지역.
  final String region;

  /// 행사의 상세 위치.
  final String location;

  /// 현재 사용자가 이 게시물을 '좋아요' 했는지 여부.
  final bool isLiked;

  /// 행사 시작일까지 남은 일수 (D-Day).
  final int dDay;

  /// 게시물 작성자 정보.
  final ProfileModel writer;

  /// JSON 객체로부터 [PostModel] 인스턴스를 생성합니다.
  factory PostModel.fromJson(Map<String, dynamic> obj) {
    return PostModel(
      postId: obj["postId"],
      title: obj["title"],
      imageUrl: obj["imageUrl"],
      startDate: DateTime.parse(obj["startDate"]),
      endDate: DateTime.parse(obj["endDate"]),
      sector: obj["sector"],
      type: obj["type"],
      region: obj["region"],
      location: obj["location"],
      isLiked: obj["isLiked"],
      dDay: obj["D-Day"],
      writer: ProfileModel.fromJson(obj["writer"]),
    );
  }

  /// JSON 배열로부터 [PostModel] 리스트를 생성합니다.
  static List<PostModel> fromJsonArray(List<dynamic> list) {
    return list.map((item) => PostModel.fromJson(item)).toList();
  }
}
