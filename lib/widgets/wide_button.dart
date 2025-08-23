import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/transition_animator.dart';

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
  final String? iconPath;
  final bool isLoading;

  @override
  State<WideButton> createState() => _WideButtonState();
}

class _WideButtonState extends State<WideButton> {
  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () {
        if (widget.isLoading) return;
        widget.onTap.call();
      },
      child: TransitionAnimator(
        value: widget.isLoading ? 1 : 0,
        builder: (context, animValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: Scheme.current.primary,
                ),
                child: Opacity(
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

              // 특정 조건에서 로딩 인디케이터 표시.
              if (animValue != 0)
                Opacity(
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