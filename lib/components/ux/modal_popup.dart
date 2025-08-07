import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class ModalPopupRoute extends PopupRoute {
  ModalPopupRoute({required this.child});

  final Widget child;

  @override
  Color? get barrierColor => Scheme.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Animes.popupTransition.duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // 페이드 효과를 위한 애니메이션 인스턴스 정의.
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Animes.popupTransition.curve,
      reverseCurve: Animes.popupTransition.curve.flipped,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final Color barrierColor = Scheme.current.barrier;

        return Stack(
          children: [
            // 배경 흐림 효과.
            IgnorePointer(
              ignoring: true,
              child: Transform.scale(
                scaleY: 1.5,
                child: Container(
                  color: barrierColor.withAlpha((barrierColor.alpha * (curvedAnimation.value)).round()),
                ),
              ),
            ),

            // 모달 팝업 위젯.
            Center(
              child: _FadeTransition(
                animation: curvedAnimation,
                child: Container(
                  margin: EdgeInsets.all(Dimens.outerPadding),
                  padding: EdgeInsets.all(Dimens.outerPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Scheme.current.rearground,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FadeTransition extends StatelessWidget {
  const _FadeTransition({
    super.key,
    required this.animation,
    required this.child
  });

  final Animation<double> animation;
  final Widget child;

  /// 스케일 효과에 대한 승수.
  static double scaleFraction = 0.15;

  @override
  Widget build(BuildContext context) {
    final double fadeInValue = animation.isForwardOrCompleted ? animation.value : 1;
    final double fadeOutValue = animation.status == AnimationStatus.reverse ? 1 - animation.value : 0;

    return Opacity(
      opacity: animation.value,
      child: Transform.scale(
        scale: (1 + scaleFraction)
          - (scaleFraction * fadeInValue)
          - (scaleFraction * fadeOutValue),
        child: child,
      ),
    );
  }
}