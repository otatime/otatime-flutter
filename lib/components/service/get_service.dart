import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/service/rest_service.dart';
import 'package:otatime_flutter/components/shared/network.dart';

/// [RestService]를 확장하여 HTTP GET 요청을 통해 데이터를 로드하는 추상 클래스입니다.
abstract class GetService<T, K> extends RestService<T, K> {
  @override
  Future<Response> request() => kDio.get(path);
}