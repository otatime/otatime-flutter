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
import 'package:otatime_flutter/pages/home/home.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _index = 0;

  late final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text("달력")),
    const Center(child: Text("사용자")),
  ];

  void moveTo(int newIndex) {
    setState(() => _index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CachedTransition(
            duration: Animes.pageTransition.duration,
            curve: Animes.pageTransition.curve,
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                fillColor: Scheme.transparent,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_index),
              child: _pages[_index],
            ),
          ),
        ),
        _BottomNavigation(
          index: _index,
          onChanged: moveTo,
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    super.key,
    required this.index,
    required this.onChanged
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Scheme.current.border)),
      ),
      child: Row(
        children: [
          itemWidget(index: 0, iconName: "home", label: "홈"),
          itemWidget(index: 1, iconName: "calendar", label: "달력"),
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

          // 페이지 전환 시, 페이드 애니메이션 적용.
          child: AnimatedSwitcher(
            duration: Animes.transition.duration,
            switchInCurve: Animes.transition.curve,
            switchOutCurve: Animes.transition.curve,
            child: Column(
              key: ValueKey(isCurrent),
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                SvgPicture.asset(
                  isCurrent ? "$iconName-filled".svg : iconName.svg,
                  height: 18,
                  color: isCurrent
                    ? Scheme.current.foreground
                    : Scheme.current.foreground2,
                ),

                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Scheme.current.foreground2
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