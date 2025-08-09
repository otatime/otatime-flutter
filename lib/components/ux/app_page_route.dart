import 'package:flutter/material.dart';
import 'package:otatime_flutter/main.dart';

/// 애플리케이션 내에서 공통적으로 사용되는 [PageRoute] 입니다.
class AppPageRoute extends MaterialPageRoute {
  AppPageRoute({required super.builder});

  @override
  Widget buildContent(BuildContext context) {
    return MainApp.defaultBuilder(context, builder(context));
  }
}