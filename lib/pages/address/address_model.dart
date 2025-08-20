
class AddressResultModel {
  const AddressResultModel({
    required this.common,
    required this.items,
  });

  final AddressCommonAsPageModel common;
  final List<AddressModel> items;

  factory AddressResultModel.fromJson(Map<String, dynamic> obj) {
    return AddressResultModel(
      common: AddressCommonAsPageModel.fromJson(obj["results"]["common"]),
      items: AddressModel.fromJsonArray(obj["results"]["juso"] ?? []),
    );
  }
}

class LocationResultModel {
  const LocationResultModel({
    required this.common,
    required this.model,
  });

  final AddressCommonModel common;
  final LocationModel model;

  factory LocationResultModel.fromJson(Map<String, dynamic> obj) {
    print(obj);
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

  final int totalCount;
  final String errorCode;
  final String errorMessage;

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

  final int currentPage;
  final int countPerPage;

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

  final String? detBdNmList;      // 상세건물명목록
  final String engAddr;           // 영문주소
  final String rn;                // 도로명
  final String emdNm;             // 읍면동명
  final String zipNo;             // 우편번호
  final String? roadAddrPart2;    // 도로명주소(참고항목)
  final String emdNo;             // 읍면동일련번호
  final String sggNm;             // 시군구명
  final String jibunAddr;         // 지번주소
  final String siNm;              // 시도명
  final String roadAddrPart1;     // 도로명주소(주요부분)
  final String? bdNm;             // 건물명
  final String admCd;             // 행정구역코드
  final String udrtYn;            // 지하여부 (0: 지상, 1: 지하)
  final String lnbrMnnm;          // 지번본번(번지)
  final String roadAddr;          // 도로명주소
  final String lnbrSlno;          // 지번부번(호)
  final String buldMnnm;          // 건물본번
  final String bdKdcd;            // 건물종류코드
  final String? liNm;             // 법정리명
  final String rnMgtSn;           // 도로명관리번호
  final String mtYn;              // 산여부 (0: 대지, 1: 산)
  final String bdMgtSn;           // 건물관리번호
  final String buldSlno;          // 건물부번
  final String? relJibun;         // 관련지번
  final String? hemdNm;           // 관할주민센터

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

  static List<AddressModel> fromJsonArray(List<dynamic> list) {
    return list.map((item) => AddressModel.fromJson(item)).toList();
  }
}

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

  final String admCd;     // 행정구역코드
  final String rnMgtSn;   // 도로명코드
  final String bdMgtSn;   // 건물관리번호
  final String udrtYn;    // 지하여부(0 : 지상, 1 : 지하)
  final int buldMnnm;     // 건물본번
  final int buldSlno;     // 건물부번
  final double entX;      // X좌표
  final double entY;      // Y좌표
  final String? bdNm;     // 건물명

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