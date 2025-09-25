import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/models/search_meta.dart';

/// 게시글 검색 결과를 나타내는 모델.
class PostResultModel {
  const PostResultModel({
    required this.posts,
    required this.meta,
  });

  /// 검색된 게시글 목록.
  final List<PostModel> posts;

  /// 검색 결과에 대한 메타 정보 (예: 총 페이지 수, 현재 페이지 등).
  final SearchMetaModel meta;

  /// 주어진 JSON 객체로부터 [PostResultModel] 인스턴스를 생성합니다.
  factory PostResultModel.fromJson(Map<String, dynamic> obj) {
    return PostResultModel(
      posts: PostModel.fromJsonArray(obj["posts"]),
      meta: SearchMetaModel.fromJson(obj["meta"]),
    );
  }
}