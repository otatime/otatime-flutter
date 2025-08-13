import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/shared/palette.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/modal_popup.dart';
import 'package:otatime_flutter/components/ux/select_box.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/home/home_service.dart';
import 'package:otatime_flutter/pages/post_details/post_details.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/calendar_picker.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/date_button.dart';
import 'package:otatime_flutter/widgets/designed.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/scroll_edge_fade.dart';
import 'package:otatime_flutter/widgets/service_builder.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_view.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:otatime_flutter/widgets/transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceBuilder(
      serviceBuilder: (_) => PostService(),
      builder: (context, service) {
        return AppBarConnection(
          appBars: [
            AppBar(behavior: _TopAppBar.createAppBarBehavior(), body: _TopAppBar(service: service)),
            AppBar(behavior: _BottomAppBar.createAppBarBehavior(), body: _BottomAppBar(service: service)),
          ],
          child: RefreshIndicator(
            onRefresh: service.refresh,
            child: Disableable(
              isEnabled: service.status != ServiceStatus.refresh,
              child: AppBarConnection(
                appBars: [
                  AppBar.builder(
                    behavior: _Slider.createAppBarBehavior(),
                    builder: (context, position) {
                      return Opacity(
                        opacity: position.expandedPercent,
                        child: _Slider(),
                      );
                    },
                  ),
                ],
                child: PostScrollView(service: service),
              ),
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

  final PostService service;

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
              _LocationSelectBox(
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

  final PostService service;

  static List<String> categorys = [
    "애니메이션",
    "게임",
    "행사",
    "공연",
    "캐릭터",
    "성우 행사",
  ];

  void showCalendarPopup(BuildContext context) {
    DateTime? startDate = service.startDate;
    DateTime? endDate = service.endDate;

    Navigator.push(context, ModalPopupRoute(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarPicker.range(
            initialStartDate: startDate,
            initialEndDate: endDate,
            onStartChanged: (newDate) => startDate = newDate,
            onEndChanged: (newDate) => endDate = newDate,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                type: ButtonType.tertiary,
                label: "취소",
                onTap: () => Navigator.pop(context),
              ),
              Button(
                type: ButtonType.secondary,
                label: "완료",
                onTap: () {
                  // 변경 사항이 없는 경우.
                  if (service.startDate != startDate
                   || service.endDate != endDate) {
                    service.startDate = startDate ?? endDate;
                    service.endDate = endDate ?? startDate;
                    service.refresh();
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 시각적 자연스러움을 위해 별도의 여백 추가.
      padding: EdgeInsets.only(bottom: Dimens.outerPadding / 2),
      child: Row(
        children: [
          Expanded(child: categoriesWidget()),

          // 날짜 선택에 대한 팝업 열기 버튼.
          CircularButton(
            iconPath: "calendar".svg,
            foregroundColor: Scheme.current.foreground2,
            onTap: () => showCalendarPopup(context),
          ),
        ],
      ),
    );
  }

  // 상위 카테고리 위젯.
  Widget categoriesWidget() {
    return ScrollEdgeFade.horizontal(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Dimens.outerPadding),
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
        // 선택 상태가 변화할 때마다 전환 애니메이션 적용.
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

class _LocationSelectBox extends StatelessWidget {
  const _LocationSelectBox({
    super.key,
    required this.index,
    required this.items,
    required this.onChanged,
  });

  final int index;
  final List<String> items;
  final ValueChanged<int> onChanged;

  /// 선택용 바텀 시트 열기.
  void _openBottomSheet(BuildContext context) {
    SelectBox.open(context, index: index, items: items, onSelected: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: () => _openBottomSheet(context),
      child: Transition(
        child: Container(
          key: ValueKey(index),
          padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1e10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12 / 2,
            children: [
              SvgPicture.asset(
                "navigation-filled".svg,
                width: 12,
                color: Scheme.current.foreground2,
              ),
              Text(items[index], style: TextStyle(color: Scheme.current.foreground2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceBuilder(
      serviceBuilder: (_) => PostBannerService(),
      builder: (context, service) {
        return Transition(
          // 로딩 상태가 변화할 때마다 전환 애니메이션 적용.
          child: Builder(
            key: ValueKey(service.isLoading),
            builder: (context) {
              if (service.isLoading) {
                return skeletonWidget();
              }

              final List<PostModel> models = service.data.posts;

              return wrapperWidget(
                itemCount: models.length,
                itemBuilder: (context, index) {
                  return _SliderItem(model: models[index]);
                },
              );
            },
          ),
        );
      }
    );
  }

  static Widget wrapperWidget({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double padding = Dimens.outerPadding;
        final double spacing = Dimens.outerPadding / 2;
        final double itemWidth = width - (padding * 2) + spacing;
        final double fraction = itemWidth / width;
        final controller = PageController(viewportFraction: fraction);

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.innerPadding,
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: PageView.builder(
                controller: controller,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                    child: itemBuilder(context, index),
                  );
                },
              ),
            ),

            // 인디케이터 표시.
            SmoothPageIndicator(
              controller: controller,
              count: itemCount,
              onDotClicked: (index) {
                // 특정 인디케이터 클릭 시, 해당 페이지로 이동.
                controller.animateToPage(
                  index,
                  curve: Animes.transition.curve,
                  duration: Animes.transition.duration,
                );
              },
              effect: ExpandingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                dotColor: Scheme.current.rearground,
                activeDotColor: Scheme.current.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget skeletonWidget() {
    return wrapperWidget(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Skeleton(child: Skeleton.partOf());
      }
    );
  }

  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(alignAnimation: false);
  }
}

class _SliderItem extends StatefulWidget {
  const _SliderItem({
    super.key,
    required this.model,
  });

  final PostModel model;

  @override
  State<_SliderItem> createState() => _SliderItemState();
}

class _SliderItemState extends State<_SliderItem> {
  Color? paletteColor;

  void _initPaletteColor() async {
    final generator = await Palette.of(widget.model.imageUrl);

    // 가장 유사한 이미지 대표색을 정의합니다.
    if (!mounted) return;
    setState(() => paletteColor = generator.dominantColor?.color);
  }

  @override
  void initState() {
    super.initState();
    _initPaletteColor();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openElevation: 0,
      openColor: Scheme.current.background,
      openBuilder: (_, _) {
        return Designed(child: PostDetailsPage(model: widget.model));
      },
      // 내부 아이템의 곡선 값을 그대로 유지.
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
      ),
      closedElevation: 0,
      closedColor: Scheme.current.background,
      closedBuilder: (context, openContainer) {
        return Designed.themeWidget(
          child: TouchScale(
            scale: 0.95,
            onPress: openContainer,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
              child: Stack(
                children: [
                  AppImage.network(
                    url: widget.model.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // 이미지 대표색으로 별도의 그림자 렌더링.
                  if (paletteColor != null)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            paletteColor!,
                            paletteColor!.withAlpha(50),
                            Scheme.transparent,
                          ]
                        )
                      ),
                    ),

                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.innerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          // 행사 제목 표시.
                          Text(
                            widget.model.title,
                            style: TextStyle(
                              color: Scheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                          ),

                          // 행사 일정 표시.
                          Wrap(
                            spacing: Dimens.rowSpacing,
                            children: [
                              DateButton(date: widget.model.startDate),
                              Text("~", style: TextStyle(color: Scheme.current.foreground3)),
                              DateButton(date: widget.model.endDate),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}