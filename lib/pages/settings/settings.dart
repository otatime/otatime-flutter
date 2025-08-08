import 'package:flutter/widgets.dart';
import 'package:flutter_rebuildable/widgets/rebuildable_app.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/settings/user/theme_setting.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/widgets/column_item.dart';
import 'package:otatime_flutter/widgets/column_list.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderConnection(
      title: "설정",
      child: ListView(
        padding: EdgeInsets.all(Dimens.outerPadding),
        children: [
          // 테마 관련 리스트.
          ColumnList(
            children: [
              ColumnItem.switcher(
                title: "OS 테마 사용",
                isEnabled: SettingsBinding.theme.getValue() == Theme.device,
                onChanged: (useOSTheme) {
                  useOSTheme
                    ? SettingsBinding.theme.setValue(Theme.device)
                    : SettingsBinding.theme.setValue(Scheme.themeOf(Scheme.device));

                  RebuildableApp.rebuild();
                }
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColumnItem.radio(
                    label: "라이트",
                    isEnabled: Scheme.current is LightScheme,
                    onChanged: (useLight) {
                      SettingsBinding.theme.setValue(Theme.light);
                      RebuildableApp.rebuild();
                    }
                  ),
                  ColumnItem.radio(
                    label: "다크",
                    isEnabled: Scheme.current is DarkScheme,
                    onChanged: (useDark) {
                      SettingsBinding.theme.setValue(Theme.dark);
                      RebuildableApp.rebuild();
                    }
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}