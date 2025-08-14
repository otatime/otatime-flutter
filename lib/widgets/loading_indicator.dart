import 'package:flutter/material.dart';

/// 해당 위젯은 애플리케이션 내에서 공통적으로 사용되는 로딩 인디케이터입니다.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 30,
  });

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: size * 0.125,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}