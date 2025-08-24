import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  final String iconPath;
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