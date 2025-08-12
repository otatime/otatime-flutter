import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';

class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Scheme.current.background,
        borderRadius: BorderRadius.circular(1e10),
        border: Border.all(color: Scheme.current.border)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          // 달력 아이콘
          SvgPicture.asset(
            "calendar".svg,
            width: 12,
            color: Scheme.current.foreground2,
          ),

          // 날짜 표시
          Text(
            DateFormat("yyyy-MM-dd").format(date),
            style: TextStyle(
              fontSize: 12,
              color: Scheme.current.foreground2,
            ),
          ),
        ],
      ),
    );
  }
}