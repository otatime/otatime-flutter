import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/auth/my_user.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/settings/settings.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in.dart';
import 'package:otatime_flutter/pages/sign_up.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/transition.dart';

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
      child: AnimatedSize(
        duration: Animes.transition.duration,
        curve: Animes.transition.curve,

        // 사용자 상태가 변화할 때마다 전환 애니메이션 적용.
        child: Transition(
          child: ListenableBuilder(
            listenable: MyUser.statusNotifier,
            builder: (context, child) {
              assert(MyUser.status != MyUserStatus.none);

              // 사용자 정보를 불어오고 있는 경우, 로딩 인디케이터 표시.
              if (MyUser.status == MyUserStatus.loading) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.outerPadding),
                  child: LoadingIndicator(),
                );
              }

              if (MyUser.status == MyUserStatus.loaded) {
                return signedInWidget();
              }

              return signedOutWidget(context);
            }
          ),
        ),
      ),
    );
  }

  /// 사용자가 로그인되이 있는 상태에서 사용됩니다.
  Widget signedInWidget() {
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
              MyUser.data.userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ],
        ),
        Wrap(
          spacing: Dimens.rowSpacing,
          runSpacing: Dimens.columnSpacing,
          children: [
            Button(
              type: ButtonType.primary,
              label: "로그아웃",
              onTap: () {
                // TODO: 로그아웃 기능 구현해야함.
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 사용자가 로그인되지 있지 않은 상태에서 사용됩니다.
  Widget signedOutWidget(BuildContext context) {
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
              onTap: () {
                // 로그인 페이지로 이동.
                Navigator.push(context, AppPageRoute(builder: (_) => SignInPage()));
              },
            ),
            Button(
              type: ButtonType.secondary,
              label: "회원가입",
              onTap: () {
                // 회원가입 페이지로 이동.
                Navigator.push(context, AppPageRoute(builder: (_) => SignUpPage()));
              },
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