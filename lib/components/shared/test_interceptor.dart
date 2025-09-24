import 'package:dio/dio.dart';

/// 개발 및 테스트 단계에서 실제 서버 API를 호출하는 대신,
/// 미리 정의된 목(Mock) 데이터를 반환하여 UI 개발을 용이하게 하는 테스트용 인터셉터입니다.
class TestInterceptor extends Interceptor {
  /// 일반 게시물 목록에 대한 목 데이터.
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
          "D-Day": 3,
          "writer": {
            "userId": 1,
            "username": "젠레스 존 제로",
            "profileImageUrl": "https://i.namu.wiki/i/qBo0jMNP1u8Xhnbz4iQCb-fSkOj1TTjeIQpGxNaHYOKjX299jKOdhjfId8-amIPM37h0Y_iYP6MIh5tqPZ2vEg.webp",
          }
        },
        {
          "postId": 17,
          "title": "블루 아카이브 - 2025년 8월 1일 개최!",
          "imageUrl": "https://cdn.ipnn.co.kr/news/photo/202210/405624_49081_032.jpg",
          "startDate": "2024-12-07",
          "endDate": "2024-12-09",
          "sector": "애니메이션",
          "type": "콜라보카페",
          "region": "서울",
          "location": "홍대 AK 5층",
          "isLiked" : false,
          "D-Day": 5,
          "writer": {
            "userId": 1,
            "username": "블루 아카이브",
            "profileImageUrl": "https://i.namu.wiki/i/-yJWbNXB_78Cj8yuGFzU4gk1x9-L8CIeHdKQVuQB4JYJ3j33x6Pkigv6tf40dwDSg6RaAzsuEZW96M-P0TTKKg.webp",
          }
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
          "D-Day": 6,
          "writer": {
            "userId": 1,
            "username": "승리의 여신 니케",
            "profileImageUrl": "https://nng-phinf.pstatic.net/MjAyNTA3MDNfMjIw/MDAxNzUxNTI1NDA0MTc5.YhYDiLftKIZWd3NkI21sFJquv59YcUe3IFig-6z8cHwg.dEeWPzIigLkfDWMcHV1hMmMRpPvrv8l3FNRPovgInSwg.PNG/app_icon_full.png",
          }
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
          "D-Day": 6,
          "writer": {
            "userId": 1,
            "username": "스파이 패밀리",
            "profileImageUrl": "https://i.namu.wiki/i/5KgNOA3qDHJHer1P3b1tObK_fTfYUa1aX4GOwNCawJqzcjDP-Tz_I9wcdJImg9YUo67E7o5pgFA5g0BW-mYZkw.webp",
          }
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
          "D-Day": 6,
          "writer": {
            "userId": 1,
            "username": "붕괴 스타레일",
            "profileImageUrl": "https://i.namu.wiki/i/TvflmW8hr6yULWMiO47CJdYvwQb9CvSZvFZPmJ7nyntSMkqmjiP2-PsXvNH0ZEhd2ze3_pQru2_HyvzRyKigYg.webp",
          }
        },
      ],
    }
  };

  /// 배너 게시물 목록에 대한 목 데이터.
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
          "D-Day": 3,
          "writer": {
            "userId": 1,
            "username": "젠레스 존 제로",
            "profileImageUrl": "https://i.namu.wiki/i/qBo0jMNP1u8Xhnbz4iQCb-fSkOj1TTjeIQpGxNaHYOKjX299jKOdhjfId8-amIPM37h0Y_iYP6MIh5tqPZ2vEg.webp",
          }
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
          "D-Day": 5,
          "writer": {
            "userId": 1,
            "username": "젠레스 존 제로",
            "profileImageUrl": "https://i.namu.wiki/i/qBo0jMNP1u8Xhnbz4iQCb-fSkOj1TTjeIQpGxNaHYOKjX299jKOdhjfId8-amIPM37h0Y_iYP6MIh5tqPZ2vEg.webp",
          }
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
          "D-Day": 6,
          "writer": {
            "userId": 1,
            "username": "젠레스 존 제로",
            "profileImageUrl": "https://i.namu.wiki/i/qBo0jMNP1u8Xhnbz4iQCb-fSkOj1TTjeIQpGxNaHYOKjX299jKOdhjfId8-amIPM37h0Y_iYP6MIh5tqPZ2vEg.webp",
          }
        }
      ],
    }
  };

  /// 월별 게시물 목록에 대한 목 데이터. (달력 기능용)
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
          "D-Day": 3,
          "writer": {
            "userId": 1,
            "username": "젠레스 존 제로",
            "profileImageUrl": "https://i.namu.wiki/i/qBo0jMNP1u8Xhnbz4iQCb-fSkOj1TTjeIQpGxNaHYOKjX299jKOdhjfId8-amIPM37h0Y_iYP6MIh5tqPZ2vEg.webp",
          }
        }
      ],
    }
  };

  /// 검색 결과에 대한 목 데이터.
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
          "D-Day": 31,
          "writer": {
            "userId": 1,
            "username": "블루 아카이브",
            "profileImageUrl": "https://i.namu.wiki/i/-yJWbNXB_78Cj8yuGFzU4gk1x9-L8CIeHdKQVuQB4JYJ3j33x6Pkigv6tf40dwDSg6RaAzsuEZW96M-P0TTKKg.webp",
          }
        }
      ],
    }
  };

  /// 검색 결과가 없을 때 사용되는 빈 목 데이터.
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
    // 실제 네트워크 지연을 시뮬레이션하기 위해 1초 대기합니다.
    await Future.delayed(const Duration(seconds: 1));
    
    // 요청 경로에 따라 적절한 목 데이터를 반환합니다.
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

    // 일치하는 경로가 없으면 요청을 계속 진행합니다.
    super.onRequest(options, handler);
  }
}
