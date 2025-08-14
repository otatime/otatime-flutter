import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_touch_scale/widgets/touch_scale.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';

class InputFieldAction {
  const InputFieldAction({
    required this.iconPath,
    required this.onTap,
    this.width,
    this.height,
  });

  final String iconPath;
  final VoidCallback onTap;
  final double? width;
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
  });

  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final InputFieldAction? action;

  @override
  Widget build(BuildContext context) {
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
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: Dimens.innerPadding,
                left: Dimens.innerPadding,
                right: action == null ? Dimens.innerPadding : 50,
                bottom: Dimens.innerPadding,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                borderSide: BorderSide(width: 2, color: Scheme.current.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Scheme.negative),
                borderRadius: BorderRadius.circular(Dimens.borderRadius)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Scheme.negative),
                borderRadius: BorderRadius.circular(Dimens.borderRadius)
              ),
              fillColor: Scheme.current.backgroundInInput,
              filled: true,
              errorText: errorText,
              errorStyle: TextStyle(fontSize: 14, color: Scheme.negative),
              hintText: hintText,
              hintStyle: TextStyle(color: Scheme.current.foreground3)
            ),
          ),

          if (action != null) actionWidget(),
        ],
      )
    );
  }

  /// 입력 필드에서 오른쪽 상단에서의 액션 버튼.
  Widget actionWidget() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerRight,
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