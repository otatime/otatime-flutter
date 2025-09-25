import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:intl/intl.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/modal_popup.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/calendar_picker.dart';
import 'package:otatime_flutter/widgets/transition.dart';

/// 해당 위젯은 날짜 범위를 선택하기 위한 입력 상자입니다.
/// 탭하면 달력 팝업이 나타납니다.
class CalendarSelectBox extends StatelessWidget {
  const CalendarSelectBox.range({
    super.key,
    this.startDate,
    this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  /// 시작일.
  final DateTime? startDate;

  /// 종료일.
  final DateTime? endDate;

  /// 시작일이 변경되었을 때 호출되는 콜백.
  final ValueChanged<DateTime?> onStartChanged;

  /// 종료일이 변경되었을 때 호출되는 콜백.
  final ValueChanged<DateTime?> onEndChanged;

  /// 날짜 범위 선택을 위한 달력 팝업을 엽니다.
  void _openCalendarPopup(BuildContext context) {
    DateTime? startDate = this.startDate;
    DateTime? endDate = this.endDate;

    Navigator.push(context, ModalPopupRoute(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 날짜 범위 선택기.
          CalendarPicker.range(
            initialStartDate: startDate,
            initialEndDate: endDate,
            onStartChanged: (newDate) => startDate = newDate,
            onEndChanged: (newDate) => endDate = newDate,
          ),

          // 하단 확인/취소 버튼 영역.
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 팝업을 닫음.
              Button(
                type: ButtonType.tertiary,
                label: "취소",
                onTap: () => Navigator.pop(context),
              ),

              // 선택한 날짜 범위를 적용하고 팝업을 닫음.
              Button(
                type: ButtonType.secondary,
                label: "완료",
                onTap: () {
                  // 선택된 날짜를 부모 위젯에 전달.
                  onStartChanged.call(startDate ?? endDate);
                  onEndChanged.call(endDate ?? startDate);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () => _openCalendarPopup(context),
      child: Transition(
        child: Container(
          // 날짜 범위가 변경될 때마다 애니메이션 효과를 주기 위해 키를 설정.
          key: ValueKey("$startDate, $endDate"),
          padding: EdgeInsets.all(Dimens.innerPadding),
          decoration: BoxDecoration(
            color: Scheme.current.deepground,
            borderRadius: BorderRadius.circular(Dimens.borderRadius),
            border: Border.all(width: 2, color: Scheme.current.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.innerPadding,
            children: [
              Expanded(
                // 선택된 날짜 범위를 표시. 선택된 날짜가 없으면 "선택되지 않음"을 표시.
                child: Text(
                  startDate != null ? placeholder : "선택되지 않음",
                  style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
                ),
              ),

              // 달력 아이콘.
              SvgPicture.asset(
                "calendar".svg,
                width: 16,
                color: Scheme.current.foreground3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 선택된 시작일과 종료일을 "yyyy-MM-dd ~ yyyy-MM-dd" 형식의 문자열로 변환합니다.
  String get placeholder {
    final String a = DateFormat("yyyy-MM-dd").format(startDate!);
    final String b = DateFormat("yyyy-MM-dd").format(endDate!);
    return "$a ~ $b";
  }
}