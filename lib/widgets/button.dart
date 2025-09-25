import 'package:flutter/widgets.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// 버튼의 시각적 스타일을 정의하는 열거형.
enum ButtonType {
  /// 주요 액션 버튼. 채워진 배경을 가짐.
  primary,

  /// 보조 액션 버튼. 배경이 없음.
  secondary,

  /// 덜 중요한 액션 버튼.
  tertiary,

  /// 밑줄이 있는 텍스트 형태의 버튼.
  underLine,
}

/// 해당 위젯은 앱 전반에서 사용되는 공용 버튼입니다.
/// [type]에 따라 다양한 시각적 스타일을 가집니다.
class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.type,
    required this.label,
    required this.onTap,
  });

  /// 버튼의 시각적 스타일 유형.
  final ButtonType type;

  /// 버튼에 표시될 텍스트.
  final String label;

  /// 버튼을 탭했을 때 실행될 콜백 함수.
  final VoidCallback onTap;

  /// 버튼에서 공통적으로 사용되는 안쪽 여백.
  static EdgeInsets get padding => EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.primary => primaryWidget(),
      ButtonType.secondary => secondaryWidget(),
      ButtonType.tertiary => tertiaryWidget(),
      ButtonType.underLine => underLineWidget(),
    };
  }

  /// `primary` 타입의 버튼 위젯을 생성합니다.
  Widget primaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1e10),
          color: Scheme.current.primary,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Scheme.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// `secondary` 타입의 버튼 위젯을 생성합니다.
  Widget secondaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Scheme.current.primary,
          ),
        ),
      ),
    );
  }

  /// `tertiary` 타입의 버튼 위젯을 생성합니다.
  Widget tertiaryWidget() {
    return TouchScale(
      onPress: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Scheme.current.foreground2,
          ),
        ),
      ),
    );
  }

  /// `underLine` 타입의 버튼 위젯을 생성합니다.
  Widget underLineWidget() {
    return TouchScale(
      onPress: onTap,
      child: Stack(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Scheme.current.foreground3,
            ),
          ),

          // 글자 밑줄 표시.
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 1, color: Scheme.current.foreground3),
            ),
          ),
        ],
      ),
    );
  }
}
