import 'package:flutter/material.dart';

/// 해당 위젯은 애플리케이션 내에서 공통적으로 사용되는 로딩 인디케이터입니다.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 30,
  });

  /// 로딩 인디케이터의 색상.
  final Color? color;

  /// 로딩 인디케이터의 크기 (너비와 높이).
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,

        // 인디케이터의 두께를 전체 크기에 비례하여 설정.
        strokeWidth: size * 0.125,

        // 인디케이터의 끝 부분을 둥글게 처리하여 부드러운 느낌을 줌.
        strokeCap: StrokeCap.round,
      ),
    );
  }
}