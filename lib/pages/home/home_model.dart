import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/models/search_meta.dart';

class HomeModel {
  const HomeModel({
    required this.posts,
    required this.meta,
  });

  final List<PostModel> posts;
  final SearchMetaModel meta;

  factory HomeModel.fromJson(Map<String, dynamic> obj) {
    return HomeModel(
      posts: PostModel.fromJsonArray(obj["posts"]),
      meta: SearchMetaModel.fromJson(obj["meta"]),
    );
  }
}