import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 원형 모양의 아이콘 버튼을 표시하며, 탭할 때 시각적인 피드백을 제공합니다.
class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    this.foregroundColor,
  });

  final VoidCallback onTap;
  final String iconPath;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          color: foregroundColor ?? Scheme.current.foreground,
        ),
      ),
    );
  }
}