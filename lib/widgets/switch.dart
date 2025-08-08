import 'package:flutter/material.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/transition_animator.dart';

/// 해당 위젯은 On/Off 상태를 표현하고 상태 변경 시 콜백을 호출합니다.
class Switch extends StatelessWidget {
  const Switch({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  static const double maxWidth = 45;
  static const double maxHeight = 25;
  static const double circleSize = maxHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TransitionAnimator(
          value: isEnabled ? 1 : 0,
          builder: (context, animValue, _) {
            final ColorTween colorTween = ColorTween(
              begin: Scheme.current.border,
              end: Scheme.current.primary,
            );

            return Container(
              width: maxWidth,
              height: maxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1e10),
                color: colorTween.transform(animValue),
              ),
            );
          },
        ),
        AnimatedPositioned(
          duration: Animes.transition.duration,
          curve: Animes.transition.curve,
          left: isEnabled ? maxWidth - circleSize: 0,
          child: Container(
            padding: EdgeInsets.all(3),
            width: circleSize,
            height: circleSize,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Scheme.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}