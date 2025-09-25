import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 터치 시 스케일 효과가 적용되는 간단한 아이콘 버튼입니다.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  /// 버튼에 표시될 SVG 아이콘의 애셋 경로.
  final String iconPath;

  /// 버튼을 탭했을 때 실행될 콜백.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: Scheme.current.rearground,
          border: Border.all(color: Scheme.current.border),
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: SizedBox(
          width: 18,
          height: 18,
          child: SvgPicture.asset(
            iconPath,
            color: Scheme.current.foreground2,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}