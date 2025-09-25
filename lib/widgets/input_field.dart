import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

/// [InputField] 우측에 표시될 액션 버튼의 설정을 정의합니다.
class InputFieldAction {
  const InputFieldAction({
    required this.iconPath,
    required this.onTap,
    this.width,
    this.height,
  });

  /// 액션 버튼에 표시될 아이콘의 SVG 경로.
  final String iconPath;

  /// 액션 버튼을 탭했을 때 호출될 콜백.
  final VoidCallback onTap;

  /// 아이콘의 너비.
  final double? width;

  /// 아이콘의 높이.
  final double? height;
}

/// 해당 위젯은 애플리케이션 내에서 공통적으로 사용되는 [TextField] 입니다.
class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.action,
    this.minLines,
    this.maxLines = 1,
  });

  /// 입력 필드에 표시될 안내 문구.
  final String? hintText;

  /// 유효성 검사 실패 시 표시될 오류 메시지.
  final String? errorText;

  /// 입력 값이 변경될 때마다 호출되는 콜백.
  final ValueChanged<String>? onChanged;

  /// 사용자가 입력을 완료하고 제출했을 때 호출되는 콜백.
  final ValueChanged<String>? onSubmitted;

  /// 입력 내용을 숨길지 여부 (예: 비밀번호).
  final bool obscureText;

  /// 위젯이 화면에 나타날 때 자동으로 포커스를 받을지 여부.
  final bool autofocus;

  /// 입력 필드의 포커스를 직접 제어하기 위한 노드.
  final FocusNode? focusNode;

  /// 입력 필드에 표시될 키보드 유형.
  final TextInputType? keyboardType;

  /// 입력 필드 우측에 표시될 액션 버튼.
  final InputFieldAction? action;

  /// 입력 필드의 최소 줄 수.
  final int? minLines;

  /// 입력 필드의 최대 줄 수.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    // 오류 메시지 표시 등으로 인해 위젯 크기가 변경될 때 부드러운 애니메이션 효과를 적용.
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: Animes.transition.duration,
      curve: Animes.transition.curve,
      child: Stack(
        children: [
          TextField(
            keyboardType: keyboardType,
            cursorColor: Scheme.current.primary,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            obscureText: obscureText,
            autofocus: autofocus,
            style: TextStyle(fontSize: 16, color: Scheme.current.foreground),
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              // 액션 버튼 유무에 따라 오른쪽 여백을 동적으로 조절.
              contentPadding: EdgeInsets.only(
                top: Dimens.innerPadding,
                left: Dimens.innerPadding,
                right: action == null ? Dimens.innerPadding : 50,
                bottom: Dimens.innerPadding,
              ),

              // 입력 필드의 기본 테두리.
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.border),
              ),

              // 활성화 상태의 테두리.
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.border),
              ),

              // 포커스 상태의 테두리.
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.primary),
              ),

              // 오류 상태의 테두리.
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Scheme.negative),
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
              ),

              // 오류 상태에서 포커스되었을 때의 테두리.
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Scheme.negative),
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
              ),
              fillColor: Scheme.current.backgroundInInput,
              filled: true,
              errorText: errorText,
              errorStyle: TextStyle(fontSize: 14, color: Scheme.negative),
              hintText: hintText,
              hintStyle: TextStyle(color: Scheme.current.foreground3),
            ),
          ),

          // 액션이 정의된 경우, 액션 위젯(버튼)을 화면에 표시.
          if (action != null) actionWidget(),
        ],
      ),
    );
  }

  /// 입력 필드 우측에 표시될 액션 버튼 위젯을 생성합니다.
  Widget actionWidget() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerRight,

        // 사용자가 버튼을 탭했을 때 시각적인 축소/확대 피드백을 제공.
        child: TouchScale(
          onPress: action!.onTap,
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              action!.iconPath,
              width: action?.width ?? 18,
              height: action?.height,
              color: Scheme.current.foreground2,
            ),
          ),
        ),
      ),
    );
  }
}