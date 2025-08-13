import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';

class HeaderConnection extends StatefulWidget {
  const HeaderConnection({
    super.key,
    required this.title,
    this.label,
    required this.child,
  });

  final String title;
  final String? label;
  final Widget child;

  @override
  State<HeaderConnection> createState() => _HeaderConnectionState();
}

class _HeaderConnectionState extends State<HeaderConnection> {
  final AppBarController _controller = AppBarController();

  @override
  void initState() {
    super.initState();
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
            // 헤더 타이틀 앱바.
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
                        // 제목 표시.
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),

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

                    // 타이틀 표시.
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
              }
            ),
          ],
          child: widget.child,
        );
      },
    );
  }
}