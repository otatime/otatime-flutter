import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/select_box_sheet.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/transition.dart';

class SelectBox extends StatelessWidget {
  const SelectBox({
    super.key,
    required this.index,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  final int index;
  final String label;
  final List<String> items;
  final ValueChanged<int> onChanged;

  /// 선택용 바텀 시트 열기.
  void _openBottomSheet(BuildContext context) {
    SelectBoxSheet.open(context, index: index, items: items, onSelected: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.columnSpacing,
      children: [
        // 라벨 표시.
        Padding(
          padding: EdgeInsets.only(left: Dimens.innerPadding),
          child: Text(label, style: TextStyle(color: Scheme.current.foreground3)),
        ),

        // 선택 박스 표시.
        TouchScale(
          onPress: () => _openBottomSheet(context),
          child: Transition(
            child: Container(
              key: ValueKey(index),
              padding: EdgeInsets.all(Dimens.innerPadding),
              decoration: BoxDecoration(
                color: Scheme.current.deepground,
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                border: Border.all(width: 2, color: Scheme.current.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: Dimens.innerPadding,
                children: [
                  Expanded(
                    child: Text(
                      items[index],
                      style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
                    ),
                  ),
                  SvgPicture.asset(
                    "arrow_bottom".svg,
                    width: 14,
                    color: Scheme.current.foreground3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}