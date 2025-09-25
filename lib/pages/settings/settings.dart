import 'package:flutter/widgets.dart';
import 'package:flutter_rebuildable/widgets/rebuildable_app.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/settings/user/theme_setting.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';

/// 앱의 다양한 설정을 관리하는 페이지 위젯.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HeaderConnection(
        // 페이지 상단에 표시될 제목.
        title: "설정",

        // 설정 항목들을 담는 스크롤 가능한 리스트.
        child: ListView(
          padding: EdgeInsets.all(Dimens.outerPadding),
          children: [
            // 테마 설정 관련 항목들을 그룹화하는 리스트.
            ColumnList(
              children: [
                // 사용자가 OS의 테마 설정을 앱에 동기화할지 결정하는 스위치.
                ColumnItem.switcher(
                  title: "OS 테마 사용",
                  isEnabled: SettingsBinding.theme.getValue() == Theme.device,

                  // 스위치 상태 변경 시 호출되는 콜백.
                  onChanged: (useOSTheme) {
                    // OS 테마 사용 여부에 따라 앱 테마를 설정.
                    useOSTheme
                      ? SettingsBinding.theme.setValue(Theme.device)
                      : SettingsBinding.theme.setValue(Scheme.themeOf(Scheme.device));

                    // 앱 전체를 다시 빌드하여 테마 변경을 즉시 적용.
                    RebuildableApp.rebuild();
                  },
                ),

                // 'OS 테마 사용'이 비활성화되었을 때, 사용자가 직접 테마를 선택할 수 있는 라디오 버튼 그룹.
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 라이트 테마를 선택하는 라디오 버튼.
                    ColumnItem.radio(
                      label: "라이트",
                      isEnabled: Scheme.current is LightScheme,

                      // 라이트 테마 선택 시 호출되는 콜백.
                      onChanged: (useLight) {
                        SettingsBinding.theme.setValue(Theme.light);
                        RebuildableApp.rebuild();
                      },
                    ),

                    // 다크 테마를 선택하는 라디오 버튼.
                    ColumnItem.radio(
                      label: "다크",
                      isEnabled: Scheme.current is DarkScheme,

                      // 다크 테마 선택 시 호출되는 콜백.
                      onChanged: (useDark) {
                        SettingsBinding.theme.setValue(Theme.dark);
                        RebuildableApp.rebuild();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}