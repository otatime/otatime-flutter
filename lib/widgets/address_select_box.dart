import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/address/address.dart';

/// 해당 위젯은 사용자가 주소를 선택할 수 있는 상자 형태의 UI 컴포넌트이며,
/// 클릭 시 주소 선택 페이지로 이동합니다.
class AddressSelectBox extends StatefulWidget {
  const AddressSelectBox({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<Address> onChanged;

  @override
  State<AddressSelectBox> createState() => _AddressSelectBoxState();
}

class _AddressSelectBoxState extends State<AddressSelectBox> {
  /// 사용자가 현재 선택한 주소 정보.
  Address? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      // 박스를 탭하면 주소 선택 페이지로 이동.
      onPress: () async {
        final result = await Navigator.push(
          context,
          AppPageRoute(builder: (_) => AddressPage()),
        ) as Address?;

        // 사용자가 주소를 선택하면, 해당 주소로 UI를 갱신.
        if (result != null) {
          setState(() => selectedAddress = result);
        }
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: Scheme.current.deepground,
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
          border: Border.all(width: 2, color: Scheme.current.border),
        ),
        child: Row(
          spacing: Dimens.rowSpacing,
          children: [
            Expanded(
              child: Text(
                // 선택된 도로명 주소를 표시하고, 없으면 "선택되지 않음"을 표시.
                selectedAddress?.street ?? "선택되지 않음",
                style: TextStyle(
                  fontSize: 16,
                  color: Scheme.current.foreground2,
                ),
              ),
            ),

            // 주소 선택 기능임을 나타내는 아이콘.
            SvgPicture.asset(
              "navigation".svg,
              width: 14,
              color: Scheme.current.foreground3,
            ),
          ],
        ),
      ),
    );
  }
}