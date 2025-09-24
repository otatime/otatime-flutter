import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

/// 애플리케이션 내에서 공통적으로 이미지 대표색을 추출하는 데 사용됩니다.
class Palette {
  /// 주어진 이미지 제공자([provider])로부터 대표 색상들을 추출하여 [PaletteGenerator]를 생성합니다.
  static Future<PaletteGenerator> of(ImageProvider provider) async {
    // 이미지 처리에 대해서 성능 최적화를 위해 작게.
    final ResizeImage resizedImage = ResizeImage(
      provider,
      width: 200,
      height: 200,
    );

    return await PaletteGenerator.fromImageProvider(
      resizedImage,
      size: const Size(200, 200),
      maximumColorCount: 16,
    );
  }
}