import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';

/// 해당 위젯은 주어진 값의 변화를 선언적으로 애니메이션화할 수 있도록 해줍니다.
class TransitionAnimator extends StatefulWidget {
  const TransitionAnimator({
    super.key,
    required this.value,
    required this.builder,
  });

  /// 애니메이션의 최종 목표 값.
  final double value;

  /// 애니메이션 중간 값을 사용하여 위젯을 빌드하는 함수.
  final ValueWidgetBuilder<double> builder;

  @override
  State<TransitionAnimator> createState() => _TransitionAnimatorState();
}

class _TransitionAnimatorState extends State<TransitionAnimator> with SingleTickerProviderStateMixin {
  /// 다음 애니메이션의 시작점으로 사용될 이전 애니메이션 값.
  double? animValue;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Animes.transition.duration,
      curve: Animes.transition.curve,
      tween: Tween(

        // 애니메이션의 시작 값.
        // 이전 상태를 기억하여 부드러운 전환 효과를 만듭니다.
        begin: animValue,

        // 애니메이션의 종료 값.
        // `widget.value`가 변경되면 새로운 애니메이션이 시작됩니다.
        end: widget.value,
      ),
      builder: (context, newValue, child) {
        // 다음 애니메이션이 현재 값에서 자연스럽게 시작하도록 값을 갱신합니다.
        animValue = newValue;

        return widget.builder.call(context, newValue, child);
      },
    );
  }
}
