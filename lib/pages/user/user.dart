import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/settings/settings.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarConnection(
      appBars: [
        _HeaderAppBar.createAppBar(),
      ],
      child: ListView(
        padding: EdgeInsets.all(Dimens.outerPadding),
        children: [
          ColumnList(
            children: [
              ColumnItem.push(
                title: "찜 목록",
                iconPath: "heart".svg,
                onTap: () {}
              ),
            ],
          ),
          SizedBox(height: Dimens.innerPadding),
          ColumnList(
            children: [
              ColumnItem.push(
                title: "설정",
                iconPath: "settings".svg,
                onTap: () {
                  // 설정 페이지로 이동.
                  Navigator.push(context, AppPageRoute(builder: (_) => SettingsPage()));
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAppBar extends StatelessWidget {
  const _HeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: signedOutWidget(),
    );
  }

  /// 사용자가 로그인되지 있지 않은 상태에서 사용됩니다.
  Widget signedOutWidget() {
    return Column(
      spacing: Dimens.innerPadding,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Scheme.current.border,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "user-filled".svg,
            width: 50,
            height: 50,
            color: Scheme.current.foreground3,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.columnSpacing,
          children: [
            Text(
              "오프라인 상태",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            Text(
              "로그인하여 더 많은 기능을 경험하세요!",
              style: TextStyle(color: Scheme.current.foreground2)
            ),
          ],
        ),
        Wrap(
          spacing: Dimens.rowSpacing,
          runSpacing: Dimens.columnSpacing,
          children: [
            Button(
              type: ButtonType.primary,
              label: "로그인",
              onTap: () {},
            ),
            Button(
              type: ButtonType.secondary,
              label: "회원가입",
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  static AppBar createAppBar() {
    return AppBar.builder(
      behavior: MaterialAppBarBehavior(),
      builder: (context, position) {
        return AppBarFadeEffect.onShrink(
          position: position,
          child: _HeaderAppBar(),
        );
      },
    );
  }
}