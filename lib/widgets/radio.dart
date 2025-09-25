import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/transition_animator.dart';

/// 해당 위젯은 선택 여부를 시각적으로 표현하는 커스텀 라디오 버튼입니다.
class Radio extends StatelessWidget {
  const Radio({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  /// 라디오 버튼의 최대 크기.
  static const double maxSize = 25;

  /// 내부 원의 크기.
  static const double circleSize = maxSize / 2;

  @override
  Widget build(BuildContext context) {
    return TransitionAnimator(
      // isEnabled 상태에 따라 애니메이션을 제어.
      value: isEnabled ? 1 : 0,
      builder: (context, animValue, _) {
        final ColorTween colorTween = ColorTween(
          begin: Scheme.current.border,
          end: Scheme.current.primary,
        );

        return Container(
          width: maxSize,
          height: maxSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            // 애니메이션 값(animValue)에 따라 테두리 색상을 변경.
            border: Border.all(color: colorTween.transform(animValue)!),
          ),

          // 선택되었을 때 나타나는 내부 원.
          child: Transform.scale(
            scale: animValue,
            child: AnimatedContainer(
              duration: Animes.transition.duration,
              curve: Animes.transition.curve,
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Scheme.current.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
