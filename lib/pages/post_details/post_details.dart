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

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({
    super.key,
    required this.model,
  });

  final PostModel model;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final AppBarController _appBarController = AppBarController();

  // TODO: 임시 코드.
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

    // 상태 표시줄 아이콘 스타일을 라이트 위주로 변경.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Scheme.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppBarPosition position = _appBarController.positionOf(0)!;

      position.addListener(() {
        if (position.shrinkedPercent > 0.5) {
          MainApp.initSystemUIOverlayStyle();
        } else {
          // 헤더가 펼쳐진 상태에서는 스타일을 라이트 위주로 변경.
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

    // 기존 상태 표시줄 스타일로 복원.
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

                                  // 행사 위치 표시.
                                  Text(
                                    "${model.region} · ${model.location}",
                                    style: TextStyle(color: Scheme.current.foreground2),
                                  ),
                                ],
                              ),

                              SizedBox(height: Dimens.columnSpacing),

                              Text(
                                model.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              ),

                              SizedBox(height: Dimens.columnSpacing),

                              // 상위 카테고리 및 하위 카테고리 간략히 표시.
                              Text(
                                "#${model.sector} #${model.type}",
                                style: TextStyle(color: Scheme.current.foreground2),
                              ),

                              SizedBox(height: Dimens.innerPadding),

                              // 행사 날짜
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: Dimens.columnSpacing,
                                spacing: 5,
                                children: [
                                  // D-Day (3일) 임박시 표시.
                                  if (isDDay) dDayWidget(),
                                  DateButton(date: model.startDate),
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

                    // 행사 상세 내용 표시.
                    labeledBy(
                      label: "상세 내용",
                      child: Container(
                        padding: EdgeInsets.all(Dimens.innerPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.borderRadius),
                          color: Scheme.current.deepground,
                        ),
                        child: Text(
                          loremText,
                          style: TextStyle(color: Scheme.current.foreground2, height: 1.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 시각적 자연스러움을 위한 액션 영역 위치의 그림자 효과.
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
                          ]
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
                    // 뒤로가기 버튼.
                    ActionButton(
                      iconPath: "arrow_left".svg,
                      onTap: () => Navigator.pop(context),
                    ),
                    ActionButton(iconPath: "heart".svg, onTap: () {}),
                    ActionButton(iconPath: "link".svg, onTap: () {})
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
          child: WideButton(
            iconPath: "navigation-filled".svg,
            label: "위치 보기",
            onTap: () {

              // 행사 지도 페이지로 이동.
              Navigator.push(context, AppPageRoute(builder: (_) => PostMapPage()));
            },
          ),
        ),
      ],
    );
  }

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

class _HeaderAppBar extends StatelessWidget {
  const _HeaderAppBar({
    super.key,
    required this.model,
  });

  final PostModel model;

  @override
  Widget build(BuildContext context) {
    // 자연스러운 색 보간을 위해 배경색을 기반으로 하는 투명색을 사용함.
    final Color transparent = Scheme.current.background.withAlpha(0);

    return Stack(
      children: [
        AppImage.network(
          url: model.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
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

  static AppBar createAppBar(BuildContext context, {required PostModel model}) {
    final MediaQueryData mediaData = MediaQuery.of(context);
    final double statusBarHeight = mediaData.padding.top;
    final double viewHeight = mediaData.size.height;

    return SizedAppBar.builder(
      minExtent: statusBarHeight,
      maxExtent: viewHeight / 3.5,
      behavior: MaterialAppBarBehavior(),
      builder: (context, position) {

        // 앱바가 접혀질수록 서서히 사라지도록 함.
        return AppBarFadeEffect.onShrink(
          position: position,
          child: _HeaderAppBar(model: model),
        );
      },
    );
  }
}