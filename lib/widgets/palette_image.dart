import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/shared/palette.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:palette_generator/palette_generator.dart';

/// 해당 위젯은 주어진 이미지로부터 색상 팔레트를 추출하고, 이미지를 화면에 표시합니다.
class PaletteImage extends StatefulWidget {
  PaletteImage.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit,
    required this.onPalette,
  }) : provider = NetworkImage(url);

  /// `AppImage`에 전달될 이미지 제공자.
  final ImageProvider provider;
  final double? width;
  final double? height;
  final BoxFit? fit;

  /// 색상 팔레트가 성공적으로 생성되었을 때 호출되는 콜백.
  final ValueChanged<PaletteGenerator> onPalette;

  @override
  State<PaletteImage> createState() => _PaletteImageState();
}

class _PaletteImageState extends State<PaletteImage> {
  Color? paletteColor;

  /// 위젯의 이미지 제공자로부터 색상 팔레트를 생성하고 콜백을 호출합니다.
  void _initPaletteColor() async {
    final PaletteGenerator generator = await Palette.of(widget.provider);
    widget.onPalette.call(generator);
  }

  @override
  void initState() {
    super.initState();
    _initPaletteColor();
  }

  @override
  Widget build(BuildContext context) {
    return AppImage(
      provider: widget.provider,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}