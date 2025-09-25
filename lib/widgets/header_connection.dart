import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';

/// 해당 위젯은 스크롤에 따라 헤더가 축소/확장되는 효과를 제공하는 레이아웃입니다.
///
/// 큰 제목과 작은 제목을 가진 두 개의 앱바(AppBar)를 연결하여
/// 스크롤 위치에 따라 자연스럽게 전환됩니다.
class HeaderConnection extends StatefulWidget {
  const HeaderConnection({
    super.key,
    required this.title,
    this.label,
    required this.child,
  });

  /// 헤더에 표시될 기본 제목.
  final String title;

  /// 제목 아래에 표시될 선택적 레이블.
  final String? label;

  /// 헤더 아래에 표시될 메인 컨텐츠 위젯.
  final Widget child;

  @override
  State<HeaderConnection> createState() => _HeaderConnectionState();
}

class _HeaderConnectionState extends State<HeaderConnection> {
  /// AppBar의 스크롤 및 애니메이션 상태를 관리하는 컨트롤러.
  final AppBarController _controller = AppBarController();

  @override
  void initState() {
    super.initState();

    // 위젯이 렌더링된 후, 두 개의 AppBar 상태를 동기화.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.synchronizeWith(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppBarConnection(
          controller: _controller,
          appBars: [
            // 확장된 상태의 헤더(큰 제목).
            SizedAppBar.builder(
              minExtent: 0,
              maxExtent: constraints.maxHeight / 3,
              behavior: MaterialAppBarBehavior(),
              builder: (context, position) {
                return AppBarFadeEffect.onShrink(
                  end: 0.5,
                  position: position,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: Dimens.columnSpacing,
                      children: [
                        // 제목.
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // 레이블이 있는 경우 표시.
                        if (widget.label != null)
                          Text(
                            widget.label!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Scheme.current.foreground2,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 축소된 상태의 헤더(작은 제목 및 뒤로가기 버튼).
            AppBar.builder(
              behavior: MaterialAppBarBehavior(alwaysScrolling: false),
              builder: (context, position) {
                return Row(
                  children: [
                    // 뒤로가기 버튼.
                    CircularButton(
                      iconPath: "arrow_left".svg,
                      onTap: () => Navigator.pop(context),
                    ),

                    // 스크롤 시 확장되며 나타나는 제목.
                    AppBarFadeEffect.onExpand(
                      start: 0.5,
                      position: _controller.positionOf(0)!,
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          child: widget.child,
        );
      },
    );
  }
}