import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/components/ux/app_page_route.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/main.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/pages/post_map/post_map.dart';
import 'package:otatime_flutter/widgets/action_button.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/date_button.dart';
import 'package:otatime_flutter/widgets/separated_line.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

/// 게시물 상세 정보를 표시하는 페이지.
class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({
    super.key,
    required this.model,
  });

  /// 상세 정보를 표시할 게시물 데이터 모델.
  final PostModel model;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  /// 헤더 앱바의 스크롤 동작을 제어하는 컨트롤러.
  final AppBarController _appBarController = AppBarController();

  // TODO: 임시 코드.
  /// 게시물 상세 내용에 대한 임시 텍스트.
  static const String loremText = """
안녕하세요, 여러분!
2025년 8월 9일부터 드디어 기다리던 NIKKE 행사가 시작됩니다.
이번 행사는 최신 트렌드와 혁신적인 콘텐츠가 가득한 특별한 시간으로, 많은 분들이 기대하고 계실 거예요.

행사 기간 동안 다양한 프로그램과 워크숍, 그리고 흥미진진한 이벤트가 준비되어 있습니다.
특히 이번에는 참가자분들이 직접 체험할 수 있는 체험 부스도 마련되어 있어 현장감 넘치는 경험을 할 수 있답니다.

여러분 모두 소중한 추억을 만들 수 있는 이번 행사에 꼭 참여해 주세요!
더 자세한 정보와 일정은 곧 업데이트 예정이니 자주 확인 부탁드립니다.

감사합니다!
  """;

  @override
  void initState() {
    super.initState();

    // 페이지 진입 시, 헤더 이미지에 맞게 상태 표시줄 아이콘을 밝게 설정합니다.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Scheme.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // 위젯 렌더링이 완료된 후, 스크롤 위치에 따라 상태 표시줄 스타일을 동적으로 변경하는 리스너를 추가합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppBarPosition position = _appBarController.positionOf(0)!;

      position.addListener(() {
        // 헤더가 50% 이상 축소되면 기본 시스템 UI 스타일로 복원합니다.
        if (position.shrinkedPercent > 0.5) {
          MainApp.initSystemUIOverlayStyle();
        } else {
          // 헤더가 펼쳐진 상태에서는 상태 표시줄 아이콘을 다시 밝게 설정합니다.
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Scheme.transparent,
            statusBarIconBrightness: Brightness.light,
          ));
        }
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();

    // 페이지를 벗어날 때, 기존 시스템 UI 스타일로 복원합니다.
    MainApp.initSystemUIOverlayStyle();
  }

  @override
  Widget build(BuildContext context) {
    final PostModel model = widget.model;
    final bool isDDay = model.dDay <= 3;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              AppBarConnection(
                controller: _appBarController,
                appBars: [
                  _HeaderAppBar.createAppBar(context, model: model),
                ],
                child: ListView(
                  padding: EdgeInsets.all(Dimens.outerPadding),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimens.innerPadding,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.borderRadius2),
                          // 작성자의 프로필 이미지.
                          child: AppImage.network(
                            url: model.writer.profileImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                spacing: Dimens.rowSpacing,
                                children: [
                                  SvgPicture.asset(
                                    "navigation-filled".svg,
                                    height: 16,
                                    color: Scheme.current.foreground2,
                                  ),

                                  // 행사 위치.
                                  Text(
                                    "${model.region} · ${model.location}",
                                    style: TextStyle(color: Scheme.current.foreground2),
                                  ),
                                ],
                              ),

                              SizedBox(height: Dimens.columnSpacing),

                              // 게시물 제목.
                              Text(
                                model.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              ),

                              SizedBox(height: Dimens.columnSpacing),

                              // 게시물의 카테고리 태그.
                              Text(
                                "#${model.sector} #${model.type}",
                                style: TextStyle(color: Scheme.current.foreground2),
                              ),

                              SizedBox(height: Dimens.innerPadding),

                              // 행사 날짜.
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: Dimens.columnSpacing,
                                spacing: 5,
                                children: [
                                  // D-Day가 3일 이내로 임박했을 때 D-DAY 배지를 표시합니다.
                                  if (isDDay) dDayWidget(),
                                  // 행사 시작일.
                                  DateButton(date: model.startDate),
                                  // 행사 종료일.
                                  DateButton(date: model.endDate),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimens.innerPadding),
                    SeparatedLine.horizontal(),
                    SizedBox(height: Dimens.innerPadding),

                    // 행사 상세 내용 섹션.
                    labeledBy(
                      label: "상세 내용",
                      child: Container(
                        padding: EdgeInsets.all(Dimens.innerPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.borderRadius),
                          color: Scheme.current.deepground,
                        ),
                        // 상세 내용 텍스트.
                        child: Text(
                          loremText,
                          style: TextStyle(color: Scheme.current.foreground2, height: 1.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 액션 버튼 영역의 가독성을 높이기 위한 그래디언트 그림자 효과.
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Scheme.current.background.withAlpha(0),
                            Scheme.current.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: Dimens.outerPadding,
                bottom: Dimens.outerPadding,
                child: Row(
                  spacing: Dimens.innerPadding,
                  children: [
                    // 이전 페이지로 돌아가는 버튼.
                    ActionButton(
                      iconPath: "arrow_left".svg,
                      onTap: () => Navigator.pop(context),
                    ),
                    // '좋아요' 또는 '북마크' 기능 버튼.
                    ActionButton(iconPath: "heart".svg, onTap: () {}),
                    // 링크 공유 기능 버튼.
                    ActionButton(iconPath: "link".svg, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          // 행사 위치를 지도로 보여주는 페이지로 이동하는 버튼.
          child: WideButton(
            iconPath: "navigation-filled".svg,
            label: "위치 보기",
            onTap: () {
              // 지도 페이지로 이동합니다.
              Navigator.push(context, AppPageRoute(builder: (_) => PostMapPage()));
            },
          ),
        ),
      ],
    );
  }

  /// 라벨과 콘텐츠 위젯을 수직으로 배치하는 헬퍼 함수입니다.
  Widget labeledBy({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        child,
      ],
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
}

/// 게시물 상세 페이지의 상단에 표시되는 이미지 헤더 앱바입니다.
class _HeaderAppBar extends StatelessWidget {
  const _HeaderAppBar({
    super.key,
    required this.model,
  });

  /// 헤더에 표시할 데이터가 담긴 게시물 모델.
  final PostModel model;

  @override
  Widget build(BuildContext context) {
    // 자연스러운 색상 전환을 위해 배경색 기반의 투명색을 사용합니다.
    final Color transparent = Scheme.current.background.withAlpha(0);

    return Stack(
      children: [
        // 헤더의 배경 이미지.
        AppImage.network(
          url: model.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // 이미지 위에 어두운 그래디언트를 오버레이하여 가독성을 확보하고 시각적 효과를 줍니다.
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Scheme.black.withAlpha(150),
                  Scheme.black.withAlpha(75),
                  transparent,
                  transparent,
                  transparent,
                  transparent,
                  transparent,
                  Scheme.current.background.withAlpha(100),
                  Scheme.current.background.withAlpha(200),
                  Scheme.current.background,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 주어진 모델을 기반으로 스크롤 가능한 `SizedAppBar`를 생성합니다.
  static AppBar createAppBar(BuildContext context, {required PostModel model}) {
    final MediaQueryData mediaData = MediaQuery.of(context);
    final double statusBarHeight = mediaData.padding.top;
    final double viewHeight = mediaData.size.height;

    return SizedAppBar.builder(
      minExtent: statusBarHeight,
      maxExtent: viewHeight / 3.5,
      behavior: MaterialAppBarBehavior(),
      builder: (context, position) {
        // 앱바가 축소될 때 내용이 서서히 사라지는 효과를 적용합니다.
        return AppBarFadeEffect.onShrink(
          position: position,
          child: _HeaderAppBar(model: model),
        );
      },
    );
  }
}