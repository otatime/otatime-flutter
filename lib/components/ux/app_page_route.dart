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
  /// 페이지 콘텐츠에 앱의 기본 빌더(테마, 제스처 감지 등)를 적용합니다.
  Widget buildContent(BuildContext context) {
    return MainApp.defaultBuilder(context, builder(context));
  }

  @override
  /// 페이지가 화면에 나타나거나 사라질 때의 전환 애니메이션을 빌드합니다.
  ///
  /// [isFadeEffect]가 `true`이면 페이드 효과를, 그렇지 않으면 기본 머티리얼 전환 효과를 사용합니다.
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
  /// 서브 페이지(이전 페이지)의 전환 애니메이션을 처리합니다.
  ///
  /// 페이드 효과가 활성화된 경우, 이전 페이지의 애니메이션을 비활성화하여
  /// 새로운 페이지가 페이드인될 때 시각적 충돌을 방지합니다.
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