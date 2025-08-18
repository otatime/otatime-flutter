import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/input_field.dart';

class AddressSelectBox extends StatelessWidget {
  const AddressSelectBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () {
        Navigator.push(context, AppPageRoute(builder: (_) => _MapPage()));
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
                "선택되지 않음",
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

class _MapPage extends StatefulWidget {
  const _MapPage({super.key});

  @override
  State<_MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<_MapPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

      ],
    );
  }
}

class _AddressSearchPage extends StatefulWidget {
  const _AddressSearchPage({super.key});

  @override
  State<_AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<_AddressSearchPage> {
  @override
  Widget build(BuildContext context) {
    return AppBarConnection(
      appBars: [
        AppBar(
          behavior: MaterialAppBarBehavior(alwaysScrolling: false),
          body: Padding(
            padding: EdgeInsets.all(Dimens.outerPadding),
            child: serachBarWidget(autoFocus: true),
          ),
        ),
      ],
      child: ListView()
    );
  }

  static Widget serachBarWidget({required bool autoFocus}) {
    return Hero(
      tag: "search-bar",
      child: InputField(
        hintText: "주소 검색",
        autofocus: autoFocus,
      )
    );
  }
}