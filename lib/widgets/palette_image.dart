import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/shared/palette.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:palette_generator/palette_generator.dart';

/// 여러 대표 색상들을 위젯 단에서 선언적으로 생성하기 위해서 사용됩니다.
class PaletteImage extends StatefulWidget {
  PaletteImage.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit,
    required this.onPalette,
  }) : provider = NetworkImage(url);

  final ImageProvider provider;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ValueChanged<PaletteGenerator> onPalette;

  @override
  State<PaletteImage> createState() => _PaletteImageState();
}

class _PaletteImageState extends State<PaletteImage> {
  Color? paletteColor;

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