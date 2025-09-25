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
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/info_placeholder.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/shared/post_scroll_view.dart';
import 'package:otatime_flutter/widgets/transition.dart';

/// 사용자가 키워드를 입력하여 게시물을 검색하는 페이지.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService service = SearchService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        // 서비스의 상태 변경을 감지하여 UI를 다시 빌드합니다.
        listenable: service,
        builder: (context, _) {
          return AppBarConnection(
            appBars: [
              AppBar(
                behavior: AbsoluteAppBarBehavior(),
                body: _HeaderAppBar(service: service),
              ),
            ],

            // 서비스 상태가 변경될 때마다 컨텐츠에 전환 애니메이션을 적용합니다.
            child: Transition(
              child: Builder(
                key: ValueKey(service.status),
                builder: (context) {

                  // 초기 상태에서는 아무것도 표시하지 않습니다.
                  if (service.status == ServiceStatus.none) {
                    return SizedBox();
                  }

                  // 검색 결과가 존재하지 않는 경우, 안내 문구를 표시합니다.
                  if (service.status != ServiceStatus.loading &&
                      service.data.posts.isEmpty) {
                    return InfoPlaceholder(
                      iconPath: "search".svg,
                      title: "다시 시도해주세요!",
                      label: "‘${service.keyword}’ 검색 결과를 찾을 수 없습니다.",
                    );
                  }

                  // 검색 결과를 표시하며, 새로고침 중에는 상호작용을 비활성화합니다.
                  return Disableable(
                    isEnabled: service.status != ServiceStatus.refresh,
                    child: PostScrollView(service: service),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 검색 페이지의 상단에 위치하는 검색 입력 필드 및 관련 UI 위젯.
class _HeaderAppBar extends StatefulWidget {
  const _HeaderAppBar({
    super.key,
    required this.service,
  });

  /// 검색 관련 상태 및 비즈니스 로직을 관리하는 서비스.
  final SearchService service;

  @override
  State<_HeaderAppBar> createState() => _HeaderAppBarState();
}

class _HeaderAppBarState extends State<_HeaderAppBar> {
  /// 이전에 검색을 실행했던 키워드. 중복 검색을 방지하기 위해 사용됩니다.
  late String previousKeyword = widget.service.keyword;

  /// 현재 입력된 키워드로 검색을 실행합니다.
  void submit() {
    // 이전에 검색한 키워드와 동일하면 아무 작업도 수행하지 않습니다.
    if (previousKeyword == widget.service.keyword) {
      return;
    }

    // 이미 검색 결과가 있는 경우, 새로고침을 수행합니다.
    if (widget.service.status == ServiceStatus.loaded) {
      setState(() => previousKeyword = widget.service.keyword);
      widget.service.refresh();
      return;
    }

    // 첫 검색인 경우, 데이터 로드를 시작합니다.
    if (widget.service.status == ServiceStatus.none) {
      setState(() => previousKeyword = widget.service.keyword);
      widget.service.load();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 입력된 키워드가 이전에 검색한 키워드와 동일한지에 대한 여부.
    bool isSameKeyword = previousKeyword == widget.service.keyword;

    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.outerPadding,
        right: Dimens.outerPadding,
        bottom: Dimens.outerPadding,
      ),
      child: Row(
        children: [
          // 뒤로가기 버튼.
          CircularButton(
            iconPath: "arrow_left".svg,
            onTap: () => Navigator.pop(context),
          ),

          // 검색창. 이전 화면으로부터 Hero 애니메이션 효과를 적용받습니다.
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

  /// 검색어를 제출하는 버튼 위젯을 빌드합니다.
  Widget submitButtonWidget() {
    // 검색어를 제출할 수 있는지 여부 (검색어가 비어있지 않음).
    final bool canSubmit = widget.service.keyword != "";

    // 현재 데이터를 로딩하거나 새로고침 중인지 여부.
    final bool isLoading = widget.service.status == ServiceStatus.loading ||
        widget.service.status == ServiceStatus.refresh;

    return AnimatedSize(
      alignment: Alignment.centerRight,
      duration: Animes.transition.duration,
      curve: Animes.transition.curve,

      // 검색어 입력 여부에 따라 버튼의 크기를 애니메이션으로 조절합니다.
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

              // 로딩 상태에 따라 버튼 내부의 아이콘을 로딩 인디케이터로 전환합니다.
              child: Transition(
                child: Builder(
                  key: ValueKey(isLoading),
                  builder: (context) {
                    // 새로고침을 포함한 로딩 중엔 인디케이터 표시.
                    if (isLoading) {
                      return LoadingIndicator(size: 18);
                    }

                    // 기본 상태에서는 검색 아이콘을 표시합니다.
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