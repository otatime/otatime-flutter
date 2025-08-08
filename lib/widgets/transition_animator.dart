import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';

/// 해당 위젯은 주어진 값의 변화를 선언적으로 애니메이션화할 수 있도록 해줍니다.
class TransitionAnimator extends StatefulWidget {
  const TransitionAnimator({
    super.key,
    required this.value,
    required this.builder,
  });

  final double value;
  final ValueWidgetBuilder<double> builder;

  @override
  State<TransitionAnimator> createState() => _TransitionAnimatorState();
}

class _TransitionAnimatorState extends State<TransitionAnimator> with SingleTickerProviderStateMixin {
  double? animValue;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Animes.transition.duration,
      curve: Animes.transition.curve,
      tween: Tween(
        begin: animValue,  // 시작
        end: widget.value, // 끝
      ),
      builder: (context, newValue, child) {
        animValue = newValue;
        return widget.builder.call(context, newValue, child);
      },
    );
  }
}