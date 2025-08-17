import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/components/ux/hero_open_container.dart';
import 'package:otatime_flutter/widgets/designed.dart';

/// 해당 위젯은 애플리케이션 내에서 일관적으로 사용되는 [OpenContainer]으로서
/// 테마 적용 그리고 여러가지 최적화 작업을 수행하는 일종의 래퍼 위젯입니다.
class Openable extends StatefulWidget {
  const Openable({
    super.key,
    required this.openBuilder,
    required this.closedBuilder,
    this.closedShape,
  });

  final WidgetBuilder openBuilder;
  final CloseContainerBuilder closedBuilder;
  final ShapeBorder? closedShape;

  @override
  State<Openable> createState() => _OpenableState();
}

class _OpenableState extends State<Openable> {
  final String heroTag = 'open-container-${Random().nextInt(4294967296)}';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: heroOpenContainerShuttle,
      child: Designed.themeWidget(
        child: widget.closedBuilder(context, () {
          Navigator.push(
            context,
            AppPageRoute(isFadeEffect: true, builder: (context) {
              return Designed(
                child: Hero(
                  tag: heroTag,
                  child: widget.openBuilder(context)
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}