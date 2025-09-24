import 'package:flutter/cupertino.dart';
import 'package:flutter_scroll_bottom_sheet/components/bottom_sheet.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 앱 전반에서 공통적으로 사용되는 선택용 바텀 시트를 제공하는 유틸리티 클래스입니다.
/// 주로 여러 옵션 중 하나를 선택하는 UI를 구현할 때 사용됩니다.
class SelectBoxSheet {
  /// 주어진 아이템 목록으로 선택용 바텀 시트를 엽니다.
  ///
  /// [index]는 현재 선택된 아이템의 인덱스입니다.
  /// [items]는 사용자에게 보여줄 문자열 목록입니다.
  /// [onSelected]는 사용자가 아이템을 선택했을 때 호출되는 콜백입니다.
  static void open(BuildContext context, {
    required int index,
    required List<String> items,
    required ValueChanged<int> onSelected,
  }) {
    BottomSheet.open(context, ListView.builder(
      padding: EdgeInsets.only(
        top: Dimens.outerPadding * 2,
        bottom: Dimens.outerPadding,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, itemIndex) {
        final bool isSelected = index == itemIndex;
        return TouchScale(
          onPress: () {
            if (!isSelected) {
              onSelected.call(itemIndex);

              // 현재 열려 있는 바텀 시트 닫기.
              BottomSheet.close(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.innerPadding),
            color: isSelected ? Scheme.current.border : null,
            child: Text(
              items[itemIndex],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                  ? Scheme.current.foreground
                  : Scheme.current.foreground3,
              ),
            ),
          ),
        );
      },
    ));
  }
}