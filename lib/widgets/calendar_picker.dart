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

/// 해당 위젯은 사용자가 날짜 또는 날짜 범위를 선택할 수 있는 달력 UI를 제공합니다.
class CalendarPicker extends StatefulWidget {
  const CalendarPicker.single({
    super.key,
    DateTime? initialDate,
    ValueChanged<DateTime?>? onChanged,
  })  : initialStartDate = initialDate,
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

  /// 달력에 초기에 선택될 시작 날짜.
  final DateTime? initialStartDate;

  /// 달력에 초기에 선택될 종료 날짜 (범위 선택 시).
  final DateTime? initialEndDate;

  /// 시작 날짜가 변경될 때 호출되는 콜백.
  final ValueChanged<DateTime?>? onStartChanged;

  /// 종료 날짜가 변경될 때 호출되는 콜백 (범위 선택 시).
  final ValueChanged<DateTime?>? onEndChanged;

  /// 달력의 선택 유형 (단일 또는 범위).
  final CalendarPickerType type;

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  /// 현재 달력에 표시되고 있는 월의 기준 날짜.
  late DateTime current;

  /// 사용자가 선택한 시작 날짜.
  late DateTime? startDate = widget.initialStartDate;

  /// 사용자가 선택한 종료 날짜.
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

  /// 현재 선택 상태에 따라 달력 상단에 표시될 보조 텍스트를 반환합니다.
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
        // 현재 연도와 월, 그리고 월 이동 버튼을 포함하는 헤더 영역.
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getSubTitle(),
                    style: TextStyle(color: Scheme.current.foreground3),
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

        // 월이 변경될 때 달력 그리드의 크기가 부드럽게 조절되도록 애니메이션을 적용.
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

  /// 날짜를 표시하는 그리드 위젯.
  Widget gridWidget() {
    return GridView.count(
      crossAxisCount: 7, // 1주
      mainAxisSpacing: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: buildMonthlyGrid(),
    );
  }

  /// 현재 월의 날짜들을 위젯으로 구성하여 그리드를 생성합니다.
  List<Widget> buildMonthlyGrid() {
    final days = getDatesInMonth(current.year, current.month);

    // 해당 달의 첫번째 날짜.
    final firstDayOfMonth = days.first;
    // 해당 달의 마지막 날짜.
    final lastDayOfMonth = days.last;
    // 해당 월의 첫 번째 날의 요일 (일요일=0).
    final firstWeekday = days.first.weekday % 7;

    return [
      // 달력의 시작 부분에 요일에 맞춰 빈 공간을 추가.
      for (int i = 0; i < firstWeekday; i++) const SizedBox(),

      ...days.map((date) {
        final bool isSelected = date == startDate || date == endDate;
        final bool isInRanged = (startDate != null && endDate != null) &&
            date.isAfter(startDate!) &&
            date.isBefore(endDate!);

        // 개별 날짜 셀.
        return Stack(
          children: [
            // 날짜를 선택하는 터치 영역.
            TouchScale(
              onPress: () {
                if (isSelected) {
                  // 이미 선택된 날짜를 다시 탭하면 선택 해제.
                  startDate == date ? selectStartDate(null) : selectEndDate(null);
                } else {
                  if (widget.type == CalendarPickerType.single || startDate == null) {
                    selectStartDate(date);
                  } else {
                    // 범위 선택 시, 시작 날짜보다 이전이면 시작 날짜를, 이후면 종료 날짜를 설정.
                    date.isAfter(startDate!) ? selectEndDate(date) : selectStartDate(date);
                  }
                }
              },
              child: Transition(
                child: Container(
                  key: ValueKey(isSelected),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Scheme.current.primary : Scheme.transparent,
                  ),
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      color: isSelected
                          ? Scheme.white
                          : switch (date.weekday) {
                              7 => Scheme.sunday, // 일요일
                              6 => Scheme.saturday, // 토요일
                              int() => Scheme.current.foreground,
                            },
                    ),
                  ),
                ),
              ),
            ),

            // 범위 선택 시 날짜 사이를 채우는 하이라이트 영역.
            Positioned.fill(
              child: Builder(
                builder: (context) {
                  final bool isActive = isSelected || isInRanged;
                  final bool isRange = startDate != null && endDate != null;
                  // 해당 날짜가 하이라이트의 시작 부분인지 여부 (주의 시작, 범위의 시작일, 월의 시작일).
                  final bool isStart = date.weekday == 7 || startDate == date || date == firstDayOfMonth;
                  // 해당 날짜가 하이라이트의 끝 부분인지 여부 (주의 끝, 범위의 마지막일, 월의 마지막일).
                  final bool isEnd = date.weekday == 6 || endDate == date || date == lastDayOfMonth;

                  // 범위 선택이 아닐 경우 하이라이트를 표시하지 않음.
                  if (!isRange) return SizedBox();

                  // 하이라이트 영역이 터치 이벤트를 가로채지 않도록 설정.
                  return IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive ? Scheme.current.primary.withAlpha(30) : Scheme.transparent,
                        border: Border(
                          left: isStart && isActive
                              ? BorderSide(color: Scheme.current.primary)
                              : BorderSide.none,
                          right: isEnd && isActive
                              ? BorderSide(color: Scheme.current.primary)
                              : BorderSide.none,
                          top: isActive ? BorderSide(color: Scheme.current.primary) : BorderSide.none,
                          bottom: isActive
                              ? BorderSide(color: Scheme.current.primary)
                              : BorderSide.none,
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