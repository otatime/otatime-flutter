import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/shared/auth_interceptor.dart';
import 'package:otatime_flutter/components/shared/test_interceptor.dart';

/// API 서버에 대한 도메인 주소가 정의됩니다.
final String kUrl = "http://3.35.92.114:8080";

/// 앱 내에서 전역적으로 사용되는 [Dio] 인스턴스입니다.
final Dio kDio = Dio(
  BaseOptions(
    baseUrl: kUrl,
    responseType: ResponseType.json,
    headers: {
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )
)
// 요청 시 인증 토큰을 처리하는 인터셉터를 추가합니다.
..interceptors.add(AuthInterceptor())
// 테스트용 응답을 가로채는 인터셉터를 추가합니다.
..interceptors.add(TestInterceptor());
