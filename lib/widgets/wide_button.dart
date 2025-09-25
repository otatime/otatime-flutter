import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/transition_animator.dart';

/// 해당 위젯은 앱 전반에서 사용되는 넓은 형태의 버튼입니다.
/// 아이콘, 라벨, 로딩 상태를 표시할 수 있습니다.
class WideButton extends StatefulWidget {
  const WideButton({
    super.key,
    required this.label,
    required this.onTap,
    this.iconPath,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;

  /// 버튼 라벨 왼쪽에 표시될 아이콘의 SVG 에셋 경로.
  final String? iconPath;

  /// 로딩 상태 여부. true일 경우 로딩 인디케이터가 표시되며, 버튼은 비활성화됩니다.
  final bool isLoading;

  @override
  State<WideButton> createState() => _WideButtonState();
}

class _WideButtonState extends State<WideButton> {
  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () {
        // 로딩 중에는 버튼 탭 이벤트를 무시.
        if (widget.isLoading) return;
        widget.onTap.call();
      },
      child: TransitionAnimator(
        // 로딩 상태에 따라 컨텐츠와 로딩 인디케이터 간의 전환을 제어.
        value: widget.isLoading ? 1 : 0,
        builder: (context, animValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 버튼의 기본 배경 및 컨텐츠 영역.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: Scheme.current.primary,
                ),
                child: Opacity(
                  // 로딩 상태에 따라 컨텐츠(아이콘, 라벨)를 서서히 사라지게 함.
                  opacity: 1 - animValue,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Dimens.innerPadding,
                    children: [
                      // 버튼 아이콘 표시.
                      if (widget.iconPath != null)
                        SvgPicture.asset(
                          widget.iconPath!,
                          width: 16,
                          color: Scheme.white,
                        ),

                      // 버튼 라벨 표시.
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: Scheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 로딩 중일 때 로딩 인디케이터를 표시.
              if (animValue != 0)
                Opacity(
                  // 로딩 인디케이터를 서서히 나타나게 함.
                  opacity: animValue,
                  child: LoadingIndicator(color: Scheme.white),
                ),
            ],
          );
        },
      ),
    );
  }
}