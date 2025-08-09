import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// 애플리케이션 내에서 공통적으로 사용되는 [TouchScaleBehavior] 입니다.
class AppTouchScaleBehavior extends TouchScaleBehavior {
  static const double fraction = 0.3;

  @override
  Widget build(BuildContext context, Widget child, TouchScaleController controller) {
    return Opacity(
      opacity: 1 - controller.animValue * fraction,
      child: child,
    );
  }
}