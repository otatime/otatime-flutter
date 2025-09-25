import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';

/// 해당 위젯은 날짜를 아이콘과 함께 표시하는 버튼 형태의 UI를 구성합니다.
class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    required this.date,
  });

  /// 버튼에 표시할 날짜.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Scheme.current.background,
        borderRadius: BorderRadius.circular(1e10),
        border: Border.all(color: Scheme.current.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          // 달력 아이콘.
          SvgPicture.asset(
            "calendar".svg,
            width: 12,
            color: Scheme.current.foreground2,
          ),

          // 'yyyy-MM-dd' 형식의 날짜.
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
