import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 앱 전반에서 사용되는 모달 팝업 라우트입니다.
///
/// 배경을 흐리게 처리하고 중앙에 컨텐츠를 표시하는 일반적인 모달 UI를 구현합니다.
class ModalPopupRoute extends PopupRoute {
  ModalPopupRoute({required this.child});

  /// 팝업 내부에 표시될 위젯.
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
            SafeArea(
              child: Center(
                child: _FadeTransition(
                  animation: curvedAnimation,
                  child: Container(
                    margin: EdgeInsets.all(Dimens.outerPadding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: EdgeInsets.all(Dimens.outerPadding),
                          decoration: BoxDecoration(
                            color: Scheme.current.backgroundInPopup,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Scheme.current.border),
                          ),
                          constraints: BoxConstraints(maxWidth: 400),
                          child: child,
                        ),
                      ),
                    ),
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

/// 모달 팝업에 사용되는 페이드 및 스케일 전환 효과를 구현하는 위젯입니다.
class _FadeTransition extends StatelessWidget {
  const _FadeTransition({
    super.key,
    required this.animation,
    required this.child
  });

  /// 전환 효과를 제어하는 애니메이션.
  final Animation<double> animation;
  /// 애니메이션 효과가 적용될 자식 위젯.
  final Widget child;

  /// 스케일 효과에 대한 승수.
  static double scaleFraction = 0.15;

  @override
  Widget build(BuildContext context) {
    // 등장 애니메이션 값 계산.
    final double fadeInValue = animation.isForwardOrCompleted ? animation.value : 1;
    // 퇴장 애니메이션 값 계산.
    final double fadeOutValue = animation.status == AnimationStatus.reverse ? 1 - animation.value : 0;

    // 등장 및 퇴장 시 스케일이 약간 변화하는 효과를 적용하여 동적인 느낌을 줍니다.
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
