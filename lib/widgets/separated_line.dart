import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 앱 내에서 포괄적으로 사용되는 구분선을 표시합니다.
class SeparatedLine extends StatelessWidget {
  const SeparatedLine.horizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: 2.0,
      child: Container(
        color: Scheme.current.separatedLine,

        // 구분선이 화면의 전체 너비를 차지하도록 설정.
        width: double.infinity,

        // 구분선의 시각적인 두께.
        height: 8,
      ),
    );
  }
}
