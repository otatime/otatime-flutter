import 'package:flutter/material.dart';
import 'package:otatime_flutter/components/ui/animes.dart';

/// 해당 위젯은 자식 위젯이 전환될 때 애니메이션 효과를 부여하는 일종의 래퍼 위젯입니다.
class Transition extends StatelessWidget {
  const Transition({
    super.key,
    this.alignment = Alignment.topCenter,
    this.duration,
    required this.child,
  });

  final AlignmentGeometry alignment;
  final Duration? duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? Animes.transition.duration,
      switchInCurve: Animes.transition.curve,
      switchOutCurve: Animes.transition.curve,
      layoutBuilder: _layoutBuilder,
      child: child,
    );
  }

  Widget _layoutBuilder(Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: alignment,
      children: [...previousChildren, if (currentChild != null) currentChild],
    );
  }
}