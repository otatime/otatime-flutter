import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:intl/intl.dart';
import 'package:otatime_flutter/components/auth/my_user.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/components/ux/hero_open_container.dart';
import 'package:otatime_flutter/components/ux/modal_popup.dart';
import 'package:otatime_flutter/components/ux/select_box_sheet.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/home/home_service.dart';
import 'package:otatime_flutter/pages/post_details/post_details.dart';
import 'package:otatime_flutter/pages/report/report.dart';
import 'package:otatime_flutter/pages/search/search.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/calendar_picker.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/openable.dart';
import 'package:otatime_flutter/widgets/palette_image.dart';
import 'package:otatime_flutter/widgets/scroll_edge_fade.dart';
import 'package:otatime_flutter/widgets/service_builder.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_view.dart';
import 'package:otatime_flutter/widgets/skeleton.dart';
import 'package:otatime_flutter/widgets/transition.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// 홈 화면 페이지 위젯.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceBuilder(
      serviceBuilder: (_) => PostService(),
      builder: (context, service) {
        return AppBarConnection(
          appBars: [
            // 상단 앱 바 (로고, 지역 선택, 검색/제보 버튼).
            AppBar(behavior: _TopAppBar.createAppBarBehavior(), body: _TopAppBar(service: service)),

            // 하단 앱 바 (카테고리, 날짜 선택 버튼).
            AppBar(behavior: _BottomAppBar.createAppBarBehavior(), body: _BottomAppBar(service: service)),
          ],
          child: RefreshIndicator(
            onRefresh: service.refresh,
            child: Disableable(
              isEnabled: service.status != ServiceStatus.refresh,
              child: AppBarConnection(
                appBars: [
                  // 상단 배너 슬라이더.
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

                // 게시글 목록 스크롤 뷰.
                child: PostScrollView(service: service),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 홈 화면의 상단 앱 바 위젯. 로고, 지역 선택, 제보/검색 버튼을 포함.
class _TopAppBar extends StatelessWidget {
  const _TopAppBar({
    super.key,
    required this.service,
  });

  final PostService service;

  /// 지역 선택 옵션 목록.
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
          // 왼쪽 영역 (로고, 지역 선택).
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.innerPadding,
            children: [
              // 로고 표시.
              Text(
                "LOGO",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // 지역 선택 박스.
              _LocationSelectBox(
                index: _currentSelectIndex,
                items: ["전체", ...locations],
                onChanged: (newValue) {
                  // '전체'(인덱스 0) 선택 시 null로 설정, 그 외는 해당 지역 이름으로 설정.
                  service.location = newValue == 0 ? null : locations[newValue - 1];
                  service.refresh();
                },
              ),
            ],
          ),

          // 오른쪽 영역 (제보, 검색 버튼). 사용자 상태가 변경될 때마다 업데이트됨.
          ListenableBuilder(
            listenable: MyUser.statusNotifier,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제보 버튼. 로그인 상태일 때만 활성화.
                  Disableable(
                    isEnabled: MyUser.status == MyUserStatus.loaded,
                    child: CircularButton(
                      iconPath: "paper_plane".svg,
                      onTap: () {
                        // 제보 페이지로 이동.
                        Navigator.push(
                          context,
                          AppPageRoute(builder: (_) => ReportPage()),
                        );
                      }
                    ),
                  ),

                  // 검색 버튼.
                  Hero(
                    tag: "search-bar",
                    flightShuttleBuilder: heroOpenContainerShuttle,
                    child: CircularButton(
                      iconPath: "search".svg,
                      onTap: () {
                        // 검색 페이지로 이동.
                        Navigator.push(
                          context,
                          AppPageRoute(builder: (_) => SearchPage(), isFadeEffect: true),
                        );
                      }
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  /// 위젯에 대한 앱 바 동작을 생성합니다.
  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(floating: true);
  }
}

/// 홈 화면의 하단 앱 바 위젯. 카테고리 필터와 날짜 선택 기능을 포함.
class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    super.key,
    required this.service,
  });

  final PostService service;

  /// 카테고리 필터 목록.
  static List<String> categorys = [
    "애니메이션",
    "게임",
    "행사",
    "공연",
    "캐릭터",
    "성우 행사",
  ];

  /// 날짜 선택을 위한 캘린더 팝업을 표시합니다.
  void showCalendarPopup(BuildContext context) {
    DateTime? startDate = service.startDate;
    DateTime? endDate = service.endDate;

    Navigator.push(context, ModalPopupRoute(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 날짜 범위 선택 캘린더.
          CalendarPicker.range(
            initialStartDate: startDate,
            initialEndDate: endDate,
            onStartChanged: (newDate) => startDate = newDate,
            onEndChanged: (newDate) => endDate = newDate,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 취소 버튼.
              Button(
                type: ButtonType.tertiary,
                label: "취소",
                onTap: () => Navigator.pop(context),
              ),
              // 완료 버튼.
              Button(
                type: ButtonType.secondary,
                label: "완료",
                onTap: () {
                  // 날짜가 변경되었을 경우에만 서비스에 반영하고 새로고침.
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
          // 카테고리 목록 위젯.
          Expanded(child: categoriesWidget()),

          // 날짜 선택 캘린더 팝업을 여는 버튼.
          CircularButton(
            iconPath: "calendar".svg,
            foregroundColor: Scheme.current.foreground2,
            onTap: () => showCalendarPopup(context),
          ),
        ],
      ),
    );
  }

  /// 스크롤 가능한 수평 카테고리 목록 위젯을 생성합니다.
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
                  // '전체' 카테고리.
                  _Category(
                    label: "전체",
                    isSelected: service.category == null,
                    onTap: () {
                      service.category = null;
                      service.refresh();
                    },
                  ),

                  // 정의된 카테고리 목록을 개별 위젯으로 표시.
                  ...categorys.map((category) {
                    return _Category(
                      label: category,
                      isSelected: service.category == category,
                      onTap: () {
                        service.category = category;
                        service.refresh();
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 위젯에 대한 앱 바 동작을 생성합니다.
  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(floating: true);
  }
}

/// 단일 카테고리 항목을 표시하는 위젯.
class _Category extends StatelessWidget {
  const _Category({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  /// 현재 카테고리의 선택 여부.
  final bool isSelected;

  /// 카테고리 라벨.
  final String label;

  /// 탭 이벤트 콜백.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: isSelected ? () {} : onTap,

      // 선택 상태가 변경될 때 전환 애니메이션을 적용.
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
              : Scheme.current.reargroundInBackground,
            borderRadius: BorderRadius.circular(1e10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                ? Scheme.current.background
                : Scheme.current.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// 지역 선택을 위한 드롭다운 형태의 위젯. 탭하면 바텀 시트가 나타남.
class _LocationSelectBox extends StatelessWidget {
  const _LocationSelectBox({
    super.key,
    required this.index,
    required this.items,
    required this.onChanged,
  });

  /// 현재 선택된 항목의 인덱스.
  final int index;

  /// 선택 가능한 항목 목록.
  final List<String> items;

  /// 항목 선택 시 호출되는 콜백.
  final ValueChanged<int> onChanged;

  /// 지역 선택을 위한 바텀 시트를 엽니다.
  void _openBottomSheet(BuildContext context) {
    SelectBoxSheet.open(context, index: index, items: items, onSelected: onChanged);
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
              // 네비게이션 아이콘.
              SvgPicture.asset(
                "navigation-filled".svg,
                width: 12,
                color: Scheme.current.foreground2,
              ),

              // 선택된 지역 이름.
              Text(items[index], style: TextStyle(color: Scheme.current.foreground2)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 홈 화면 상단에 표시되는 추천 게시물 슬라이더 위젯.
class _Slider extends StatelessWidget {
  const _Slider({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceBuilder(
      serviceBuilder: (_) => PostBannerService(),
      builder: (context, service) {
        return Transition(
          // 로딩 상태가 변경될 때마다 전환 애니메이션을 적용.
          child: Builder(
            key: ValueKey(service.isLoading),
            builder: (context) {

              // 로딩 중일 경우 스켈레톤 UI를 표시.
              if (service.isLoading) {
                return skeletonWidget();
              }

              final List<PostModel> models = service.data.posts;

              // 데이터 로딩 완료 시 슬라이더 위젯을 표시.
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

  /// 슬라이더의 전체적인 레이아웃(페이지 뷰, 인디케이터)을 감싸는 정적 위젯 빌더.
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

        // 뷰포트 일부를 보여주기 위한 페이지 컨트롤러 설정.
        final controller = PageController(viewportFraction: fraction);

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.innerPadding,
          children: [
            // 페이지 뷰 슬라이더.
            AspectRatio(
              aspectRatio: 1.5 / 1,
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

            // 페이지 인디케이터.
            SmoothPageIndicator(
              controller: controller,
              count: itemCount,
              onDotClicked: (index) {
                // 특정 인디케이터를 클릭하면 해당 페이지로 부드럽게 이동.
                controller.animateToPage(
                  index,
                  curve: Animes.transition.curve,
                  duration: Animes.transition.duration,
                );
              },
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                dotColor: Scheme.current.foreground.withAlpha(25),
                activeDotColor: Scheme.current.foreground,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 슬라이더의 로딩 상태를 표시하는 스켈레톤 UI 위젯을 생성합니다.
  static Widget skeletonWidget() {
    return wrapperWidget(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Skeleton(child: Skeleton.partOf());
      },
    );
  }

  /// 위젯에 대한 앱 바 동작을 생성합니다.
  static AppBarBehavior createAppBarBehavior() {
    return MaterialAppBarBehavior(alignAnimation: false);
  }
}

/// 슬라이더 내의 개별 항목을 표시하는 위젯.
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
  /// 이미지에서 추출한 대표 색상(팔레트).
  Color? paletteColor;

  /// 팔레트 색상이 어두운지에 대한 여부를 반환합니다.
  bool get isPaletteDark {
    assert(paletteColor != null);
    return paletteColor!.computeLuminance() < 0.5;
  }

  /// 팔레트 색상에 따라 동적으로 결정되는 배경 색상.
  Color get backgroundColor {
    return paletteColor == null
      ? Scheme.current.rearground
      : (isPaletteDark ? Scheme.white.withAlpha(50) : Scheme.black.withAlpha(100));
  }

  /// 팔레트 색상에 따라 동적으로 결정되는 전경(글자) 색상.
  Color get foregroundColor {
    return paletteColor == null
      ? Scheme.current.foreground
      : (isPaletteDark ? Scheme.white : Scheme.black);
  }

  /// 이미지에서 추출한 팔레트 색상으로 상태를 업데이트합니다.
  void setPaletteColor(PaletteGenerator generator) async {
    if (!mounted) return;
    setState(() => paletteColor = generator.dominantColor?.color);
  }

  @override
  Widget build(BuildContext context) {
    return Openable(
      openBuilder: (context) {
        // 탭하면 게시물 상세 페이지로 이동.
        return PostDetailsPage(model: widget.model);
      },

      // 상세 페이지로 전환 시 컨테이너의 곡선 형태를 유지.
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
      ),

      closedBuilder: (context, openContainer) {
        return TouchScale(
          onPress: openContainer,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.borderRadius),
            child: Stack(
              children: [
                // 네트워크 이미지를 표시하고, 이미지에서 팔레트 색상을 추출.
                PaletteImage.network(
                  url: widget.model.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  onPalette: setPaletteColor,
                ),

                // 이미지 하단에 팔레트 색상을 이용한 동적 그라데이션 오버레이.
                Builder(
                  builder: (context) {
                    final Color shadowColor = paletteColor ?? Scheme.current.background;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            shadowColor,
                            shadowColor,
                            shadowColor.withAlpha(50),
                            Scheme.transparent,
                          ],
                        )
                      ),
                    );
                  },
                ),

                // 텍스트 및 정보 콘텐츠 영역.
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.innerPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        // 행사 제목.
                        Text(
                          widget.model.title,
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // 행사 기간 (시작일, 종료일).
                        Wrap(
                          spacing: Dimens.rowSpacing,
                          children: [
                            dateButtonWidget(widget.model.startDate),
                            dateButtonWidget(widget.model.endDate),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 테두리 및 D-Day 상태 배지.
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      final Color backgroundColor = paletteColor ?? Scheme.current.background;
                      final DateTime now = DateTime.now();
                      final int dDay = widget.model.dDay;

                      // 오늘을 기준으로 현재 행사가 진행 중인지에 대한 여부.
                      final bool isProgressing = widget.model.startDate.isBefore(now)
                                              && widget.model.endDate.isAfter(now);

                      /// 행사의 진행 현황을 문자열 표현하여 이를 반환합니다.
                      String getEventStatus() {
                        if (isProgressing) return "현재 진행 중";
                        if (dDay == 1) return "내일 진행";
                        if (dDay == 0) return "오늘 진행";
                        if (dDay > 1) return "$dDay일 후 진행";
                        return "$dDay일 전";
                      }

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.borderRadius),
                          // 테두리 색상을 팔레트 색상으로 동적 설정.
                          border: Border.all(
                            width: 3,
                            color: backgroundColor,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // 행사 진행 현황 배지 (D-Day).
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(Dimens.borderRadius),
                                  ),
                                ),
                                child: Text(
                                  getEventStatus(),
                                  style: TextStyle(color: foregroundColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 날짜 정보를 표시하는 작은 버튼 형태의 위젯을 생성합니다.
  Widget dateButtonWidget(DateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1e10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          // 달력 아이콘.
          SvgPicture.asset(
            "calendar".svg,
            width: 12,
            color: foregroundColor,
          ),

          // 날짜 텍스트 (yyyy-MM-dd 형식).
          Text(
            DateFormat("yyyy-MM-dd").format(date),
            style: TextStyle(
              fontSize: 12,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}