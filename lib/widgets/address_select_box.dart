import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/address/address.dart';

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
  Address? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () async {
        final result = await Navigator.push(
          context,
          AppPageRoute(builder: (_) => AddressPage()),
        ) as Address?;

        // 사용자가 선택한 주소로 설정.
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
                selectedAddress?.street ?? "선택되지 않음",
                style: TextStyle(fontSize: 16, color: Scheme.current.foreground2),
              ),
            ),
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