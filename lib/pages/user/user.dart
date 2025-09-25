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
import 'package:otatime_flutter/pages/sign_up/sign_up.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/transition.dart';

/// 사용자 정보 및 관련 메뉴를 표시하는 페이지.
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 사용자 인증 상태가 변경될 때마다 화면을 다시 빌드합니다.
    return ListenableBuilder(
      listenable: MyUser.statusNotifier,
      builder: (context, _) {
        return AppBarConnection(
          appBars: [
            // 사용자 정보에 대한 헤더.
            _HeaderAppBar.createAppBar(),
          ],
          child: ListView(
            padding: EdgeInsets.all(Dimens.outerPadding),
            children: [
              // 사용자 관련 메뉴 목록.
              ColumnList(
                children: [
                  // "찜 목록" 메뉴 아이템으로, 로그인된 상태에서만 활성화됩니다.
                  Disableable(
                    isEnabled: MyUser.status == MyUserStatus.loaded,
                    child: ColumnItem.push(
                      title: "찜 목록",
                      iconPath: "heart".svg,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.innerPadding),
              // 앱 설정 관련 메뉴 목록.
              ColumnList(
                children: [
                  // 설정 화면으로 이동하는 메뉴.
                  ColumnItem.push(
                    title: "설정",
                    iconPath: "settings".svg,
                    onTap: () {
                      // 설정 페이지로 이동.
                      Navigator.push(context, AppPageRoute(builder: (_) => SettingsPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 사용자 페이지 상단에 표시되는 앱 바. 사용자의 로그인 상태에 따라 다른 UI를 보여줍니다.
class _HeaderAppBar extends StatelessWidget {
  const _HeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      // 로그인 상태 변경에 따른 UI 크기 변화를 부드럽게 애니메이션으로 처리합니다.
      child: AnimatedSize(
        duration: Animes.transition.duration,
        curve: Animes.transition.curve,

        // 사용자 상태가 변화할 때마다 전환 애니메이션 적용.
        child: Transition(
          // 사용자 인증 상태가 변경될 때마다 헤더 내용을 갱신합니다.
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

              // 로그인된 상태일 경우, 사용자 정보와 로그아웃 버튼을 표시합니다.
              if (MyUser.status == MyUserStatus.loaded) {
                return signedInWidget();
              }

              // 로그아웃된 상태일 경우, 로그인/회원가입 버튼을 표시합니다.
              return signedOutWidget(context);
            },
          ),
        ),
      ),
    );
  }

  /// 로그인된 사용자를 위한 위젯을 구성합니다.
  Widget signedInWidget() {
    // 로그인된 사용자의 프로필 사진, 이름, 이메일, 로그아웃 버튼을 포함하는 레이아웃.
    return Column(
      spacing: Dimens.innerPadding,
      children: [
        // 사용자 프로필 사진을 표시하는 원형 컨테이너.
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Scheme.current.border,
          ),
          alignment: Alignment.center,
          // 기본 사용자 아이콘.
          child: SvgPicture.asset(
            "user-filled".svg,
            width: 50,
            height: 50,
            color: Scheme.current.foreground3,
          ),
        ),
        // 사용자 이름과 이메일을 세로로 표시합니다.
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.columnSpacing,
          children: [
            // 로그인된 사용자의 이름을 표시합니다.
            Text(
              MyUser.data.userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // 이메일 아이콘과 주소를 가로로 표시합니다.
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: Dimens.rowSpacing,
              children: [
                SvgPicture.asset(
                  "mail-filled".svg,
                  width: 14,
                  color: Scheme.current.foreground2,
                ),
                Text(
                  MyUser.data.email,
                  style: TextStyle(color: Scheme.current.foreground2),
                ),
              ],
            ),
          ],
        ),
        // 사용자 작업 버튼 목록 (예: 로그아웃).
        Wrap(
          spacing: Dimens.rowSpacing,
          runSpacing: Dimens.columnSpacing,
          children: [
            // 로그아웃 버튼.
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

  /// 로그인되지 않은 사용자를 위한 위젯을 구성합니다.
  Widget signedOutWidget(BuildContext context) {
    // 비로그인 상태의 헤더 UI. 기본 아이콘, 안내 문구, 로그인/회원가입 버튼을 포함합니다.
    return Column(
      spacing: Dimens.innerPadding,
      children: [
        // 비로그인 상태의 기본 사용자 아이콘 영역.
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
        // 로그인 유도 메시지를 표시하는 영역.
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.columnSpacing,
          children: [
            // 현재 로그인되어 있지 않음을 나타내는 '오프라인 상태' 텍스트.
            Text(
              "오프라인 상태",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 사용자에게 로그인할 것을 권유하는 안내 문구.
            Text(
              "로그인하여 더 많은 기능을 경험하세요!",
              style: TextStyle(color: Scheme.current.foreground2),
            ),
          ],
        ),
        // 로그인 및 회원가입 버튼을 배치합니다.
        Wrap(
          spacing: Dimens.rowSpacing,
          runSpacing: Dimens.columnSpacing,
          children: [
            // 로그인 페이지로 이동하는 버튼.
            Button(
              type: ButtonType.primary,
              label: "로그인",
              onTap: () {
                // 로그인 페이지로 이동.
                Navigator.push(context, AppPageRoute(builder: (_) => SignInPage()));
              },
            ),
            // 회원가입 페이지로 이동하는 버튼.
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

  /// 스크롤 시 축소되며 페이드 효과가 적용되는 사용자 페이지의 앱 바를 생성합니다.
  static AppBar createAppBar() {
    return AppBar.builder(
      behavior: MaterialAppBarBehavior(),
      builder: (context, position) {
        // 스크롤 시 앱 바가 축소될 때 페이드 효과를 적용합니다.
        return AppBarFadeEffect.onShrink(
          position: position,
          // 앱 바에 표시될 실제 콘텐츠.
          child: _HeaderAppBar(),
        );
      },
    );
  }
}