import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/home/home_service.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
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
            AppBar(behavior: _TopAppBar.createAppBarBehavior(), body: _TopAppBar()),
            AppBar(behavior: _BottomAppBar.createAppBarBehavior(), body: _BottomAppBar()),
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
                      dateWidget(model.startDate),
                      Text("부터", style: TextStyle(color: Scheme.current.foreground3)),
                      dateWidget(model.endDate),
                      Text("까지", style: TextStyle(color: Scheme.current.foreground3)),
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
          Skeleton.partOf(height: 25),
          Skeleton.partOf(height: 25),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Skeleton.partOf(height: 30),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Skeleton.partOf(width: 80, height: 30),
              Skeleton.partOf(width: 80, height: 30),
            ],
          ),
          SizedBox(height: Dimens.innerPadding),
        ],
      ),
    );
  }
}