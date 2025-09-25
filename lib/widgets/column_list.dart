import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 애플리케이션 내에서 공통적으로 아이템을 리스트 형태로 묶을 때 주로 사용됩니다.
class ColumnList extends StatelessWidget {
  const ColumnList({
    super.key,
    required this.children,
  });

  /// 리스트에 표시될 위젯 목록.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        color: Scheme.current.deepground,
      ),
      child: Column(
        // 각 아이템별 중간마다 별도의 라인 추가.
        children: children.expand((e) => [e, lineWidget()]).take(children.length * 2 - 1).toList(),
      ),
    );
  }

  /// 아이템 사이에 표시될 구분선을 생성합니다.
  static Widget lineWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      height: 1,
      color: Scheme.current.border,
    );
  }
}
