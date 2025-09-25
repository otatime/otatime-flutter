import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/shared/env.dart';
import 'package:otatime_flutter/components/shared/network.dart';
import 'package:otatime_flutter/pages/address/address_model.dart';

/// 행정안전부 주소정보 API 연동을 위한 기본 서비스 클래스입니다.
///
/// https://business.juso.go.kr/addrlink/openApi/searchApi.do
abstract class BusinessJusoService<T> extends Service<T> {
  /// API 요청에 사용될 전체 경로(URL).
  String get path;

  /// API 응답(JSON)을 특정 데이터 모델 [T]로 변환합니다.
  T fromJson(Map<String, dynamic> json);

  /// API 서버로부터 데이터를 요청하고, 결과를 바탕으로 서비스의 상태를 갱신합니다.
  @override
  Future<void> load({bool isRefresh = false}) async {
    super.load(isRefresh: isRefresh);

    try {
      final Response response = await kDio.get(path);

      if (response.statusCode == 200) {
        done(fromJson(response.data));
        return;
      }
    } catch (error) {
      fail();
      rethrow;
    }
  }
}

/// 키워드를 기반으로 주소를 검색하는 서비스입니다.
class AddressService extends BusinessJusoService<List<AddressModel>> {
  AddressService({required this.keyword});

  /// 주소 검색어.
  final String keyword;

  /// 주소 검색 API를 사용하기 위한 일종의 API 키입니다.
  static final String apiKey = Env.get("ADDRESS_SEARCH_API_KEY");

  /// 주소 검색 API의 엔드포인트 URL입니다.
  static const baseUrl = "https://business.juso.go.kr/addrlink/addrLinkApi.do";

  /// 한 페이지당 검색할 주소의 개수.
  static const countPerPage = 30;

  /// 주소 검색 API 요청을 위한 전체 경로를 생성합니다.
  @override
  String get path {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        "confmKey": apiKey,
        "currentPage": "1",
        "countPerPage": countPerPage.toString(),
        "resultType": "json",
        "keyword": keyword,
      },
    );

    return uri.toString();
  }

  /// 주소 검색 API의 JSON 응답을 [AddressModel] 리스트로 변환합니다.
  @override
  List<AddressModel> fromJson(Map<String, dynamic> json) {
    return AddressResultModel.fromJson(json).items;
  }
}

/// 특정 주소 정보를 바탕으로 좌표(위도, 경도)를 조회하는 서비스입니다.
class LocationService extends BusinessJusoService<LocationResultModel> {
  LocationService({required this.model});

  /// 좌표를 조회할 대상 주소 정보.
  final AddressModel model;

  /// 좌표 조회 API를 사용하기 위한 일종의 API 키입니다.
  static final String apiKey = Env.get("LOCATION_SEARCH_API_KEY");

  /// 주소에 대한 위치 조회 API의 엔드포인트 URL입니다.
  static const baseUrl = "https://business.juso.go.kr/addrlink/addrCoordApi.do";

  /// 주소 좌표 변환 API 요청을 위한 전체 경로를 생성합니다.
  @override
  String get path {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        "confmKey": apiKey,
        "admCd": model.admCd,
        "rnMgtSn": model.rnMgtSn,
        "udrtYn": model.udrtYn,
        "buldMnnm": model.buldMnnm,
        "buldSlno": model.buldSlno,
        "resultType": "json",
      },
    );

    return uri.toString();
  }

  /// 주소 좌표 변환 API의 JSON 응답을 [LocationResultModel]로 변환합니다.
  @override
  LocationResultModel fromJson(Map<String, dynamic> json) {
    return LocationResultModel.fromJson(json);
  }
}