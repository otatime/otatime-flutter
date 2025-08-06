import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/transition.dart';

enum CalendarPickerType {
  single,
  range,
}

class CalendarPicker extends StatefulWidget {
  const CalendarPicker.single({
    super.key,
    DateTime? initialDate,
  }) : initialStartDate = initialDate,
       initialEndDate = null,
       type = CalendarPickerType.single;

  const CalendarPicker.range({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
  }) : type = CalendarPickerType.range;

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final CalendarPickerType type;

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late final DateTime current;

  late DateTime? startDate = widget.initialStartDate;
  late DateTime? endDate = widget.initialEndDate;

  List<DateTime> getDatesInMonth(int year, int month) {
    final List<DateTime> days = [];

    // 해당 월의 마지막 날.
    final DateTime lastDay = DateTime(year, month + 1, 0);

    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(year, month, day));
    }

    return days;
  }

  String getSubTitle() {
    if (widget.type == CalendarPickerType.single) {
      return startDate == null
        ? "원하시는 날짜를 선택하세요."
        // e.g. 2025년 8월 7일 선택 됨
        : "${startDate!.year}년 ${startDate!.month}월 ${startDate!.day}일 선택 됨";
    }

    return startDate == null
      ? "시작 날짜를 선택하세요."
      : endDate == null
        ? "종료 날짜를 선택하세요."
        : "${startDate!.year}-${startDate!.month}-${startDate!.day} 부터 " +
          "${endDate!.year}-${endDate!.month}-${endDate!.day} 까지";
  }

  @override
  void initState() {
    super.initState();
    current = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.outerPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Dimens.innerPadding,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.columnSpacing,
            children: [
              Text(
                "${current.year}년 ${current.month}월",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
              Text(
                getSubTitle(),
                style: TextStyle(color: Scheme.current.foreground3)
              ),
            ],
          ),

          // 일요일부터 토요일까지 요일 텍스트를 가로로 표시.
          Row(
            children: ["일", "월", "화", "수", "목", "금", "토"].map((weekDay) {
              return Expanded(
                child: Text(
                  weekDay,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
                ),
              );
            }).toList(),
          ),

          gridWidget(),
        ],
      ),
    );
  }

  static Color saturdayColor = Color.fromRGBO(255, 45, 45, 1);
  static Color sundayColor = Color.fromRGBO(0, 150, 255, 1);

  Widget gridWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            GridView.count(
              crossAxisCount: 7, // 1주
              mainAxisSpacing: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: buildMonthlyGrid(),
            ),
          ],
        );
      },
    );
  }

  // 각 개별 날짜를 렌더링하는 용도입니다.
  List<Widget> buildMonthlyGrid() {
    final days = getDatesInMonth(current.year, current.month);
    final firstWeekday = days.first.weekday % 7; // 일요일 기준

    return [
      for (int i = 0; i < firstWeekday; i++)
        const SizedBox(), // 앞에 비어 있는 칸

      ...days.map((date) {
        final bool isSelected = date == startDate || date == endDate;
        final bool isInRanged = (startDate != null && endDate != null)
          && date.isAfter(startDate!)
          && date.isBefore(endDate!);

        return Stack(
          children: [
            TouchScale(
              onPress: () {
                if (isSelected) {
                  startDate == date
                    ? setState(() => startDate = null)
                    : setState(() => endDate = null);
                } else {
                  widget.type == CalendarPickerType.single || startDate == null
                    ? setState(() => startDate = date)
                    : setState(() {
                        if (date.isAfter(startDate!)) endDate = date;
                      });
                }
              },
              child: Transition(
                child: Container(
                  key: ValueKey(isSelected),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                      ? Scheme.current.primary
                      : Scheme.transparent,
                  ),
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      color: isSelected
                        ? Scheme.current.foreground
                        : switch (date.weekday) {
                            7 => sundayColor,   // 일요일
                            6 => saturdayColor, // 토요일
                            int() => Scheme.current.foreground,
                          }
                    ),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Builder(
                builder: (context) {
                  final bool isActive = isSelected || isInRanged;
                  final bool isRange = startDate != null && endDate != null;
                  final bool isStart = date.weekday == 7 || startDate == date; // 주일을 기준으로
                  final bool isEnd = date.weekday == 6 || endDate == date; // 주일을 기준으로

                  // 빈 영역 형태로 조건부 렌더링.
                  if (!isRange) return SizedBox();

                  return IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive
                          ? Scheme.current.primary.withAlpha(30)
                          : Scheme.transparent,
                        border: Border(
                          left: isStart && isActive ? BorderSide(color: Scheme.current.primary) : BorderSide.none,
                          right: isEnd && isActive ? BorderSide(color: Scheme.current.primary) : BorderSide.none,
                          top: isActive ? BorderSide(color: Scheme.current.primary) : BorderSide.none,
                          bottom: isActive ? BorderSide(color: Scheme.current.primary) : BorderSide.none,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: isStart ? Radius.circular(1e10) : Radius.zero,
                          bottomLeft: isStart ? Radius.circular(1e10) : Radius.zero,
                          topRight: isEnd ? Radius.circular(1e10) : Radius.zero,
                          bottomRight: isEnd ? Radius.circular(1e10) : Radius.zero,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    ];
  }
}