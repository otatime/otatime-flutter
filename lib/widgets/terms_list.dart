import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsItem {
  TermsItem({
    required this.label,
    required this.link,
    required this.required,
  });

  final String label;
  final String link;
  final bool required;

  /// 해당 이용약관에 대한 동의 여부.
  bool isChecked = false;

  /// 주어진 약관들의 필수 약관들이 모두 체크되었는지에 대한 여부를 반환합니다.
  static bool isRequiredItemsChecked(List<TermsItem> items) {
    return items
      .where((item) => item.required)
      .every((item) => item.isChecked);
  }
}

/// 이용약관 항목들을 체크박스로 표시하는 리스트 위젯입니다.
class TermsList extends StatefulWidget {
  const TermsList({
    super.key,
    required this.onChanged,
    required this.items,
  });

  final VoidCallback? onChanged;
  final List<TermsItem> items;

  @override
  State<TermsList> createState() => _TermsListState();
}

class _TermsListState extends State<TermsList> {
  /// 모든 이용약관 항목들이 체크된 상태인지에 대한 여부.
  bool get isCheckedAll {
    return widget.items.every((item) => item.isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        checkboxWidget(
          label: "약관 전체 동의",
          link: null,
          required: false,
          isChecked: isCheckedAll,
          onChanged: (newValue) {
            newValue
              ? setState(() => widget.items.forEach((e) => e.isChecked = true))
              : setState(() => widget.items.forEach((e) => e.isChecked = false));
          },
        ),

        // 개별 약관 목록 표시.
        ...widget.items.map((item) {
          return checkboxWidget(
            label: item.label,
            link: item.link,
            required: item.required,
            isChecked: item.isChecked,
            onChanged: (newValue) {
              setState(() => item.isChecked = newValue);
            },
          );
        }),
      ],
    );
  }

  Widget checkboxWidget({
    required String label,
    required String? link,
    required bool isChecked,
    required bool required,
    required ValueChanged<bool> onChanged,
  }) {
    return TouchScale(
      onPress: () {
        onChanged.call(!isChecked);
        widget.onChanged?.call();
        HapticFeedback.vibrate();
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.outerPadding),
        child: Row(
          spacing: Dimens.innerPadding,
          children: [
            Transition(
              child: SvgPicture.asset(
                key: ValueKey(isChecked),
                "check_circle-filled".svg,
                width: 24,
                color: isChecked
                  ? Scheme.current.primary
                  : Scheme.current.foreground3,
              ),
            ),
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Text(label, style: TextStyle(fontSize: 18)),

                  // 필수 여부를 별표 형태로 표시.
                  if (required)
                    Text("*", style: TextStyle(fontSize: 18, color: Scheme.negative))
                ],
              ),
            ),

            // 약관 참조용 링크 표시.
            if (link != null)
              TouchScale(
                onPress: () => launchUrl(Uri.parse(link)),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SvgPicture.asset(
                    "arrow_right".svg,
                    height: 14,
                    color: Scheme.current.foreground3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}