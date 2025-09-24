import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/api/interface/api_error.dart';
import 'package:otatime_flutter/components/api/interface/api_result.dart';
import 'package:otatime_flutter/components/service/service.dart';

/// [Service]를 확장하여 HTTP 요청을 통해 데이터를 로드하는 추상 클래스입니다.
/// 
/// 일반적으로 API 요청 경로와 JSON 역직렬화 방식만 지정하면,
/// 공통된 데이터 로딩 로직을 재사용할 수 있도록 설계되어 있습니다.
/// 
/// 제네릭 [T]는 가공된 데이터, 즉 최종 인스턴스의 형식을 정의합니다.
/// 제네릭 [K]는 가공되기 전의 원시 데이터 형식을 정의합니다.
abstract class RestService<T, K> extends Service<T> {

  /// API 요청 시 사용될 경로를 반환합니다.
  String get path;

  /// JSON 응답 본문을 파싱하여 [T] 타입의 데이터로 변환합니다.
  T fromJson(K json);

  /// HTTP 요청을 수행한 후, 서버로부터 받은 응답을 반환합니다.
  Future<Response> request();

  /// 서버로부터 데이터를 로드하는 공통 로직을 구현합니다.
  ///
  /// [request]를 호출하여 API 요청을 수행하고, 성공 시 응답 데이터를 파싱하여 [done]을 호출합니다.
  /// 요청 중 오류가 발생하면 [fail]을 호출하고, 서버 응답 오류는 표준 [APIError]로 변환하여 throw합니다.
  @override
  Future<void> load({bool isRefresh = false}) async {
    super.load(isRefresh: isRefresh);

    try {
      final Response response = await request();

      if (response.statusCode == 200) {
        final APIResult result = APIResult.fromJson(response.data);
        final T parsedData = fromJson(result.result);
        done(parsedData);
        return;
      }
    } catch (error) {
      fail();

      if (error is DioException) {
        final APIError dto = APIError.fromJson(error.response!.data["error"]);
        throw dto;
      }

      rethrow;
    }
  }
}