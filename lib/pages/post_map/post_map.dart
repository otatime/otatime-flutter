import 'package:flutter/widgets.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/action_button.dart';

class PostMapPage extends StatefulWidget {
  const PostMapPage({super.key});

  @override
  State<PostMapPage> createState() => _PostMapPageState();
}

class _PostMapPageState extends State<PostMapPage> {
  bool isLoading = true;

  // TODO: 임시 코드.
  static LatLng get testPosition => LatLng(
    37.5182112402056,
    127.023150432187,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: Animes.transition.duration,
          curve: Animes.transition.curve,
          child: KakaoMap(
            option: KakaoMapOption(
              position: testPosition,
              zoomLevel: 16,
              mapType: MapType.normal,
            ),
            onMapReady: (controller) {
              setState(() => isLoading = false);

              // 행사 위치 표시.
              controller.labelLayer.addPoi(
                testPosition,
                style: PoiStyle(
                  icon: KImage.fromAsset("navigation".png, 18, 26),
                ),
              );
            },
          ),
        ),

        // 액션 버튼 표시.
        Positioned(
          top: Dimens.outerPadding,
          left: Dimens.outerPadding,
          child: ActionButton(
            iconPath: "arrow_left".svg,
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}