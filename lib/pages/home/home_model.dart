import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/models/search_meta.dart';

class PostResultModel {
  const PostResultModel({
    required this.posts,
    required this.meta,
  });

  final List<PostModel> posts;
  final SearchMetaModel meta;

  factory PostResultModel.fromJson(Map<String, dynamic> obj) {
    return PostResultModel(
      posts: PostModel.fromJsonArray(obj["posts"]),
      meta: SearchMetaModel.fromJson(obj["meta"]),
    );
  }
}