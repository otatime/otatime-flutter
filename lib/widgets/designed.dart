import 'package:flutter/material.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_touch_scale_behavior.dart';

/// 해당 위젯은 테마에 따른 공통 디자인 요소 및 설정을 적용시킵니다.
class Designed extends StatelessWidget {
  const Designed({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scheme.current.background,
      body: SafeArea(
        child: themeWidget(child: child),
      ),
    );
  }

  /// [Scaffold]를 제외한 공통 UI 테마 및 디자인을 정의합니다.
  /// 페이지 단위가 아닌, 개별 구성 요소를 디자인할 때 사용됩니다.
  static Widget themeWidget({required Widget child}) {
    return Theme(
      data: ThemeData(
        primaryColor: Scheme.current.primary,
        primaryColorLight: Scheme.current.primary,
        primaryColorDark: Scheme.current.primary,

        // 'RefreshIndicator'에 대한 테마 설정.
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Scheme.current.foreground,
          refreshBackgroundColor: Scheme.current.rearground,
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: "Pretendard",
          color: Scheme.current.foreground,
        ),
        child: TouchScaleStyle(
          behavior: AppTouchScaleBehavior(),
          child: child,
        ),
      ),
    );
  }
}