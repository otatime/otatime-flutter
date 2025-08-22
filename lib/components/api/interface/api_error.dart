
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

  final String title;
  final int status;
  final String detail;

  factory APIError.fromJson(Map<String, dynamic> obj) {
    return APIError(
      title: obj["title"],
      status: obj["status"],
      detail: obj["detail"],
    );
  }

  @override
  String toString() {
    return "{title: $title, status: $status, detail: $detail}";
  }
}