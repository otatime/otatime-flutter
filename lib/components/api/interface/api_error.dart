import 'package:dio/dio.dart';

/// API에 대한 에러 유형을 코드에서 추적 가능하도록 표준화하며,
/// 예외 처리를 더 명확하게 할 수 있도록 돕는 인터페이스입니다.
class APIError<T> {
  const APIError({
    required this.type,
    required this.response
  });

  final T type;
  final Response response;
}