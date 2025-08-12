import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/transition.dart';

enum CalendarPickerType {
  single,
  range,
}

class CalendarPicker extends StatefulWidget {
  const CalendarPicker.single({
    super.key,
    DateTime? initialDate,
    ValueChanged<DateTime?>? onChanged,
  }) : initialStartDate = initialDate,
       initialEndDate = null,
       onStartChanged = onChanged,
       onEndChanged = null,
       type = CalendarPickerType.single;

  const CalendarPicker.range({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onStartChanged,
    this.onEndChanged,
  }) : type = CalendarPickerType.range;

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final ValueChanged<DateTime?>? onStartChanged;
  final ValueChanged<DateTime?>? onEndChanged;
  final CalendarPickerType type;

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late DateTime current;

  late DateTime? startDate = widget.initialStartDate;
  late DateTime? endDate = widget.initialEndDate;

  /// 주어진 연도 및 달에 해당하는 일자들을 리스트 형태로 반환합니다.
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
        : "${startDate!.year}-${startDate!.month}-${startDate!.day} 부터 "
          "${endDate!.year}-${endDate!.month}-${endDate!.day} 까지";
  }

  /// 시작 날짜를 업데이트합니다.
  void selectStartDate(DateTime? newDate) {
    widget.onStartChanged?.call(newDate);
    setState(() => startDate = newDate);
  }

  /// 종료 날짜를 업데이트합니다.
  void selectEndDate(DateTime? newDate) {
    widget.onEndChanged?.call(newDate);
    setState(() => endDate = newDate);
  }

  @override
  void initState() {
    super.initState();
    current = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            ),

            // 현재 표시 날짜를 이전 달로 이동.
            CircularButton(
              iconPath: "arrow_left".svg,
              onTap: () {
                setState(() => current = DateTime(current.year, current.month - 1));
              },
            ),

            // 현재 표시 날짜를 다음 달로 이동.
            CircularButton(
              iconPath: "arrow_right".svg,
              onTap: () {
                setState(() => current = DateTime(current.year, current.month + 1));
              },
            ),
          ],
        ),

        // 추가적인 여백 추가.
        SizedBox(),

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

        AnimatedSize(
          alignment: Alignment.topCenter,
          duration: Animes.transition.duration,
          curve: Animes.transition.curve,
          child: Transition(
            child: KeyedSubtree(
              key: ValueKey(current),
              child: gridWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget gridWidget() {
    return GridView.count(
      crossAxisCount: 7, // 1주
      mainAxisSpacing: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: buildMonthlyGrid(),
    );
  }

  // 각 개별 날짜를 렌더링하는 용도입니다.
  List<Widget> buildMonthlyGrid() {
    final days = getDatesInMonth(current.year, current.month);
    final firstDayOfMonth = days.first; // 해당 달의 첫번째 날짜.
    final lastDayOfMonth = days.last;   // 해당 달의 마지막 날짜.
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
                    ? selectStartDate(null)
                    : selectEndDate(null);
                } else {
                  if (widget.type == CalendarPickerType.single || startDate == null) {
                    selectStartDate(date);
                  } else {
                    date.isAfter(startDate!)
                      ? selectEndDate(date)
                      : selectStartDate(date);
                  }
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
                        ? Scheme.white
                        : switch (date.weekday) {
                            7 => Scheme.sunday,   // 일요일
                            6 => Scheme.saturday, // 토요일
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
                  final bool isStart = date.weekday == 7 || startDate == date || date == firstDayOfMonth; // 주일을 기준으로
                  final bool isEnd = date.weekday == 6 || endDate == date || date == lastDayOfMonth; // 주일을 기준으로

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