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
            "D-Day": 3
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
            "isLiked" : false,
            "D-Day": 5
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
            "isLiked" : false,
            "D-Day": 6
        }
      ],
    }
  };

  static Map<String, dynamic> postsBannerData = {
    "result": {
      "meta": {
        "currentPage": 0,
        "size": 10,
        "hasNext": true,
      },
      "posts": [
        {
            "postId": 16,
            "title": "젠레스 존 제로 - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://cdn1.epicgames.com/spt-assets/dcd83ace86fb4501bde1316ca03e29ad/zenless-zone-zero-1voa4.jpg",
            "startDate": "2025-06-25",
            "endDate": "2025-07-01",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : true,
            "D-Day": 3
        },
        {
            "postId": 17,
            "title": "젠레스 존 제로 - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://i.ytimg.com/vi/H-3wo8q0qAk/maxresdefault.jpg",
            "startDate": "2025-06-25",
            "endDate": "2025-07-01",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 5
        },
        {
            "postId": 18,
            "title": "젠레스 존 제로 - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://static.inven.co.kr/column/2024/06/30/news/i1335021753.png",
            "startDate": "2025-06-25",
            "endDate": "2025-07-01",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 6
        }
      ],
    }
  };

  static Map<String, dynamic> postsMonthData = {
    "result": {
      "meta": {
        "currentPage": 0,
        "size": 10,
        "hasNext": true,
      },
      "posts": [
        {
            "postId": 16,
            "title": "젠레스 존 제로 - 2025년 8월 9일부터 개최!",
            "summary": "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
            "imageUrl": "https://i.ytimg.com/vi/DhJrP1aNTgY/hq720.jpg",
            "startDate": "2025-08-11",
            "endDate": "2025-08-13",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : true,
            "D-Day": 3
        }
      ],
    }
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (options.path == "/posts") {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: postsData,
        ),
      );
    }

    if (options.path == "/posts/banner") {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: postsBannerData,
        ),
      );
    }

    if (options.path.contains("/posts/month")) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: postsMonthData,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}