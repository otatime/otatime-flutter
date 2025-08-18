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

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int sectorIndex = 0;
  int typeIndex = 0;

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: HeaderConnection(
            title: "제보",
            child: ListView(
              padding: EdgeInsets.all(Dimens.outerPadding),
              children: [
                ImageSelectBox(
                  onChanged: (newFile) => {},
                ),
                SizedBox(height: Dimens.innerPadding),
                LabeledBox(
                  label: "상위 분류",
                  child: SelectBox(
                    index: sectorIndex,
                    items: ["선택되지 않음", "애니메이션", "게임", "행사", "공연", "캐릭터", "성우 행사"],
                    onChanged: (newValue) {
                      setState(() => sectorIndex = newValue);
                    },
                  ),
                ),
                SizedBox(height: Dimens.innerPadding),
                LabeledBox(
                  label: "하위 분류",
                  child: SelectBox(
                    index: typeIndex,
                    items: ["선택되지 않음", "아이템 1", "아이템 2", "아이템 3"],
                    onChanged: (newValue) {
                      setState(() => typeIndex = newValue);
                    },
                  ),
                ),
                SizedBox(height: Dimens.innerPadding),
                LabeledBox(
                  label: "시작 및 종료 날짜",
                  child: CalendarSelectBox.range(
                    startDate: startDate,
                    endDate: endDate,
                    onStartChanged: (newValue) {
                      setState(() => startDate = newValue);
                    },
                    onEndChanged: (newValue) {
                      setState(() => endDate = newValue);
                    },
                  ),
                ),
                SizedBox(height: Dimens.innerPadding),
                LabeledBox(
                  label: "행사 위치",
                  child: AddressSelectBox(onChanged: (address) {})
                ),

                // 추가 간격 표시.
                SizedBox(height: Dimens.innerPadding * 2),

                // 상위 라벨 표시.
                Padding(
                  padding: EdgeInsets.only(left: Dimens.innerPadding),
                  child: Text(
                    "상세 정보",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: Dimens.innerPadding),
                InputField(hintText: "제목"),
                SizedBox(height: Dimens.innerPadding),
                InputField(hintText: "간략한 소개", maxLines: null),
                SizedBox(height: Dimens.innerPadding),
                InputField(hintText: "자세한 정보", minLines: 10, maxLines: null),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          child: WideButton(label: "제보하기", onTap: () {}),
        ),
      ],
    );
  }
}