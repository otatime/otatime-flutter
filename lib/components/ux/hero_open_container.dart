import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';

/// Hero 이동 중간에 보여질 위젯을 정의하는 함수. (OpenContainer 느낌)
Widget heroOpenContainerShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  // 출발 페이지와 도착 페이지의 Hero 위젯
  final Widget fromWidget = (fromHeroContext.widget as Hero).child;
  final Widget toWidget = (toHeroContext.widget as Hero).child;

  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double curvedValue
          = Animes.transition.curve.transform(animation.value);

      return Stack(
        children: [
          // 출발 위젯 투명도 조절.
          Opacity(
            opacity: flightDirection == HeroFlightDirection.push
              ? 1 - curvedValue
              : curvedValue,
            child: fromWidget,
          ),

          // 도착 위젯 투명도 조절.
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