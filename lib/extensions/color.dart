import 'package:flutter/widgets.dart';

extension ColorExtension on Color {
  /// 현재 색상이 반전된 색상을 반환합니다.
  Color get flipped {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }
}