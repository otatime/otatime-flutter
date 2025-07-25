
/// API 서버에서 응답하는 표준적인 JSON 구조에 대한 인터페이스입니다.
class APIResult<T> {
  const APIResult({
    required this.result,
  });

  final T result;

  factory APIResult.fromJson(Map<String, dynamic> json) {
    return APIResult(
      result: json["result"]
    );
  }
}