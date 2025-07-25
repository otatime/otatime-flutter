
class SearchMetaModel {
  const SearchMetaModel({
    required this.currentPage,
    required this.size,
    required this.hasNext,
  });

  final int currentPage;
  final int size;
  final bool hasNext;

  factory SearchMetaModel.fromJson(Map<String, dynamic> obj) {
    return SearchMetaModel(
      currentPage: obj["currentPage"],
      size: obj["size"],
      hasNext: obj["hasNext"],
    );
  }
}