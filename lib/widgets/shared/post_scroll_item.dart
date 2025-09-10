import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:intl/intl.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/post_details/post_details.dart';
import 'package:otatime_flutter/widgets/openable.dart';
import 'package:otatime_flutter/widgets/palette_image.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:palette_generator/palette_generator.dart';

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
          Skeleton.partOf(height: 25),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Skeleton.partOf(height: 25),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Skeleton.partOf(width: 70, height: 25),
              Skeleton.partOf(width: 70, height: 25),
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
  Color? paletteColor;

  /// 팔레트 색상이 어두운지에 대한 여부를 반환합니다.
  bool? get isPaletteDark {
    if (paletteColor == null) return null;
    return paletteColor!.computeLuminance() < 0.5;
  }

  Color get backdropColor {
    return isPaletteDark == null
      ? Scheme.current.foreground
      : isPaletteDark! ? Scheme.white : Scheme.black;
  }

  void setPaletteColor(PaletteGenerator generator) async {
    // 가장 유사한 이미지 대표색을 정의합니다.
    if (!mounted) return;
    setState(() => paletteColor = generator.dominantColor?.color);
  }

  @override
  Widget build(BuildContext context) {
    final PostModel model = widget.model;
    final bool isDDay = model.dDay <= 3;
    final Color backgroundColor = paletteColor ?? Scheme.current.deepground;
    final Color foregorundColor = isPaletteDark == null
      ? Scheme.current.foreground
      : isPaletteDark! ? Scheme.white : Scheme.black;

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
          child: AnimatedContainer(
            duration: Animes.transition.duration,
            curve: Animes.transition.curve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
              color: backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 1,
                      child: PaletteImage.network(
                        url: model.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        onPalette:setPaletteColor,
                      ),
                    ),

                    // 부드러운 그림자 효과.
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: Animes.transition.duration,
                          curve: Animes.transition.curve,
                          height: Dimens.innerPadding * 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                backgroundColor.withAlpha(0),
                                backgroundColor,
                              ]
                            ),
                          ),
                        ),
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
                  padding: EdgeInsets.only(
                    left: Dimens.innerPadding,
                    right: Dimens.innerPadding,
                    bottom: Dimens.innerPadding,
                  ),
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
                          color: foregorundColor,
                        ),
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

                      SizedBox(),

                      // 행사 날짜
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: Dimens.columnSpacing,
                        spacing: 5,
                        children: [
                          dateButtonWidget(model.startDate),
                          dateButtonWidget(model.endDate),
                        ],
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
    final Color backgroundColor = widget.model.isLiked
        ? Scheme.negative.withAlpha(30)
        : Scheme.current.rearground.withAlpha(100);

    return TouchScale(
      onPress: () {
        // TODO: 행사 액션 버튼 구현.
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1e10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.all(Dimens.innerPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              widget.model.isLiked ? "heart-filled".svg : "heart".svg,
              width: 18,
              color: widget.model.isLiked
                ? Scheme.negative
                : Scheme.current.foreground.withAlpha(150),
            ),
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

  Widget dateButtonWidget(DateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: backdropColor.withAlpha(50),
        borderRadius: BorderRadius.circular(1e10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          // 달력 아이콘
          SvgPicture.asset(
            "calendar".svg,
            width: 12,
            color: Scheme.white,
          ),

          // 날짜 표시
          Text(
            DateFormat("yyyy-MM-dd").format(date),
            style: TextStyle(
              fontSize: 12,
              color: Scheme.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget tagWidget(String tag) {
    return Opacity(
      opacity: 0.5,
      child: Text(
        "#$tag",
        style: TextStyle(
          color: backdropColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}