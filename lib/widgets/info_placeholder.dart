import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 해당 위젯은 화면에서 정보가 없을 때 표시하는 인터페이스를 템플릿화한 것입니다.
/// 아이콘과 제목, 서브 라벨 그리고 액션 버튼 등을 적절하게 정렬하여 표시합니다.
class InfoPlaceholder extends StatelessWidget {
  const InfoPlaceholder({
    super.key,
    required this.iconPath,
    required this.title,
    required this.label,
  });

  final String iconPath;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Dimens.columnSpacing,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 64,
            color: Scheme.current.foreground2,
          ),
          SizedBox(),

          // 제목 또는 원인.
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Scheme.current.foreground2,
            ),
          ),

          // 서브 제목 또는 설명.
          Text(
            label,
            style: TextStyle(color: Scheme.current.foreground3),
          ),
        ],
      ),
    );
  }
}