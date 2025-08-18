import 'package:dio/dio.dart';
import 'package:otatime_flutter/components/api/interface/api_error.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/shared/env.dart';
import 'package:otatime_flutter/components/shared/network.dart';
import 'package:otatime_flutter/pages/address/address_model.dart';

class AddressService extends Service<List<AddressModel>> {
  AddressService({required this.keyword});

  /// 주소 검색어.
  final String keyword;

  /// 주소 검색 API를 사용하기 위한 일종의 API 키입니다.
  String get apiKey => Env.get("ADDRESS_SEARCH_API_KEY");

  /// 주소 검색 API의 엔드포인트 URL입니다.
  static const baseUrl = "https://business.juso.go.kr/addrlink/addrLinkApi.do";

  static const countPerPage = 30;

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
  Future<void> load({bool isRefresh = false}) async {
    super.load(isRefresh: isRefresh);

    try {
      final Response response = await kDio.get(path);

      if (response.statusCode == 200) {
        final model = AddressResultModel.fromJson(response.data);
        done(model.items);
        return;
      }

      throw APIError(type: null, response: response);
    } catch (error) {
      fail();
      rethrow;
    }
  }
}