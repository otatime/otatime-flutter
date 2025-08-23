import 'package:flutter/widgets.dart';
import 'package:flutter_scroll_bottom_sheet/flutter_bottom_sheet.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class BottomSheetUX {
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
                // 인디케이터.
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
                    // 수직 스크롤 뷰에 대한 기본 패딩 정의.
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