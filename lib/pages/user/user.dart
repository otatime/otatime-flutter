import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarConnection(
      appBars: [],
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Text("Hello, World!");
        },
      ),
    );
  }
}