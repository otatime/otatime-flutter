import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/widgets/address_select_box.dart';
import 'package:otatime_flutter/widgets/calendar_select_box.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/image_select_box.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/labeled_box.dart';
import 'package:otatime_flutter/widgets/select_box.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

/// 사용자로부터 새로운 행사나 정보를 제보받는 페이지.
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  /// 상위 분류에서 선택된 항목의 인덱스.
  int sectorIndex = 0;

  /// 하위 분류에서 선택된 항목의 인덱스.
  int typeIndex = 0;

  /// 사용자가 선택한 시작 날짜.
  DateTime? startDate;

  /// 사용자가 선택한 종료 날짜.
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: HeaderConnection(
              title: "제보",
              child: ListView(
                padding: EdgeInsets.all(Dimens.outerPadding),
                children: [
                  // 제보할 내용과 관련된 이미지를 선택하는 영역.
                  ImageSelectBox(
                    onChanged: (newFile) => {},
                  ),

                  SizedBox(height: Dimens.innerPadding),

                  // 제보 항목의 상위 분류를 선택하는 영역.
                  LabeledBox(
                    label: "상위 분류",
                    child: SelectBox(
                      index: sectorIndex,
                      items: ["선택되지 않음", "애니메이션", "게임", "행사", "공연", "캐릭터", "성우 행사"],

                      // 새로운 상위 분류가 선택되면 상태를 업데이트.
                      onChanged: (newValue) {
                        setState(() => sectorIndex = newValue);
                      },
                    ),
                  ),

                  SizedBox(height: Dimens.innerPadding),

                  // 제보 항목의 하위 분류를 선택하는 영역.
                  LabeledBox(
                    label: "하위 분류",
                    child: SelectBox(
                      index: typeIndex,
                      items: ["선택되지 않음", "아이템 1", "아이템 2", "아이템 3"],

                      // 새로운 하위 분류가 선택되면 상태를 업데이트.
                      onChanged: (newValue) {
                        setState(() => typeIndex = newValue);
                      },
                    ),
                  ),
                  SizedBox(height: Dimens.innerPadding),
                  // 행사의 시작일과 종료일을 선택하는 영역.
                  LabeledBox(
                    label: "시작 및 종료 날짜",
                    child: CalendarSelectBox.range(
                      startDate: startDate,
                      endDate: endDate,

                      // 새로운 시작 날짜가 선택되면 상태를 업데이트.
                      onStartChanged: (newValue) {
                        setState(() => startDate = newValue);
                      },

                      // 새로운 종료 날짜가 선택되면 상태를 업데이트.
                      onEndChanged: (newValue) {
                        setState(() => endDate = newValue);
                      },
                    ),
                  ),

                  SizedBox(height: Dimens.innerPadding),

                  // 행사가 열리는 위치를 선택하는 영역.
                  LabeledBox(
                    label: "행사 위치",
                    child: AddressSelectBox(onChanged: (address) {}),
                  ),

                  // 섹션 간의 추가 간격.
                  SizedBox(height: Dimens.innerPadding * 2),

                  // '상세 정보' 섹션 제목.
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.innerPadding),
                    child: Text(
                      "상세 정보",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: Dimens.innerPadding),

                  // 제보 내용의 제목을 입력하는 필드.
                  InputField(hintText: "제목"),
                  SizedBox(height: Dimens.innerPadding),

                  // 제보 내용에 대한 간략한 소개를 입력하는 필드.
                  InputField(hintText: "간략한 소개", maxLines: null),
                  SizedBox(height: Dimens.innerPadding),

                  // 제보 내용에 대한 상세 정보를 입력하는 필드.
                  InputField(hintText: "자세한 정보", minLines: 10, maxLines: null),
                ],
              ),
            ),
          ),
          // 페이지 하단의 '제보하기' 버튼을 감싸는 영역.
          Padding(
            padding: EdgeInsets.only(
              left: Dimens.outerPadding,
              right: Dimens.outerPadding,
              bottom: Dimens.outerPadding,
            ),

            // 입력된 정보를 제출하는 '제보하기' 버튼.
            child: WideButton(label: "제보하기", onTap: () {}),
          ),
        ],
      ),
    );
  }
}