import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/shared/env.dart';
import 'package:otatime_flutter/components/shared/network.dart';
import 'package:otatime_flutter/pages/address/address_model.dart';

/// https://business.juso.go.kr/addrlink/openApi/searchApi.do
abstract class BusinessJusoService<T> extends Service<T> {
  String get path;

  T fromJson(Map<String, dynamic> json);

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

class AddressService extends BusinessJusoService<List<AddressModel>> {
  AddressService({required this.keyword});

  /// 주소 검색어.
  final String keyword;

  /// 주소 검색 API를 사용하기 위한 일종의 API 키입니다.
  static final String apiKey = Env.get("ADDRESS_SEARCH_API_KEY");

  /// 주소 검색 API의 엔드포인트 URL입니다.
  static const baseUrl = "https://business.juso.go.kr/addrlink/addrLinkApi.do";

  static const countPerPage = 30;

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
  
  @override
  List<AddressModel> fromJson(Map<String, dynamic> json) {
    return AddressResultModel.fromJson(json).items;
  }
}

/// 상세 주소 -> 좌표(위도, 경도)
class LocationService extends BusinessJusoService<LocationResultModel> {
  LocationService({required this.model});

  final AddressModel model;

  /// 좌표 조회 API를 사용하기 위한 일종의 API 키입니다.
  static final String apiKey = Env.get("LOCATION_SEARCH_API_KEY");

  /// 주소에 대한 위치 조회 API의 엔드포인트 URL입니다.
  static const baseUrl = "https://business.juso.go.kr/addrlink/addrCoordApi.do";

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

  @override
  LocationResultModel fromJson(Map<String, dynamic> json) {
    return LocationResultModel.fromJson(json);
  }
}