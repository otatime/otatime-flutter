import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_item.dart';

class CalendarResultPage extends StatelessWidget {
  const CalendarResultPage({
    super.key,
    required this.date,
    required this.models,
  });

  final DateTime date;
  final List<PostModel> models;

  @override
  Widget build(BuildContext context) {
    return HeaderConnection(
      title: DateFormat("yyyy년 MM월 dd일").format(date),
      label: "결과 ${models.length}개",
      child: ListView.builder(
        padding: EdgeInsets.all(Dimens.outerPadding),
        itemCount: models.length,
        itemBuilder: (context, index) {
          return PostScrollItem(model: models[index]);
        }
      ),
    );
  }
}