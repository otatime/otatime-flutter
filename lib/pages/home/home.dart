import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/home/home_service.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/scroll_edge_fade.dart';
import 'package:otatime_flutter/widgets/select_box.dart';
import 'package:otatime_flutter/widgets/service_builder.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:otatime_flutter/widgets/transition.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceBuilder(
      serviceBuilder: (_) => HomeService(),
      builder: (context, service) {
        return AppBarConnection(
          appBars: [
            AppBar(behavior: _TopAppBar.createAppBarBehavior(), body: _TopAppBar(service: service)),
            AppBar(behavior: _BottomAppBar.createAppBarBehavior(), body: _BottomAppBar(service: service)),
          ],
          child: RefreshIndicator(
            onRefresh: service.refresh,
            child: Disableable(
              activating: service.status != ServiceStatus.refresh,
              child: _ScrollView(service: service),
            ),
          ),
        );
      },
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({
    super.key,
    required this.service,
  });

  final HomeService service;

  static List<String> locations = [
    "서울", "부산"
  ];

  /// 현재 선택된 위치 옵션에 대한 인덱스 값을 반환합니다.
  int get _currentSelectIndex {
    return service.location == null ? 0 : locations.indexOf(service.location!) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.outerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽 영역.
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.innerPadding,
            children: [
              Text(
                "LOGO",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SelectBox(
                index: _currentSelectIndex,
                items: ["전체", ...locations],
                onChanged: (newValue) {
                  // 전체(0)는 null, 그 외는 기존 정의된 리스트 값을 참조합니다.
                  service.location = newValue == 0 ? null : locations[newValue - 1];
                  service.refresh();
                },
              ),
            ],
          ),

          // 오른쪽 영역.
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
  const _BottomAppBar({
    super.key,
    required this.service,
  });

  final HomeService service;

  static List<String> categorys = [
    "애니메이션",
    "게임",
    "행사",
    "공연",
    "캐릭터",
    "성우 행사",
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollEdgeFade.horizontal(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: Dimens.outerPadding,
              right: Dimens.outerPadding,
              bottom: Dimens.outerPadding,
            ),
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minWidth: constraints.maxWidth,
                maxWidth: double.infinity,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: Dimens.rowSpacing,
                children: [
                  _Category(
                    label: "전체",
                    isSelected: service.category == null,
                    onTap: () {
                      service.category = null;
                      service.refresh();
                    },
                  ),

                  // 개별적으로 상위 카테고리 표시.
                  ...categorys.map((category) {
                    return _Category(
                      label: category,
                      isSelected: service.category == category,
                      onTap: () {
                        service.category = category;
                        service.refresh();
                      },
                    );
                  })
                ],
              ),
            ),
          );
        },
      ),
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
    required this.onTap,
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: isSelected ? () {} : onTap,
      child: Transition(
        child: Container(
          key: ValueKey(isSelected),
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
      ),
    );
  }
}

class _ScrollView extends StatelessWidget {
  const _ScrollView({
    super.key,
    required this.service,
  });

  final HomeService service;

  @override
  Widget build(BuildContext context) {
    return Transition(
      child: Builder(
        // 로드 상태 여부가 변경될 때 전환 애니메이션 적용.
        key: ValueKey(service.isLoading),
        builder: (context) {
          if (service.isLoading) return skeletonWidget();

          final List<PostModel> posts = service.data.posts;

          return wrapperWidget(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _ScrollItem(model: posts[index]);
            },
          );
        },
      ),
    );
  }

  Widget wrapperWidget({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 너비에 따라 아이템의 최소 가로 크기를 400으로 유지하면서 컬럼 개수를 동적으로 계산함.
        final int crossCount = max(1, (constraints.maxWidth / 400).floor());

        return AlignedGridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: Dimens.outerPadding,
          mainAxisSpacing: Dimens.outerPadding,
          padding: EdgeInsets.all(Dimens.outerPadding),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
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

  final PostModel model;

  @override
  Widget build(BuildContext context) {
    final bool isDDay = model.dDay <= 3;

    return TouchScale(
      scale: 0.95,
      onPress: () {},
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
                        spacing: 5,
                        children: [
                          // D-Day (3일) 임박시 표시.
                          if (isDDay) dDayWidget(),
                          dateWidget(model.startDate),

                          // D-Day 표시 없을때만.
                          if (model.dDay > 3)
                            Text(
                              "부터",
                              style: TextStyle(fontSize: 12, color: Scheme.current.foreground3)
                            ),

                          // D-Day 임박시만 표시.
                          if (isDDay) Text("~", style: TextStyle(color: Scheme.current.foreground3)),
                          dateWidget(model.endDate),

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
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Scheme.transparent,
                        Scheme.negative,
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
          fontSize: 12,
          fontWeight: FontWeight.bold,
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