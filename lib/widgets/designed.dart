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
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: "Pretendard",
          color: Scheme.current.foreground,
        ),
        child: TouchScaleStyle(
          behavior: AppTouchScaleBehavior(),
          child: SafeArea(child: child),
        ),
      ),
    );
  }
}