import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';

class ColumnItem {
  /// 페이지 이동 시, 주로 사용됩니다.
  static Widget push({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
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
      },
    );
  }
}