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

  /// 외부에서 스크롤 제어를 원할 경우 전달받는 컨트롤러.
  final ScrollController? controller;

  /// 페이드 효과를 적용할 스크롤 가능한 위젯.
  final Widget child;

  @override
  State<ScrollEdgeFade> createState() => _ScrollEdgeFadeState();
}

class _ScrollEdgeFadeState extends State<ScrollEdgeFade> {
  /// 위젯 내부에서 사용할 스크롤 컨트롤러. 외부에서 제공되지 않으면 자체적으로 생성.
  late final ScrollController _controller = widget.controller ?? ScrollController();

  /// 스크롤 컨트롤러가 위젯 트리에 마운트되고 초기 스크롤 위치 계산이 완료되었는지 여부.
  bool isInitialized = false;

  // 현재 페이드 효과를 적용시켜야 되는 방향 여부.
  bool left = false;
  bool right = false;

  /// 스크롤 이벤트를 감지하여 좌우 페이드 효과의 노출 여부를 결정합니다.
  void onScrollEvent() {
    assert(_controller.hasClients, "스크롤 컨트롤러가 연결되지 않음.");
    
    // 첫 스크롤 이벤트 발생 시 초기화 완료로 간주하여 페이드 효과를 표시.
    isInitialized = true;

    // 스크롤 위치 정보를 가져와 페이드 표시 여부를 계산.
    final ScrollPosition position = _controller.position;
    final bool hasMaxExtent = position.maxScrollExtent != 0;

    // 스크롤이 시작 위치가 아니면서, 스크롤 가능한 콘텐츠가 있을 때 왼쪽 페이드를 활성화.
    final bool newLeft = position.pixels != 0 && hasMaxExtent;
    // 스크롤이 끝 위치가 아니면서, 스크롤 가능한 콘텐츠가 있을 때 오른쪽 페이드를 활성화.
    final bool newRight = position.pixels != position.maxScrollExtent && hasMaxExtent;

    // 페이드 상태가 변경되었을 경우에만 위젯을 다시 빌드하여 성능 저하를 방지.
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
    // 첫 프레임이 렌더링된 후 스크롤 상태를 초기화하여, 초기 페이드 상태를 올바르게 설정.
    WidgetsBinding.instance.addPostFrameCallback((_) => onScrollEvent());
  }

  @override
  Widget build(BuildContext context) {
    // 스크롤 이벤트를 감지하기 위해 NotificationListener를 사용.
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        onScrollEvent();
        return false;
      },
      // 자식 위젯에게 기본 스크롤 컨트롤러를 제공.
      child: PrimaryScrollController(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: wrapperWidget(),
      ),
    );
  }

  /// 자식 위젯 위에 페이드 효과를 중첩하여 표시하는 레이아웃을 구성합니다.
  Widget wrapperWidget() {
    return Stack(
      children: [
        widget.child,

        // 왼쪽 페이드 효과 위젯. 스크롤 위치에 따라 동적으로 표시됨.
        if (isInitialized) effectWidget(activating: left, begin: Alignment.centerLeft, end: Alignment.centerRight),

        // 오른쪽 페이드 효과 위젯. 스크롤 위치에 따라 동적으로 표시됨.
        if (isInitialized) effectWidget(activating: right, begin: Alignment.centerRight, end: Alignment.centerLeft),
      ],
    );
  }

  /// 특정 방향에 대한 페이드 효과를 시각적으로 구현하는 위젯을 생성합니다.
  Widget effectWidget({
    required bool activating,
    required Alignment begin,
    required Alignment end,
  }) {
    return Positioned.fill(
      child: IgnorePointer(
        // 페이드 효과가 자식 위젯의 터치 이벤트를 가로채지 않도록 설정.
        ignoring: true,
        child: Align(
          alignment: begin,
          // 페이드 효과의 표시 여부를 부드럽게 전환.
          child: AnimatedOpacity(
            duration: Animes.transition.duration,
            opacity: activating ? 1 : 0,
            // 배경색에서 투명으로 변하는 그라데이션을 통해 페이드 효과를 시각적으로 구현.
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [
                    Scheme.current.background,
                    Scheme.current.background.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
