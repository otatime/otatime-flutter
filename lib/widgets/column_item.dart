import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/radio.dart';
import 'package:otatime_flutter/widgets/switch.dart';

class ColumnItem {
  static double get touchScale => 0.95;

  /// 페이지 이동 시, 주로 사용됩니다.
  static Widget push({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return TouchScale(
      onPress: onTap,
      child: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 18,
              color: Scheme.current.foreground2,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SvgPicture.asset(
              "arrow_right".svg,
              height: 14,
              color: Scheme.current.foreground3,
            ),
          ],
        ),
      ),
    );
  }

  static Widget switcher({
    required String title,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return TouchScale(
      onPress: () {
        onChanged.call(!isEnabled);
        HapticFeedback.vibrate();
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Switch(
              isEnabled: isEnabled,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  static Widget radio({
    required String label,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return TouchScale(
      onPress: () {
        onChanged.call(!isEnabled);
        HapticFeedback.vibrate();
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            Radio(
              isEnabled: isEnabled,
              onChanged: onChanged,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}