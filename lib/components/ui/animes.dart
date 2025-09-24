import 'package:flutter/animation.dart';

/// 앱 전반에서 사용되는 애니메이션의 지속 시간과 곡선을 표준화하여
/// 일관된 사용자 경험을 제공하기 위한 클래스입니다.
class Animes {
  const Animes({
    required this.duration,
    required this.curve
  });

  /// 애니메이션의 지속 시간.
  final Duration duration;

  /// 애니메이션의 곡선(Curve).
  final Curve curve;

  /// 앱 전반의 전환 애니메이션에 공통적으로 사용됩니다.
  static final Animes transition = Animes(
    duration: Duration(milliseconds: 300),
    curve: Curves.ease
  );

  /// 앱의 내비게이션 페이지의 전환 애니메이션에 공통적으로 사용됩니다.
  static final Animes pageTransition = Animes(
    duration: Duration(milliseconds: 600),
    curve: Curves.ease
  );

  /// 팝업과 관련된 페이드 전환 애니메이션에 공통적으로 사용됩니다.
  static final Animes popupTransition = transition;
}
