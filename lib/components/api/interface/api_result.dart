/// API 서버에서 응답하는 표준적인 JSON 구조에 대한 인터페이스입니다.
class APIResult<T> {
  const APIResult({
    required this.result,
  });

  /// API 응답의 실제 데이터 페이로드.
  final T result;

  /// JSON 객체로부터 [APIResult] 인스턴스를 생성합니다.
  factory APIResult.fromJson(Map<String, dynamic> json) {
    return APIResult(
      result: json["result"]
    );
  }
}
