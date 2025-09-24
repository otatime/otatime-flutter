import 'package:flutter/widgets.dart';

/// Hero 전환 애니메이션 중에 표시될 위젯(셔틀)을 빌드합니다.
///
/// 시작 위젯과 도착 위젯을 교차로 페이드하여 OpenContainer와 유사한
/// 전환 효과를 구현합니다.
Widget heroOpenContainerShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  // 애니메이션의 시작점(from)과 도착점(to)에 있는 Hero 위젯의 자식을 가져옵니다.
  final Widget fromWidget = (fromHeroContext.widget as Hero).child;
  final Widget toWidget = (toHeroContext.widget as Hero).child;

  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // 애니메이션에 Easing Curve를 적용하여 시각적으로 부드러운 전환을 만듭니다.
      final double curvedValue
          = Curves.fastOutSlowIn.transform(animation.value);

      return Stack(
        children: [
          // 시작 위젯(fromWidget)의 투명도를 조절합니다.
          // push 시에는 사라지고, pop 시에는 나타나는 효과를 줍니다.
          Opacity(
            opacity: flightDirection == HeroFlightDirection.push
              ? 1 - curvedValue
              : curvedValue,
            child: fromWidget,
          ),

          // 도착 위젯(toWidget)의 투명도를 조절합니다.
          // push 시에는 나타나고, pop 시에는 사라지는 효과를 줍니다.
          Opacity(
            opacity: flightDirection == HeroFlightDirection.push
              ? curvedValue
              : 1 - curvedValue,
            child: toWidget,
          ),
        ],
      );
    },
  );
}
