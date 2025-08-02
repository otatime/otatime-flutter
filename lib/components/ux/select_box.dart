import 'package:flutter/cupertino.dart';
import 'package:flutter_scroll_bottom_sheet/components/bottom_sheet.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class SelectBox {
  static void open(BuildContext context, {
    required int index,
    required List<String> items,
    required ValueChanged<int> onSelected,
  }) {
    print(items);
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