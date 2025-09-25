import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/radio.dart';
import 'package:otatime_flutter/widgets/switch.dart';

/// 해당 클래스는 설정 화면 등에서 사용되는 표준화된 목록 아이템 위젯을 생성하는 유틸리티입니다.
class ColumnItem {
  /// 터치 시 위젯에 적용될 축소 비율.
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
            // 좌측 아이콘.
            SvgPicture.asset(
              iconPath,
              width: 18,
              color: Scheme.current.foreground2,
            ),

            // 아이템 제목.
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // 페이지 이동을 나타내는 오른쪽 화살표 아이콘.
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

  /// 제목과 스위치 컨트롤로 구성된 리스트 아이템 위젯을 생성합니다.
  static Widget switcher({
    required String title,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return TouchScale(
      // 아이템 전체를 탭하면 스위치 상태를 변경하고 진동 피드백을 제공.
      onPress: () {
        onChanged.call(!isEnabled);
        HapticFeedback.vibrate();
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            // 설정 항목 제목.
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // On/Off 상태를 제어하는 스위치.
            Switch(
              isEnabled: isEnabled,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// 라디오 버튼과 라벨로 구성된 리스트 아이템 위젯을 생성합니다.
  static Widget radio({
    required String label,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return TouchScale(
      // 아이템 전체를 탭하면 라디오 버튼 상태를 변경하고 진동 피드백을 제공.
      onPress: () {
        onChanged.call(!isEnabled);
        HapticFeedback.vibrate();
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            // 선택 상태를 표시하는 라디오 버튼.
            Radio(
              isEnabled: isEnabled,
              onChanged: onChanged,
            ),

            // 라디오 옵션의 라벨.
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
