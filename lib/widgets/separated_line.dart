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
        width: double.infinity,
        height: 8,
      ),
    );
  }
}