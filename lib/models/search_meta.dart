/// 검색 결과의 메타데이터(페이지네이션 정보)를 담는 모델 클래스.
class SearchMetaModel {
  const SearchMetaModel({
    required this.currentPage,
    required this.size,
    required this.hasNext,
  });

  /// 현재 페이지 번호.
  final int currentPage;

  /// 한 페이지에 표시되는 항목의 수.
  final int size;

  /// 다음 페이지가 있는지 여부.
  final bool hasNext;

  /// JSON 객체로부터 [SearchMetaModel] 인스턴스를 생성합니다.
  factory SearchMetaModel.fromJson(Map<String, dynamic> obj) {
    return SearchMetaModel(
      currentPage: obj["currentPage"],
      size: obj["size"],
      hasNext: obj["hasNext"],
    );
  }
}
