import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/select_box_sheet.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/transition.dart';

/// 해당 위젯은 선택 가능한 목록을 보여주고 사용자가 항목을 선택할 수 있는 UI 컴포넌트입니다.
class SelectBox extends StatelessWidget {
  const SelectBox({
    super.key,
    required this.index,
    required this.items,
    required this.onChanged,
  });

  /// 현재 선택된 항목의 인덱스.
  final int index;

  /// 선택 가능한 전체 항목 목록.
  final List<String> items;

  /// 사용자가 새로운 항목을 선택했을 때 호출되는 콜백.
  final ValueChanged<int> onChanged;

  /// 선택용 바텀 시트 열기.
  void _openBottomSheet(BuildContext context) {
    SelectBoxSheet.open(context, index: index, items: items, onSelected: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return TouchScale(
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
                // 현재 선택된 항목의 텍스트를 표시.
                child: Text(
                  items[index],
                  style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
                ),
              ),

              // 드롭다운임을 나타내는 아래 화살표 아이콘.
              SvgPicture.asset(
                "arrow_bottom".svg,
                width: 14,
                color: Scheme.current.foreground3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}