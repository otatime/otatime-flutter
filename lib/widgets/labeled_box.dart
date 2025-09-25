import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 특정 위젯 위에 텍스트 라벨을 표시하는 컨테이너입니다.
class LabeledBox extends StatelessWidget {
  const LabeledBox({
    super.key,
    required this.label,
    required this.child,
  });

  /// 표시될 텍스트 라벨.
  final String label;

  /// 라벨 아래에 표시될 자식 위젯.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.columnSpacing,
      children: [
        // 상단에 표시되는 제목 라벨.
        Padding(
          padding: EdgeInsets.only(left: Dimens.innerPadding),
          child: Text(label, style: TextStyle(color: Scheme.current.foreground3)),
        ),

        // 라벨 아래에 위치하는 메인 컨텐츠 영역.
        child,
      ],
    );
  }
}
