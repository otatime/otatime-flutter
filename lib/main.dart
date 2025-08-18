import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rebuildable/flutter_rebuildable.dart';
import 'package:otatime_flutter/components/settings/settings_binding.dart';
import 'package:otatime_flutter/components/shared/google_mpas.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/bottom_sheet.dart';
import 'package:otatime_flutter/pages/navigation.dart';
import 'package:otatime_flutter/widgets/designed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsBinding.initializeAll();

  // 구글 맵의 다크 테마 설정 값을 정의하는 JSON 파일 불러오기.
  kGoogleMapsDarkStyle
    = await rootBundle.loadString("assets/json/google_mpas_dark.json");

  // 사용자가 OS 측의 테마를 변경했을 때 앱 내의 전체 위젯들의 상태를 변경하도록 합니다.
  WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
    RebuildableApp.rebuild();
  };

  BottomSheetUX.initialize();

  runApp(RebuildableApp(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static TransitionBuilder get defaultBuilder => (context, child) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Designed(child: child!),
    );
  };

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // 상태 표시줄 스타일은 테마나 사용자 설정에 따라 유동적으로 변경될 수 있으므로,
      // 이를 적절히 반영하기 위해 루트 위젯이 빌드되면 다음 프레임에서 이를 설정합니다.
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Scheme.transparent,
        statusBarIconBrightness: Scheme.current is DarkScheme
          ? Brightness.light
          : Brightness.dark
      ));
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Scheme.current.primary,
      home: NavigationPage(),
      builder: defaultBuilder,
    );
  }
}
