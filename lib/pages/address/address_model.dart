/// 주소 검색 결과를 정의하는 모델입니다. (공통 정보 + 주소 목록)
class AddressResultModel {
  const AddressResultModel({
    required this.common,
    required this.items,
  });

  /// 주소 검색 결과의 공통 정보.
  final AddressCommonAsPageModel common;

  /// 주소 검색 결과 목록.
  final List<AddressModel> items;

  /// JSON 객체로부터 [AddressResultModel] 인스턴스를 생성합니다.
  factory AddressResultModel.fromJson(Map<String, dynamic> obj) {
    return AddressResultModel(
      common: AddressCommonAsPageModel.fromJson(obj["results"]["common"]),
      items: AddressModel.fromJsonArray(obj["results"]["juso"] ?? []),
    );
  }
}

/// 좌표 검색 결과를 정의하는 모델입니다.
class LocationResultModel {
  const LocationResultModel({
    required this.common,
    required this.model,
  });

  /// 좌표 검색 결과의 공통 정보.
  final AddressCommonModel common;

  /// 좌표 검색 결과.
  final LocationModel model;

  /// JSON 객체로부터 [LocationResultModel] 인스턴스를 생성합니다.
  factory LocationResultModel.fromJson(Map<String, dynamic> obj) {
    return LocationResultModel(
      common: AddressCommonModel.fromJson(obj["results"]["common"]),
      model: LocationModel.fromJson(obj["results"]["juso"][0]),
    );
  }
}

/// 일반적인 단일 조회 API에 대한 데이터 응답에 사용됩니다.
class AddressCommonModel {
  const AddressCommonModel({
    required this.totalCount,
    required this.errorCode,
    required this.errorMessage,
  });

  /// 총 검색 결과 수.
  final int totalCount;

  /// 오류 코드.
  final String errorCode;

  /// 오류 메시지.
  final String errorMessage;

  /// JSON 객체로부터 [AddressCommonModel] 인스턴스를 생성합니다.
  factory AddressCommonModel.fromJson(Map<String, dynamic> obj) {
    return AddressCommonModel(
      totalCount: int.parse(obj["totalCount"]),
      errorCode: obj["errorCode"],
      errorMessage: obj["errorMessage"],
    );
  }
}

/// 페이지 단위의 조회 API에 대한 데이터 응답에 사용됩니다.
class AddressCommonAsPageModel extends AddressCommonModel {
  const AddressCommonAsPageModel({
    required super.totalCount,
    required this.currentPage,
    required this.countPerPage,
    required super.errorCode,
    required super.errorMessage,
  });

  /// 현재 페이지 번호.
  final int currentPage;

  /// 페이지 당 출력할 결과 Row 수.
  final int countPerPage;

  /// JSON 객체로부터 [AddressCommonAsPageModel] 인스턴스를 생성합니다.
  factory AddressCommonAsPageModel.fromJson(Map<String, dynamic> obj) {
    return AddressCommonAsPageModel(
      totalCount: int.parse(obj["totalCount"]),
      currentPage: int.parse(obj["currentPage"]),
      countPerPage: int.parse(obj["countPerPage"]),
      errorCode: obj["errorCode"],
      errorMessage: obj["countPerPage"],
    );
  }
}

/// 주소 데이터(도로명, 지번, 건물명 등)를 정의하는 모델입니다.
class AddressModel {
  const AddressModel({
    required this.detBdNmList,
    required this.engAddr,
    required this.rn,
    required this.emdNm,
    required this.zipNo,
    required this.roadAddrPart2,
    required this.emdNo,
    required this.sggNm,
    required this.jibunAddr,
    required this.siNm,
    required this.roadAddrPart1,
    required this.bdNm,
    required this.admCd,
    required this.udrtYn,
    required this.lnbrMnnm,
    required this.roadAddr,
    required this.lnbrSlno,
    required this.buldMnnm,
    required this.bdKdcd,
    required this.liNm,
    required this.rnMgtSn,
    required this.mtYn,
    required this.bdMgtSn,
    required this.buldSlno,
    required this.relJibun,
    required this.hemdNm,
  });

  /// 상세 건물명 목록.
  final String? detBdNmList;

  /// 영문 주소.
  final String engAddr;

  /// 도로명.
  final String rn;

  /// 읍/면/동명.
  final String emdNm;

  /// 우편번호.
  final String zipNo;

  /// 도로명주소 참고항목.
  final String? roadAddrPart2;

