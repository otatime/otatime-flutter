import 'package:flutter/widgets.dart';
import 'package:flutter_scroll_bottom_sheet/flutter_bottom_sheet.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 앱 전반에서 사용되는 바텀 시트의 공통적인 UI/UX를 정의합니다.
class BottomSheetUX {
  /// 앱이 시작될 때 호출되어 모든 바텀 시트에 대한 전역적인 스타일과 레이아웃을 설정합니다.
  /// 이를 통해 앱 전체에서 일관된 바텀 시트 경험을 제공합니다.
  static void initialize() {
    // 포괄적으로 전역적인 바텀 시트에 대한 디자인 설정.
    BottomSheet.config = BottomSheetConfig(
      barrierColor: Scheme.current.barrier,
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Scheme.current.rearground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // 상단 드래그 핸들(인디케이터).
                Padding(
                  padding: EdgeInsets.all(Dimens.innerPadding),
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1e10),
                      color: Scheme.current.border,
                    ),
                  ),
                ),
                MediaQuery(
                  data: data.copyWith(
                    // 핸들과 겹치지 않도록 콘텐츠 영역에 대한 상단 여백 추가.
                    padding: data.padding.copyWith(top: Dimens.outerPadding * 2 + 4),
                  ),
                  child: child,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}