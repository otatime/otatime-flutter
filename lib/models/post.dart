
class PostModel {
  const PostModel({
    required this.postId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.sector,
    required this.type,
    required this.region,
    required this.location,
    required this.isLiked,
    required this.dDay,
  });

  final int postId;
  final String title;
  final String summary;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final String sector;
  final String type;
  final String region;
  final String location;
  final bool isLiked;
  final int dDay;

  factory PostModel.fromJson(Map<String, dynamic> obj) {
    return PostModel(
      postId: obj["postId"],
      title: obj["title"],
      summary: obj["summary"],
      imageUrl: obj["imageUrl"],
      startDate: obj["startDate"],
      endDate: obj["endDate"],
      sector: obj["sector"],
      type: obj["type"],
      region: obj["region"],
      location: obj["location"],
      isLiked: obj["isLiked"],
      dDay: obj["D-Day"],
    );
  }

  static List<PostModel> fromJsonArray(List<Map<String, dynamic>> list) {
    return list.map((item) => PostModel.fromJson(item)).toList();
  }
}