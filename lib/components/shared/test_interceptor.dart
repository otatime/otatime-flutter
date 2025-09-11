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
            "title": "젠레스 존 제로 - 2025년 8월 1일 개최!",
            "imageUrl": "https://fastcdn.hoyoverse.com/content-v2/nap/122921/2a96623f81d3acbdfdd3d152dd362411_6370061938803802843.png",
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
            "title": "블루아카이브 - 2025년 8월 1일 개최!",
            "imageUrl": "https://cdn.ipnn.co.kr/news/photo/202210/405624_49081_032.jpg",
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
            "title": "승리의 여신 니케 - 2025년 8월 1일 개최!",
            "imageUrl": "https://i3.ruliweb.com/img/23/12/03/18c2de6163f566c33.jpg",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 6
        },
        {
            "postId": 18,
            "title": "스파이 패밀리 - 2025년 8월 1일 개최!",
            "imageUrl": "https://mblogthumb-phinf.pstatic.net/MjAyMjA1MDdfMTM2/MDAxNjUxOTMwODQ3Njc3.rz2eEvPW6zBVhXgWM67df4EJw515qK7B-N_N8p6ueTgg.paAt3V8gYPKuH9sHpY0EM8k9KcED_hRgdaFibo1n-Gsg.JPEG.jgwkrrk/SPFB-gallery11.jpg?type=w800",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 6
        },
        {
            "postId": 18,
            "title": "붕괴 스타레일 - 2025년 8월 1일 개최!",
            "imageUrl": "https://pbs.twimg.com/media/GJlUbxUbkAA2ae3.jpg",
            "startDate": "2024-12-07",
            "endDate": "2024-12-09",
            "sector": "애니메이션",
            "type": "콜라보카페",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 6
        },
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
            "imageUrl": "https://pbs.twimg.com/media/GRK6HmbaUAAE48u.jpg",
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

  static Map<String, dynamic> postsSearchData = {
    "result": {
      "meta": {
        "currentPage": 0,
        "size": 10,
        "hasNext": true,
      },
      "posts": [
        {
            "postId": 16,
            "title": "블루 아카이브 페스티벌 - 2023년 5월 20일",
            "imageUrl": "https://cdn.gameple.co.kr/news/photo/202305/205842_213810_3453.jpg",
            "startDate": "2023-05-20",
            "endDate": "2023-05-21",
            "sector": "게임",
            "type": "페스티벌",
            "region": "서울",
            "location": "홍대 AK 5층",
            "isLiked" : false,
            "D-Day": 31
        }
      ],
    }
  };

  static Map<String, dynamic> postsEmtpyData = {
    "result": {
      "meta": {
        "currentPage": 0,
        "size": 10,
        "hasNext": false,
      },
      "posts": [],
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

    if (options.path.contains("/posts/search")) {
      if (options.path.contains("블루")
       || options.path.contains("아카이브")) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: postsSearchData,
          ),
        );
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: postsEmtpyData,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}