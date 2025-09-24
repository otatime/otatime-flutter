/// API에 대한 에러 유형을 코드에서 추적 가능하도록 표준화하며,
/// 예외 처리를 더 명확하게 할 수 있도록 돕는 인터페이스입니다.
///
/// 즉, 서버 측에서 응답하는 에러 정보의 표준적인 DTO에 가깝습니다.
class APIError {
  const APIError({
    required this.title,
    required this.status,
    required this.detail,
  });

  /// 오류에 대한 간략한 제목.
  final String title;

  /// HTTP 상태 코드.
  final int status;

  /// 오류에 대한 상세 설명.
  final String detail;

  /// JSON 객체로부터 [APIError] 인스턴스를 생성합니다.
  factory APIError.fromJson(Map<String, dynamic> obj) {
    return APIError(
      title: obj["title"],
      status: obj["status"],
      detail: obj["detail"],
    );
  }

  /// [APIError] 객체를 디버깅하기 쉬운 문자열 형태로 변환합니다.
  @override
  String toString() {
    return "{title: $title, status: $status, detail: $detail}";
  }
}
