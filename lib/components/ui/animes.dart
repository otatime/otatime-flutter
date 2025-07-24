import 'package:flutter/animation.dart';

class Animes {
  const Animes({
    required this.duration,
    required this.curve
  });

  final Duration duration;
  final Curve curve;

  /// 앱 전반의 전환 애니메이션에 공통적으로 사용됩니다.
  static final Animes transition = Animes(
    duration: Duration(milliseconds: 300),
    curve: Curves.ease
  );
}