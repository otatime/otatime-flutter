import 'package:flutter/widgets.dart';
import 'package:flutter_scroll_bottom_sheet/components/bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/transition.dart';

class SelectBox extends StatelessWidget {
  const SelectBox({
    super.key,
    required this.index,
    required this.items,
    this.onChanged,
  });

  final int index;
  final List<String> items;
  final ValueChanged<int>? onChanged;

  /// 선택용 바텀 시트 열기.
  void _openBottomSheet(BuildContext context) {
    BottomSheet.open(context, ListView.builder(
      padding: EdgeInsets.only(
        top: Dimens.outerPadding + 4,
        bottom: Dimens.outerPadding,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final bool isSelected = this.index == index;
        return TouchScale(
          onPress: () {
            if (!isSelected) {
              onChanged?.call(index);

              // 현재 열려 있는 바텀 시트 닫기.
              BottomSheet.close(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.innerPadding),
            color: isSelected ? Scheme.current.border : null,
            child: Text(
              items[index],
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

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () => _openBottomSheet(context),
      child: Transition(
        child: Container(
          key: ValueKey(index),
          padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1e10),
            border: Border.all(color: Scheme.current.primary),
            color: Scheme.current.deepPrimary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12 / 2,
            children: [
              Text(items[index]),
              SvgPicture.asset(
                "arrow_bottom".svg,
                width: 12,
                color: Scheme.current.foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}