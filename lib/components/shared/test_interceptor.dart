import 'package:dio/dio.dart';

class TestInterceptor extends Interceptor {
  static Map<String, dynamic> postsData = {
    "result": {
      "meta": {
        "currentPage": 0,
        "size": 10,
        "hasNext": true,
      },
      "posts": [
        {
            "postId": 16,
            "title": "NIKKE - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_5bf8138c70b052df43c4ab7c39cc8992a2422834-3840x2160-ori_s_80_50_ori_q_80.webp",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : true,
            "D-Day": 6
        },
        {
            "postId": 17,
            "title": "NIKKE - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_18c203ef6354e344cee4db14427fe22b556d025f-3840x2160-ori_s_80_50_ori_q_80.webp",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : true,
            "D-Day": 6
        },
        {
            "postId": 18,
            "title": "NIKKE - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_26527c23c46bce436b83f65f8e9f3c6da3521017-3840x2160-ori_s_80_50_ori_q_80.webp",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : true,
            "D-Day": 6
        }
      ],
    }
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == "/posts") {
      await Future.delayed(const Duration(seconds: 1));
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: postsData,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}