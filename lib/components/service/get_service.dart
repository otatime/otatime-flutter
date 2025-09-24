import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/service/rest_service.dart';
import 'package:otatime_flutter/components/shared/network.dart';

/// [RestService]를 확장하여 HTTP GET 요청을 통해 데이터를 로드하는 추상 클래스입니다.
abstract class GetService<T, K> extends RestService<T, K> {
  /// [path]에 대한 GET 요청을 수행하여 서버 응답을 반환합니다.
  @override
  Future<Response> request() => kDio.get(path);
}
