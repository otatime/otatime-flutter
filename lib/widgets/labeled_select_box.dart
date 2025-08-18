import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class LabeledSelectBox extends StatelessWidget {
  const LabeledSelectBox({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.columnSpacing,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Dimens.innerPadding),
          child: Text(label, style: TextStyle(color: Scheme.current.foreground3)),
        ),
        child,
      ],
    );
  }
}