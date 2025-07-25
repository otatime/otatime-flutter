import 'package:flutter/material.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(milliseconds: 750),
      baseColor: Scheme.current.placeholder,
      highlightColor: Scheme.current.highlight,
      child: child,
    );
  }

  /// [Shimmer] 효과를 위한, 스켈레톤 UI의 일부 조각으로서 템플릿 형태로 사용됩니다.
  static Widget partOf({
    double? width,
    double? height
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        color: Scheme.current.placeholder
      ),
    );
  }
}