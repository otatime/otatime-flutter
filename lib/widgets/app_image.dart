import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:transparent_image/transparent_image.dart';

/// 해당 위젯은 앱 내에서 이미지를 일관된 스타일로 표시하기 위한 공용 위젯입니다.
/// 이미지를 로드하는 동안 플레이스홀더를 보여주고, 로드가 완료되면 페이드 인 효과와 함께 이미지를 표시합니다.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.provider,
    this.width,
    this.height,
    this.fit,
  });

  /// 네트워크 URL로부터 이미지를 로드하는 간편 생성자.
  AppImage.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit,
  }) : provider = NetworkImage(url);

  final ImageProvider provider;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 이미지 로딩 중에 표시될 배경색.
      color: Scheme.current.placeholder,
      child: FadeInImage(
        // 투명 이미지를 플레이스홀더로 사용하여 배경색이 보이도록 함.
        placeholder: MemoryImage(kTransparentImage),
        fadeInDuration: Animes.transition.duration,
        fadeInCurve: Animes.transition.curve,
        fit: fit,
        width: width,
        height: height,
        image: provider,
      ),
    );
  }
}
