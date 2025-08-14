import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/service/service.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/search/search_service.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/info_placeholder.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_view.dart';
import 'package:otatime_flutter/widgets/transition.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService service = SearchService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        return AppBarConnection(
          appBars: [
            AppBar(
              behavior: AbsoluteAppBarBehavior(),
              body: _HeaderAppBar(service: service),
            ),
          ],
          // 초기 로딩 상태가 변화할 때마다 전환 애니메이션 적용.
          child: Transition(
            child: Builder(
              key: ValueKey(service.status),
              builder: (context) {
                if (service.status == ServiceStatus.none) {
                  return SizedBox();
                }

                // 검색 결과가 존재하지 않는 경우.
                if (service.status != ServiceStatus.loading
                 && service.data.posts.isEmpty) {
                  return InfoPlaceholder(
                    iconPath: "search".svg,
                    title: "다시 시도해주세요!",
                    label: "‘${service.keyword}’ 검색 결과를 찾을 수 없습니다.",
                  );
                }

                return Disableable(
                  isEnabled: service.status != ServiceStatus.refresh,
                  child: PostScrollView(service: service),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HeaderAppBar extends StatefulWidget {
  const _HeaderAppBar({
    super.key,
    required this.service,
  });

  final SearchService service;

  @override
  State<_HeaderAppBar> createState() => _HeaderAppBarState();
}

class _HeaderAppBarState extends State<_HeaderAppBar> {
  late String previousKeyword = widget.service.keyword;

  void submit() {
    // 기존에 검색한 키워드와 다르지 않은 경우.
    if (previousKeyword == widget.service.keyword) {
      return;
    }

    if (widget.service.status == ServiceStatus.loaded) {
      setState(() => previousKeyword = widget.service.keyword);
      widget.service.refresh();
      return;
    }

    if (widget.service.status == ServiceStatus.none) {
      setState(() => previousKeyword = widget.service.keyword);
      widget.service.load();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 기존에 검색한 키워드와 다르지 않는지에 대한 여부.
    bool isSameKeyword = previousKeyword == widget.service.keyword;

    return Padding(
      padding: EdgeInsets.all(Dimens.outerPadding),
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: "search-bar",
              child: InputField(
                hintText: "행사 이름 검색",
                autofocus: true,
                onSubmitted: (_) => submit(),
                onChanged: (newValue) {
                  setState(() => widget.service.keyword = newValue);
                },
              ),
            ),
          ),

          // 검색어 제출 버튼.
          Disableable(
            isEnabled: !isSameKeyword,
            child: submitButtonWidget(),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    final bool canSubmit = widget.service.keyword != "";
    final bool isLoading =
        widget.service.status == ServiceStatus.loading ||
        widget.service.status == ServiceStatus.refresh;

    return AnimatedSize(
      alignment: Alignment.centerRight,
      duration: Animes.transition.duration,
      curve: Animes.transition.curve,
      child: Align(
        alignment: Alignment.centerRight,
        widthFactor: canSubmit ? 1 : 0,
        child: AnimatedOpacity(
          duration: Animes.transition.duration,
          curve: Animes.transition.curve,
          opacity: canSubmit ? 1 : 0,
          child: TouchScale(
            onPress: submit,
            child: Container(
              margin: EdgeInsets.only(left: Dimens.innerPadding),
              padding: EdgeInsets.all(Dimens.innerPadding),
              decoration: BoxDecoration(
                color: Scheme.current.primary,
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
              ),
              child: Transition(
                child: Builder(
                  key: ValueKey(isLoading),
                  builder: (context) {
                    // 새로고침을 포함한 로딩 중엔 인디케이터 표시.
                    if (isLoading) {
                      return LoadingIndicator(size: 18);
                    }

                    return SvgPicture.asset(
                      "search".svg,
                      width: 18,
                      color: Scheme.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}