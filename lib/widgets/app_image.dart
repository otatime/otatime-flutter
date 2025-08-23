import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:transparent_image/transparent_image.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.provider,
    this.width,
    this.height,
    this.fit,
  });

  AppImage.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit
  }) : provider = NetworkImage(url);

  final ImageProvider provider;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Scheme.current.placeholder,
      child: FadeInImage(
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