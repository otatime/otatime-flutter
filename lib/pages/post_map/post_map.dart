import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/main.dart';
import 'package:otatime_flutter/widgets/action_button.dart';

/// 게시글의 행사 위치를 지도로 보여주는 페이지.
class PostMapPage extends StatefulWidget {
  const PostMapPage({super.key});

  @override
  State<PostMapPage> createState() => _PostMapPageState();
}

class _PostMapPageState extends State<PostMapPage> {
  /// 지도의 로딩 상태.
  bool isLoading = true;

  /// 지도의 초기 위치로 사용될 임시 좌표.
  // TODO: 임시 코드.
  static LatLng get testPosition => LatLng(
    37.5182112402056,
    127.023150432187,
  );

  @override
  void initState() {
    super.initState();

    // 상태 표시줄 아이콘 스타일을 검은색 위주로 변경.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Scheme.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void deactivate() {
    super.deactivate();

    // 기존 상태 표시줄 스타일로 복원.
    MainApp.initSystemUIOverlayStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 지도가 로딩되면 부드럽게 표시합니다.
        AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: Animes.transition.duration,
          curve: Animes.transition.curve,

          // 카카오 지도 위젯.
          child: KakaoMap(
            // 초기 위치, 확대 수준 등 지도의 표시 옵션을 설정합니다.
            option: KakaoMapOption(
              position: testPosition,
              zoomLevel: 16,
              mapType: MapType.normal,
            ),

            // 지도가 준비되었을 때 호출됩니다.
            onMapReady: (controller) {
              setState(() => isLoading = false);

              // 지도에 행사 위치를 마커로 표시합니다.
              controller.labelLayer.addPoi(
                testPosition,
                style: PoiStyle(
                  icon: KImage.fromAsset("navigation".png, 18, 26),
                ),
              );
            },
          ),
        ),

        // 화면 좌측 상단의 뒤로가기 버튼.
        Positioned(
          top: Dimens.outerPadding,
          left: Dimens.outerPadding,
          child: SafeArea(
            child: ActionButton(
              iconPath: "arrow_left".svg,

              // 탭하면 이전 화면으로 돌아갑니다.
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}