  /// 읍/면/동 일련번호.
  final String emdNo;

  /// 시/군/구명.
  final String sggNm;

  /// 지번 주소.
  final String jibunAddr;

  /// 시/도명.
  final String siNm;

  /// 도로명주소 주요부분.
  final String roadAddrPart1;

  /// 건물명.
  final String? bdNm;

  /// 행정구역 코드.
  final String admCd;

  /// 지하 여부 (0: 지상, 1: 지하).
  final String udrtYn;

  /// 지번 본번(번지).
  final String lnbrMnnm;

  /// 전체 도로명 주소.
  final String roadAddr;

  /// 지번 부번(호).
  final String lnbrSlno;

  /// 건물 본번.
  final String buldMnnm;

  /// 건물 종류 코드.
  final String bdKdcd;

  /// 법정리명.
  final String? liNm;

  /// 도로명 관리 번호.
  final String rnMgtSn;

  /// 산 여부 (0: 대지, 1: 산).
  final String mtYn;

  /// 건물 관리 번호.
  final String bdMgtSn;

  /// 건물 부번.
  final String buldSlno;

  /// 관련 지번.
  final String? relJibun;

  /// 관할 주민센터.
  final String? hemdNm;

  /// JSON 객체로부터 [AddressModel] 인스턴스를 생성합니다.
  factory AddressModel.fromJson(Map<String, dynamic> obj) {
    return AddressModel(
      detBdNmList: obj["detBdNmList"],
      engAddr: obj["engAddr"],
      rn: obj["rn"],
      emdNm: obj["emdNm"],
      zipNo: obj["zipNo"],
      roadAddrPart2: obj["roadAddrPart2"],
      emdNo: obj["emdNo"],
      sggNm: obj["sggNm"],
      jibunAddr: obj["jibunAddr"],
      siNm: obj["siNm"],
      roadAddrPart1: obj["roadAddrPart1"],
      bdNm: obj["bdNm"],
      admCd: obj["admCd"],
      udrtYn: obj["udrtYn"],
      lnbrMnnm: obj["lnbrMnnm"],
      roadAddr: obj["roadAddr"],
      lnbrSlno: obj["lnbrSlno"],
      buldMnnm: obj["buldMnnm"],
      bdKdcd: obj["bdKdcd"],
      liNm: obj["liNm"],
      rnMgtSn: obj["rnMgtSn"],
      mtYn: obj["mtYn"],
      bdMgtSn: obj["bdMgtSn"],
      buldSlno: obj["buldSlno"],
      relJibun: obj["relJibun"],
      hemdNm: obj["hemdNm"],
    );
  }

  /// JSON 배열로부터 [AddressModel] 객체 목록을 생성합니다.
  static List<AddressModel> fromJsonArray(List<dynamic> list) {
    return list.map((item) => AddressModel.fromJson(item)).toList();
  }
}

/// 좌표 기반 위치 데이터(건물번호, 좌표 등)를 정의하는 모델입니다.
class LocationModel {
  const LocationModel({
    required this.admCd,
    required this.rnMgtSn,
    required this.bdMgtSn,
    required this.udrtYn,
    required this.buldMnnm,
    required this.buldSlno,
    required this.entX,
    required this.entY,
    required this.bdNm,
  });

  /// 행정구역 코드.
  final String admCd;

  /// 도로명 코드.
  final String rnMgtSn;

  /// 건물 관리 번호.
  final String bdMgtSn;

  /// 지하 여부 (0: 지상, 1: 지하).
  final String udrtYn;

  /// 건물 본번.
  final int buldMnnm;

  /// 건물 부번.
  final int buldSlno;

  /// X좌표.
  final double entX;

  /// Y좌표.
  final double entY;

  /// 건물명.
  final String? bdNm;

  /// JSON 객체로부터 [LocationModel] 인스턴스를 생성합니다.
  factory LocationModel.fromJson(Map<String, dynamic> obj) {
    return LocationModel(
      admCd: obj["admCd"],
      rnMgtSn: obj["rnMgtSn"],
      bdMgtSn: obj["bdMgtSn"],
      udrtYn: obj["udrtYn"],
      buldMnnm: int.parse(obj["buldMnnm"]),
      buldSlno: int.parse(obj["buldSlno"]),
      entX: double.parse(obj["entX"]),
      entY: double.parse(obj["entY"]),
      bdNm: obj["bdNm"],
    );
  }
}