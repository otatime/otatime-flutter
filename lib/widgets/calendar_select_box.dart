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

class CalendarSelectBox extends StatelessWidget {
  const CalendarSelectBox.range({
    super.key,
    this.startDate,
    this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartChanged;
  final ValueChanged<DateTime?> onEndChanged;

  /// 선택용 바텀 시트 열기.
  void _openCalendarPopup(BuildContext context) {
    DateTime? startDate = this.startDate;
    DateTime? endDate = this.endDate;

    Navigator.push(context, ModalPopupRoute(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarPicker.range(
            initialStartDate: startDate,
            initialEndDate: endDate,
            onStartChanged: (newDate) => startDate = newDate,
            onEndChanged: (newDate) => endDate = newDate,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                type: ButtonType.tertiary,
                label: "취소",
                onTap: () => Navigator.pop(context),
              ),
              Button(
                type: ButtonType.secondary,
                label: "완료",
                onTap: () {
                  // 변경 사항이 없는 경우.
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
                child: Text(
                  startDate != null ? placeholder : "선택되지 않음",
                  style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
                ),
              ),
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

  String get placeholder {
    final String a = DateFormat("yyyy-MM-dd").format(startDate!);
    final String b = DateFormat("yyyy-MM-dd").format(endDate!);
    return "$a ~ $b";
  }
}