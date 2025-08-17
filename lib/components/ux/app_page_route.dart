import 'package:flutter/material.dart';
import 'package:otatime_flutter/main.dart';

/// 애플리케이션 내에서 공통적으로 사용되는 [PageRoute] 입니다.
class AppPageRoute extends MaterialPageRoute {
  AppPageRoute({
    required super.builder,
    this.isFadeEffect = false,
  });

  /// 페이지 전환 시 단순 페이드 효과만을 적용할지 여부.
  final bool isFadeEffect;

  @override
  Widget buildContent(BuildContext context) {
    return MainApp.defaultBuilder(context, builder(context));
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child
  ) {
    if (isFadeEffect) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      );
    }

    // 기존 Material 전환 애니메이션 사용.
    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  DelegatedTransitionBuilder? get delegatedTransition {
    // 페이드 효과일 경우, 서브 페이지에 대한 애니메이션은 적용하지 않음.
    if (isFadeEffect) {
      return (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        bool allowSnapshotting,
        Widget? child,
      ) => child;
    }

    return null;
  }
}