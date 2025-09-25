import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cached_transition/flutter_cached_transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/calendar/calendar.dart';
import 'package:otatime_flutter/pages/home/home.dart';
import 'package:otatime_flutter/pages/user/user.dart';

/// 앱의 메인 화면으로, 하단 네비게이션을 통해 페이지를 전환하는 컨테이너 위젯.
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  /// 현재 선택된 페이지의 인덱스.
  int _index = 0;

  /// 네비게이션을 통해 보여줄 페이지 위젯 목록.
  late final List<Widget> _pages = [
    const HomePage(),
    const CalendarPage(),
    const UserPage(),
  ];

  /// 주어진 인덱스로 페이지를 전환합니다.
  void moveTo(int newIndex) {
    setState(() => _index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // 페이지 콘텐츠 영역.
          Expanded(
            child: CachedTransition(
              duration: Animes.pageTransition.duration,
              curve: Animes.pageTransition.curve,

              // 페이지가 전환될 때, 세로 축을 기준으로 공유 축 전환 애니메이션을 적용.
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  fillColor: Scheme.transparent,
                  child: child,
                );
              },

              // 페이지 인덱스를 키로 사용하여, 인덱스가 변경될 때마다 애니메이션을 트리거.
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: _pages[_index],
              ),
            ),
          ),

          // 하단 네비게이션 바.
          _BottomNavigation(
            index: _index,
            onChanged: moveTo,
          ),
        ],
      ),
    );
  }
}

/// 앱의 하단에 위치하는 네비게이션 바 위젯.
class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    super.key,
    required this.index,
    required this.onChanged,
  });

  /// 현재 선택된 아이템의 인덱스.
  final int index;

  /// 다른 아이템이 선택되었을 때 호출되는 콜백.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 상단에 경계선을 추가하여 UI를 구분.
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Scheme.current.border)),
      ),

      // 네비게이션 아이템들을 가로로 나열.
      child: Row(
        children: [
          // 홈 아이템.
          itemWidget(index: 0, iconName: "home", label: "홈"),

          // 달력 아이템.
          itemWidget(index: 1, iconName: "calendar", label: "달력"),

          // 사용자 아이템.
          itemWidget(index: 2, iconName: "user", label: "사용자"),
        ],
      ),
    );
  }

  Widget itemWidget({
    required int index,
    required String iconName,
    required String label,
  }) {
    final bool isCurrent = this.index == index;
    return Expanded(
      child: TouchScale(
        onPress: () {
          if (isCurrent) return;

          // 사용자가 페이지를 전환할 때, 디바이스에 진동을 발생시킵니다.
          HapticFeedback.vibrate();
          onChanged.call(index);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.outerPadding / 1.5),

          // 아이템의 선택 상태가 변경될 때 페이드 애니메이션을 적용.
          child: AnimatedSwitcher(
            duration: Animes.transition.duration,
            switchInCurve: Animes.transition.curve,
            switchOutCurve: Animes.transition.curve,
            child: Column(
              key: ValueKey(isCurrent),
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                // 선택 상태에 따라 채워진 아이콘 또는 일반 아이콘을 표시.
                SvgPicture.asset(
                  isCurrent ? "$iconName-filled".svg : iconName.svg,
                  height: 18,
                  color: isCurrent
                      ? Scheme.current.foreground
                      : Scheme.current.foreground2,
                ),

                // 아이템 레이블.
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Scheme.current.foreground2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}