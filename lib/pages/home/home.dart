import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';

class _Model {
  const _Model({
    required this.title,
    required this.descrpition,
    required this.coverUrl,
    required this.startedAt,
    required this.endedAt,
    required this.tags,
  });  

  final String title;
  final String descrpition;
  final String coverUrl;
  final String startedAt;
  final String endedAt;
  final List<String> tags;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarConnection(
      appBars: [
        AppBar(behavior: _TopAppBar.createAppBarBehavior(), body: _TopAppBar()),
        AppBar(behavior: _BottomAppBar.createAppBarBehavior(), body: _BottomAppBar()),
      ],
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(milliseconds: 300));
        },
        child: _ScrollView(),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.outerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "LOGO",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          CircularButton(iconPath: "search".svg, onTap: () {})
        ],
      ),
    );
  }

  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(floating: true);
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          child: ConstrainedBox(
            constraints: constraints.copyWith(minWidth: constraints.maxWidth),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: Dimens.rowSpacing,
              children: [
                _Category(label: "전체", isSelected: true),
                _Category(label: "애니메이션", isSelected: false),
                _Category(label: "게임", isSelected: false),
              ],
            ),
          ),
        );
      },
    );
  }

  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(floating: true);
  }
}

class _Category extends StatelessWidget {
  const _Category({
    super.key,
    required this.isSelected,
    required this.label,
  });

  final bool isSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: isSelected
            ? Scheme.current.foreground
            : Scheme.current.rearground,
          borderRadius: BorderRadius.circular(1e10)
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
              ? Scheme.current.background
              : Scheme.current.foreground
          ),
        ),
      ),
    );
  }
}

class _ScrollView extends StatelessWidget {
  const _ScrollView({super.key});

  // ignore: library_private_types_in_public_api
  static List<_Model> get items => [
    _Model(
      title: "NIKKE - 2025년 8월 9일부터 개최!",
      descrpition: "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
      coverUrl: "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_5bf8138c70b052df43c4ab7c39cc8992a2422834-3840x2160-ori_s_80_50_ori_q_80.webp",
      startedAt: "2025년 8월 9일",
      endedAt: "2025년 8월 12일",
      tags: ["태그 1", "태그 2", "태그 3"]
    ),
    _Model(
      title: "NIKKE - 2025년 8월 9일부터 개최!",
      descrpition: "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
      coverUrl: "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_18c203ef6354e344cee4db14427fe22b556d025f-3840x2160-ori_s_80_50_ori_q_80.webp",
      startedAt: "2025년 8월 9일",
      endedAt: "2025년 8월 12일",
      tags: ["태그 1", "태그 2", "태그 3"]
    ),
    _Model(
      title: "NIKKE - 2025년 8월 9일부터 개최!",
      descrpition: "니케. 지상을 빼앗긴 인류에게 승리를 가져다 줄 마지막 희망. 그 절박한 염원이 담긴 이름과 함께 소녀들은 지상으로 향한다.",
      coverUrl: "https://na-nikke-aws.playerinfinite.com/cms/nrft/feeds/pic/_26527c23c46bce436b83f65f8e9f3c6da3521017-3840x2160-ori_s_80_50_ori_q_80.webp",
      startedAt: "2025년 8월 9일",
      endedAt: "2025년 8월 12일",
      tags: ["태그 1", "태그 2", "태그 3"]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return wrapperWidget(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ScrollItem(model: items[index]);
      },
    );
  }

  Widget wrapperWidget({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return ListView.separated(
      padding: EdgeInsets.all(Dimens.outerPadding),
      separatorBuilder: (_, _) => SizedBox(height: Dimens.outerPadding),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  Widget skeletonWidget() {
    return wrapperWidget(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _ScrollItem.skeletonWidget();
      },
    );
  }
}

class _ScrollItem extends StatelessWidget {
  const _ScrollItem({
    super.key,
    required this.model,
  });

  final _Model model;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      scale: 0.95,
      onPress: () {},
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
            AspectRatio(
              aspectRatio: 3 / 1,
              child: AppImage.network(
                url: model.coverUrl,
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
                    spacing: 5,
                    children: [
                      dateWidget(model.startedAt),
                      Text("부터", style: TextStyle(color: Scheme.current.foreground3)),
                      dateWidget(model.endedAt),
                      Text("까지", style: TextStyle(color: Scheme.current.foreground3)),
                    ],
                  ),

                  // 행사 소개
                  Text(
                    model.descrpition,
                    style: TextStyle(fontSize: 12, color: Scheme.current.foreground2),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 행사 태그
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: model.tags.map(tagWidget).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateWidget(String date) {
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
            date,
            style: TextStyle(
              fontSize: 12,
              color: Scheme.current.foreground2,
            ),
          ),
        ],
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
          Skeleton.partOf(height: 40),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Skeleton.partOf(height: 40),
          ),
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Skeleton.partOf(height: 40),
          ),
        ],
      ),
    );
  }
}