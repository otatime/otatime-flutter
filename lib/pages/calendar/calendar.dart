import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/calendar/calendar_result.dart';
import 'package:otatime_flutter/pages/calendar/calendar_service.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/openable.dart';
import 'package:otatime_flutter/widgets/service_builder.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:otatime_flutter/widgets/transition.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  /// 현재 달력에 표시되고 있는 기준 날짜.
  DateTime current = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimens.outerPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Dimens.innerPadding,
          children: [
            // 현재 표시 날짜를 이전 달로 이동.
            CircularButton(
              iconPath: "arrow_left".svg,
              onTap: () {
                setState(() => current = DateTime(current.year, current.month - 1));
              },
            ),

            // 현재 연도와 월을 표시.
            Text(
              "${current.year}년 ${current.month}월",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

        // 추가적인 여백.
        SizedBox(height: Dimens.innerPadding),

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

        // 추가적인 여백.
        SizedBox(height: Dimens.innerPadding),

        // 현재 표시 달력이 변화할 때마다 전환 애니메이션 적용.
        Transition(
          child: ServiceBuilder(
            key: ValueKey(current),
            serviceBuilder: (_) => PostMonthService(date: current),
            builder: (context, service) {
              // 로딩 상태가 변화할 때마다 전환 애니메이션 적용.
              return Transition(
                child: Builder(
                  key: ValueKey(service.isLoading),
                  builder: (context) {
                    if (service.isLoading) {
                      // 데이터를 불러오는 동안 표시될 스켈레톤 UI.
                      return Skeleton(
                        child: gridWidget(children: buildMonthlySkeletonParts()),
                      );
                    }

                    // 데이터 로딩 완료 후 실제 날짜 그리드를 표시.
                    return gridWidget(children: buildMonthlyGrid(service));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget gridWidget({required List<Widget> children}) {
    return GridView.count(
      // 한 주를 7일로 설정.
      crossAxisCount: 7,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  /// 데이터 로딩 중에 표시될 월간 달력의 스켈레톤 UI 목록을 구성합니다.
  List<Widget> buildMonthlySkeletonParts() {
    final days = getDatesInMonth(current.year, current.month);
    final firstWeekday = days.first.weekday % 7; // 일요일 기준

    return [
      // 달의 시작 요일 앞의 빈 칸을 채움.
      for (int i = 0; i < firstWeekday; i++)
        const SizedBox(),

      // 각 날짜에 해당하는 스켈레톤 UI 요소를 생성.
      ...days.map((date) {
        return Skeleton.partOf(borderRadius: BorderRadius.circular(1e10));
      }),
    ];
  }

  /// 데이터를 기반으로 실제 월간 달력의 날짜 위젯 목록을 구성합니다.
  List<Widget> buildMonthlyGrid(PostMonthService service) {
    final days = getDatesInMonth(current.year, current.month);
    final firstWeekday = days.first.weekday % 7; // 일요일 기준

    return [
      // 달의 시작 요일 앞의 빈 칸을 채움.
      for (int i = 0; i < firstWeekday; i++)
        const SizedBox(),

      ...days.map((date) {
        // 해당 날짜에 포함된 게시물을 필터링.
        final List<PostModel> posts = service.data.posts.where((model) {
          return !date.isBefore(model.startDate)  // date >= startDate
              && !date.isAfter(model.endDate);    // date <= endDate
        }).toList();

        final int postCount = posts.length;

        // 사용자의 현재 일자와 일치하는 일자인지에 대한 여부.
        final bool isCurrent = DateTime.now().year == date.year
          && DateTime.now().month == date.month
          && DateTime.now().day == date.day;

        return Disableable(
          // 해당 날짜에 게시물이 있을 때만 상호작용이 가능하도록 설정.
          isEnabled: postCount > 0,
          child: Openable(
            // 탭하면 해당 날짜의 게시물 목록을 보여주는 상세 페이지로 이동.
            openBuilder: (context) {
              return CalendarResultPage(date: date, models: posts);
            },
            closedShape: CircleBorder(),

            // 닫혀 있을 때(달력에 표시될 때)의 위젯.
            closedBuilder: (context, openContainer) {
              return TouchScale(
                // 탭하면 Openable 컨테이너가 열리도록 연결.
                onPress: openContainer,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // 오늘 날짜인 경우 배경색으로 강조 표시.
                    color: isCurrent
                      ? Scheme.current.deepPrimary
                      : Scheme.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 날짜 숫자.
                      Text(
                        "${date.day}",
                        style: TextStyle(
                          // 요일에 따라 다른 색상으로 표시(일요일/토요일/평일).
                          color: switch (date.weekday) {
                            7 => Scheme.sunday,   // 일요일
                            6 => Scheme.saturday, // 토요일
                            int() => Scheme.current.foreground,
                          },
                        ),
                      ),

                      // 해당 날짜에 게시물이 있는 경우, 점을 표시하여 시각적으로 알려줌.
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: postCount > 0
                            ? Scheme.current.foreground
                            : Scheme.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    ];
  }
}