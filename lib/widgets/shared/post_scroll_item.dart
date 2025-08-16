import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/post_details/post_details.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/date_button.dart';
import 'package:otatime_flutter/widgets/openable.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';

class PostScrollItem extends StatelessWidget {
  const PostScrollItem({
    super.key,
    required this.model,
  });

  final PostModel model;

  /// D-Day 임박 시 별도로 적용되는 박스 보더입니다.
  static BoxBorder get dDayBorder => GradientBoxBorder(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Scheme.transparent,
        Scheme.negative,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bool isDDay = model.dDay <= 3;

    return Openable(
      openBuilder: (context) {
        return PostDetailsPage(model: model);
      },
      // 내부 아이템의 곡선 값을 그대로 유지.
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
      ),
      closedBuilder: (context, openContainer) {
        return TouchScale(
          onPress: openContainer,
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: Scheme.current.deepground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 1,
                      child: AppImage.network(
                        url: model.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Dimens.innerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: Dimens.columnSpacing,
                        children: [
                          // 행사 제목
                          Text(
                            model.title,
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),

                          // 행사 날짜
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: Dimens.columnSpacing,
                            spacing: 5,
                            children: [
                              // D-Day (3일) 임박시 표시.
                              if (isDDay) dDayWidget(),
                              DateButton(date: model.startDate),

                              // D-Day 표시 없을때만.
                              if (model.dDay > 3)
                                Text(
                                  "부터",
                                  style: TextStyle(fontSize: 12, color: Scheme.current.foreground3)
                                ),

                              // D-Day 임박시만 표시.
                              if (isDDay) Text("~", style: TextStyle(color: Scheme.current.foreground3)),
                              DateButton(date: model.endDate),

                              // D-Day 표시 없을때만.
                              if (model.dDay > 3)
                                Text(
                                  "까지",
                                  style: TextStyle(fontSize: 12, color: Scheme.current.foreground3)
                                ),
                            ],
                          ),

                          // 행사 소개
                          Text(
                            model.summary,
                            style: TextStyle(fontSize: 12, color: Scheme.current.foreground2),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // 행사 태그
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              tagWidget(model.sector),
                              tagWidget(model.type),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // D-Day 임박 시, 별도의 안쪽 여백을 차지하지 않은 형태로 그래디언트 보더 표시.
              if (isDDay)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.borderRadius),
                      border: dDayBorder,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// D-Day를 나타내는 버튼 형태의 위젯입니다.
  Widget dDayWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Scheme.negative,
        borderRadius: BorderRadius.circular(1e10),
      ),
      child: Text(
        "D-DAY",
        style: TextStyle(
          color: Scheme.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget tagWidget(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Scheme.current.rearground,
        borderRadius: BorderRadius.circular(1e10),
      ),
      child: Text(
        "#$tag",
        style: TextStyle(
          fontSize: 12,
          color: Scheme.current.foreground2,
        ),
      ),
    );
  }

  static Widget skeletonWidget() {
    return Skeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: Dimens.columnSpacing,
        children: [
          AspectRatio(
            aspectRatio: 3 / 1,
            child: Skeleton.partOf(),
          ),
          Skeleton.partOf(height: 23),
          Skeleton.partOf(height: 23),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Skeleton.partOf(height: 23),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Skeleton.partOf(width: 70, height: 25),
              Skeleton.partOf(width: 70, height: 25),
            ],
          ),
          SizedBox(height: Dimens.innerPadding),
        ],
      ),
    );
  }
}