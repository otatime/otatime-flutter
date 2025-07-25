import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/shared/test_interceptor.dart';

/// API 서버에 대한 도메인 주소가 정의됩니다.
final String kUrl = "https://www.otatime.com";

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
)..interceptors.add(TestInterceptor());