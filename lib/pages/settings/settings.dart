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
        title: "설정",
        child: ListView(
          padding: EdgeInsets.all(Dimens.outerPadding),
          children: [
            ColumnList(
              children: [
                // 사용자가 OS의 테마 설정을 앱에 동기화할지 결정하는 스위치.
                ColumnItem.switcher(
                  title: "OS 테마 사용",
                  isEnabled: SettingsBinding.theme.getValue() == Theme.device,
                  onChanged: (useOSTheme) {
                    // OS 테마 사용 여부에 따라 앱 테마를 설정.
                    useOSTheme
                      ? SettingsBinding.theme.setValue(Theme.device)
                      : SettingsBinding.theme.setValue(Scheme.themeOf(Scheme.device));

                    // 앱 전체를 다시 빌드하여 테마 변경을 즉시 적용.
                    RebuildableApp.rebuild();
                  },
                ),

                // 'OS 테마 사용'이 비활성화되었을 때,
                // 사용자가 직접 테마를 선택할 수 있는 라디오 버튼 그룹.
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColumnItem.radio(
                      label: "라이트",
                      isEnabled: Scheme.current is LightScheme,
                      onChanged: (useLight) {
                        SettingsBinding.theme.setValue(Theme.light);
                        RebuildableApp.rebuild();
                      },
                    ),
                    ColumnItem.radio(
                      label: "다크",
                      isEnabled: Scheme.current is DarkScheme,
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