import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';

/// 해당 위젯은 주어진 활성화 여부에 따라 자식 위젯의 상호작용과 투명도를 제어합니다.
///
/// - [isEnabled]이 true이면 자식 위젯은 온전히 보이고, 사용자의 입력을 막지 않습니다.
/// - [isEnabled]이 false이면 자식 위젯은 반투명하게 보이며, 사용자의 입력을 막습니다.
class Disableable extends StatelessWidget {
  const Disableable({
    super.key,
    required this.isEnabled,
    required this.child
  });

  final bool isEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: AnimatedOpacity(
        opacity: isEnabled ? 1 : 0.5,
        duration: Animes.transition.duration,
        curve: Animes.transition.curve,
        child: child,
      ),
    );
  }
}