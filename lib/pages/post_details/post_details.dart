import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/models/post.dart';
import 'package:otatime_flutter/widgets/app_image.dart';
import 'package:otatime_flutter/widgets/date_button.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({
    super.key,
    required this.model,
  });

  final PostModel model;

  @override
  Widget build(BuildContext context) {
    final bool isDDay = model.dDay <= 3;

    return Stack(
      children: [
        AppBarConnection(
          appBars: [
            _HeaderAppBar.createAppBar(model: model),
          ],
          child: ListView(
            padding: EdgeInsets.all(Dimens.outerPadding),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              SizedBox(height: Dimens.columnSpacing),

              // 상위 카테고리 및 하위 카테고리 간략히 표시.
              Text(
                "${model.sector}, ${model.type}",
                style: TextStyle(color: Scheme.current.primary),
              ),

              SizedBox(height: Dimens.innerPadding),

              // 행사 날짜
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                  // D-Day (3일) 임박시 표시.
                  if (isDDay) dDayWidget(),
                  DateButton(date: model.startDate),
                  Text(
                    "부터",
                    style: TextStyle(fontSize: 12, color: Scheme.current.foreground3)
                  ),
                  DateButton(date: model.endDate),
                  Text(
                    "까지",
                    style: TextStyle(fontSize: 12, color: Scheme.current.foreground3)
                  ),
                ],
              ),

              SizedBox(height: Dimens.innerPadding),

              // 행사 상세 내용 표시.
              Container(
                padding: EdgeInsets.all(Dimens.innerPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: Scheme.current.deepground,
                ),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(color: Scheme.current.foreground2),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: Dimens.outerPadding,
          bottom: Dimens.outerPadding,
          child: Row(
            spacing: Dimens.innerPadding,
            children: [
              // 뒤로가기 버튼.
              _ActionButton(
                iconPath: "arrow_left".svg,
                onTap: () => Navigator.pop(context),
              ),
              _ActionButton(iconPath: "heart".svg, onTap: () {}),
              _ActionButton(iconPath: "link".svg, onTap: () {})
            ],
          ),
        ),
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
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 2 / 1,
          child: AppImage.network(
            url: model.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Scheme.transparent,
                  Scheme.transparent,
                  Scheme.current.background.withAlpha(150),
                  Scheme.current.background,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static AppBar createAppBar({required PostModel model}) {
    return AppBar.builder(
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchScale(
      onPress: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: Scheme.current.deepground,
          border: Border.all(color: Scheme.current.border),
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: SizedBox(
          width: 18,
          height: 18,
          child: SvgPicture.asset(
            iconPath,
            color: Scheme.current.foreground2,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}