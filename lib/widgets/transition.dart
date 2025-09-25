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

  /// 자식 위젯이 전환될 때의 정렬 방식.
  final AlignmentGeometry alignment;

  /// 전환 애니메이션의 지속 시간.
  final Duration? duration;

  /// 애니메이션 효과가 적용될 자식 위젯.
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

  /// 이전 자식 위젯과 현재 자식 위젯을 중첩하여 부드러운 전환 효과를 구현합니다.
  Widget _layoutBuilder(Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: alignment,
      children: [...previousChildren, if (currentChild != null) currentChild],
    );
  }
}