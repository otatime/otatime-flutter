import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/transition_animator.dart';

class Radio extends StatelessWidget {
  const Radio({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  static const double maxSize = 25;
  static const double circleSize = maxSize / 2;

  @override
  Widget build(BuildContext context) {
    return TransitionAnimator(
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
            border: Border.all(color: colorTween.transform(animValue)!),
          ),
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