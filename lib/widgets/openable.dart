import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:hero_container/flutter_hero_container.dart';
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

  /// 열린 상태에서 표시될 위젯을 빌드하는 빌더.
  final WidgetBuilder openBuilder;

  /// 닫힌 상태에서 표시될 위젯을 빌드하는 빌더.
  final CloseContainerBuilder closedBuilder;

  /// 닫힌 상태의 컨테이너 모양.
  final ShapeBorder? closedShape;

  /// 닫힌 상태에 대한 기본적인 [ShapeBorder]를 정의합니다.
  static final ShapeBorder defaultClosedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Dimens.borderRadius),
  );

  @override
  Widget build(BuildContext context) {
    return HeroContainer(
      openedElevation: 0,
      openedColor: Scheme.current.background,

      // 열린 상태의 위젯.
      openedBuilder: (context) {
        // 불필요한 리빌드를 방지하기 위해 RepaintBoundary로 감싸고,
        // 앱의 디자인 시스템을 적용하여 위젯을 렌더링합니다.
        return RepaintBoundary(
          child: Designed(child: openBuilder(context)),
        );
      },

      closedShape: closedShape ?? defaultClosedShape,
      closedElevation: 0,
      closedColor: Scheme.current.background,

      // 닫힌 상태의 위젯.
      closedBuilder: (context, openContainer) {
        // 불필요한 리빌드를 방지하기 위해 RepaintBoundary로 감싸고,
        // 앱의 디자인 시스템을 적용하여 위젯을 렌더링합니다.
        return RepaintBoundary(
          child: Designed.themeWidget(
            child: closedBuilder(context, openContainer),
          ),
        );
      },
    );
  }
}