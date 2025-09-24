import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

/// 애플리케이션 내에서 공통적으로 사용되는 [TouchScaleBehavior] 입니다.
///
/// 사용자가 위젯을 터치했을 때, 위젯이 약간 투명해지는 시각적 피드백을 제공합니다.
class AppTouchScaleBehavior extends TouchScaleBehavior {
  /// 터치 시 투명도 변화의 강도를 조절하는 계수.
  static const double fraction = 0.3;

  @override
  Widget build(BuildContext context, Widget child, TouchScaleController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // 컨트롤러의 애니메이션 값에 따라 투명도를 조절하여 터치 피드백 효과를 줍니다.
        return Opacity(
          opacity: (1 - controller.animValue * fraction).clamp(0, 1),
          child: RepaintBoundary(child: child),
        );
      }
    );
  }
}