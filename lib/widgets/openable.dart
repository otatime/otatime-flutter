import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/designed.dart';

/// 해당 위젯은 애플리케이션 내에서 일관적으로 사용되는 [OpenContainer]으로서
/// 테마 적용 그리고 여러가지 최적화 작업을 수행하는 일종의 래퍼 위젯입니다.
class Openable extends StatelessWidget {
  const Openable({
    super.key,
    required this.openBuilder,
    required this.closedBuilder,
    this.closedShape,
  });

  final WidgetBuilder openBuilder;
  final CloseContainerBuilder closedBuilder;
  final ShapeBorder? closedShape;

  /// 닫힌 상태에 대한 기본적인 [ShapeBorder]를 정의합니다.
  static final ShapeBorder defaultClosedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Dimens.borderRadius),
  );

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openElevation: 0,
      openColor: Scheme.current.background,
      openBuilder: (_, _) {
        return RepaintBoundary(
          child: Designed(child: openBuilder(context)),
        );
      },
      closedShape: closedShape ?? defaultClosedShape,
      closedElevation: 0,
      closedColor: Scheme.current.background,
      closedBuilder: (context, openContainer) {
        return RepaintBoundary(
          child: Designed.themeWidget(
            child: closedBuilder(context, openContainer),
          ),
        );
      },
    );
  }
}