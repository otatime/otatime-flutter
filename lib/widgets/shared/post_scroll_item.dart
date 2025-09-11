import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/post_details/post_details.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/date_button.dart';
import 'package:otatime_flutter/widgets/openable.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';

class PostScrollItem extends StatefulWidget {
  const PostScrollItem({
    super.key,
    required this.model,
  });

  final PostModel model;

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
          Skeleton.partOf(height: 28),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Skeleton.partOf(height: 28),
          ),
          SizedBox(),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Skeleton.partOf(width: 70, height: 28),
              Skeleton.partOf(width: 70, height: 28),
            ],
          ),
        ],
      ),
    );
  }

  @override
  State<PostScrollItem> createState() => _PostScrollItemState();
}

class _PostScrollItemState extends State<PostScrollItem> {
  @override
  Widget build(BuildContext context) {
    final PostModel model = widget.model;
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
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
              color: Scheme.current.deepground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
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

                    // 찜 액션 버튼 표시.
                    Positioned(
                      top: Dimens.innerPadding,
                      right: Dimens.innerPadding,
                      child: likeActionButtonWidget(),
                    ),

                    // D-Day (3일) 임박시 표시.
                    if (isDDay)
                      Positioned(
                        top: Dimens.innerPadding,
                        left: Dimens.innerPadding,
                        child: dDayWidget(),
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(Dimens.innerPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Dimens.innerPadding,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.borderRadius2),
                        child: AppImage.network(
                          url: model.writer.profileImageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 오른족 영역, 행사 정보 표시.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: Dimens.columnSpacing,
                          children: [
                            // 행사 제목
                            Text(
                              model.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // 행사 위치 및 태그 표시
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: Dimens.rowSpacing,
                                  children: [
                                    SvgPicture.asset(
                                      "navigation-filled".svg,
                                      height: 13,
                                      color: Scheme.current.foreground2,
                                    ),
                                    Text(
                                      model.location,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Scheme.current.foreground2
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "·",
                                  style: TextStyle(color: Scheme.current.foreground3),
                                ),
                                tagWidget(model.sector),
                                tagWidget(model.type),
                              ],
                            ),

                            // 간격 추가
                            SizedBox(),

                            // 행사 날짜
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: Dimens.columnSpacing,
                              spacing: 5,
                              children: [
                                DateButton(date: model.startDate),
                                DateButton(date: model.endDate),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 행사 이미지에 대한 찜 액션 버튼 위젯입니다.
  Widget likeActionButtonWidget() {
    return TouchScale(
      onPress: () {
        // TODO: 행사 액션 버튼 구현.
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1e10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Scheme.current.imageBackdrop,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            widget.model.isLiked ? "heart-filled".svg : "heart".svg,
            width: 16,
            color: widget.model.isLiked
              ? Scheme.negative
              : Scheme.current.foreground2,
          ),
        ),
      ),
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
    return Text(
      "#$tag",
      style: TextStyle(
        fontSize: 13,
        color: Scheme.current.foreground2,
      ),
    );
  }
}