import 'package:flutter/material.dart';

/// 해당 위젯은 애플리케이션 내에서 공통적으로 사용되는 로딩 인디케이터입니다.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
    );
  }
}