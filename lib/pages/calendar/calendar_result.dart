import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_item.dart';

/// 캘린더에서 특정 날짜를 선택했을 때, 해당 날짜의 게시물 목록을 보여주는 페이지.
class CalendarResultPage extends StatelessWidget {
  const CalendarResultPage({
    super.key,
    required this.date,
    required this.models,
  });

  /// 결과로 보여줄 게시물의 대상 날짜.
  final DateTime date;

  /// 해당 날짜에 해당하는 게시물 목록.
  final List<PostModel> models;

  @override
  Widget build(BuildContext context) {
    // 시스템 UI를 피해 콘텐츠를 안전한 영역에 표시.
    return SafeArea(
      child: HeaderConnection(
        // 페이지 상단에 선택된 날짜를 "yyyy년 MM월 dd일" 형식으로 표시.
        title: DateFormat("yyyy년 MM월 dd일").format(date),

        // 해당 날짜의 게시물 총 개수를 표시.
        label: "결과 ${models.length}개",

        // 게시물 목록을 스크롤 가능한 리스트로 표시.
        child: ListView.builder(
          padding: EdgeInsets.all(Dimens.outerPadding),

          // 리스트 아이템의 총 개수.
          itemCount: models.length,

          // 각 인덱스에 해당하는 게시물 아이템을 생성.
          itemBuilder: (context, index) {
            return PostScrollItem(model: models[index]);
          },
        ),
      ),
    );
  }
}