import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.type,
    required this.label,
    required this.onTap,
  });

  final ButtonType type;
  final String label;
  final VoidCallback onTap;

  // 버튼에서 공통적으로 사용되는 안쪽 여백입니다.
  static EdgeInsets get padding => EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.primary => primaryWidget(),
      ButtonType.secondary => secondaryWidget(),
      ButtonType.tertiary => tertiaryWidget(),
    };
  }

  Widget primaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1e10),
          color: Scheme.current.primary,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Scheme.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget secondaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Scheme.current.primary,
          ),
        ),
      ),
    );
  }

  Widget tertiaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Scheme.current.foreground2,
          ),
        ),
      ),
    );
  }
}