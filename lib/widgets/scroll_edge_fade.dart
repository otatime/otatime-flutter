import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 스크롤 가능한 방향의 끝에 페이드 효과를 주어 자연스러움과
/// 스크롤 가능 여부를 자연스럽게 사용자에게 암시해주는 역할을 수행합니다.
///
/// 참고: 현재는 수평 스크롤 전용으로 동작함.
class ScrollEdgeFade extends StatefulWidget {
  const ScrollEdgeFade.horizontal({
    super.key,
    this.controller,
    required this.child,
  });

  final ScrollController? controller;
  final Widget child;

  @override
  State<ScrollEdgeFade> createState() => _ScrollEdgeFadeState();
}

class _ScrollEdgeFadeState extends State<ScrollEdgeFade> {
  late final ScrollController _controller = widget.controller ?? ScrollController();

  bool isInitialized = false;

  // 현재 페이드 효과를 적용시켜야 되는 방향 여부.
  bool left = false;
  bool right = false;

  void onScrollEvent() {
    assert(_controller.hasClients, "스크롤 컨트롤러가 연결되지 않음.");
    isInitialized = true;

    final ScrollPosition position = _controller.position;
    final bool hasMaxExtent = position.maxScrollExtent != 0;

    final bool newLeft = position.pixels != 0 && hasMaxExtent;
    final bool newRight = position.pixels != position.maxScrollExtent && hasMaxExtent;

    if (newLeft != left || newRight != right) {
      setState(() {
        left = newLeft;
        right = newRight;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onScrollEvent());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        onScrollEvent();
        return false;
      },
      child: PrimaryScrollController(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: wrapperWidget(),
      ),
    );
  }

  Widget wrapperWidget() {
    return Stack(
      children: [
        widget.child,
        if (isInitialized) effectWidget(activating: left, begin: Alignment.centerLeft, end: Alignment.centerRight),
        if (isInitialized) effectWidget(activating: right, begin: Alignment.centerRight, end: Alignment.centerLeft),
      ],
    );
  }

  Widget effectWidget({
    required bool activating,
    required Alignment begin,
    required Alignment end,
  }) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Align(
          alignment: begin,
          child: AnimatedOpacity(
            duration: Animes.transition.duration,
            opacity: activating ? 1 : 0,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [
                    Scheme.current.background,
                    Scheme.current.background.withAlpha(0),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}