import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

class SignOutPage extends StatefulWidget {
  const SignOutPage({super.key});

  @override
  State<SignOutPage> createState() => _SignOutPageState();
}

class _SignOutPageState extends State<SignOutPage> {
  bool isLoading = false;

  /// 비밀번호 난독화 끄기 여부.
  bool isVisiblePassword = false;

  String inputName = "";
  String inputEmail = "";
  String inputPassword = "";

  String? inputNameError;
  String? inputEmailError;
  String? inputPasswordError;

  void updateInputName(String newValue) => setState(() {
    inputName = newValue;
    inputNameError = null;
  });

  void updateInputEmail(String newValue) => setState(() {
    inputEmail = newValue;
    inputEmailError = null;
  });

  void updateInputPassword(String newValue) => setState(() {
    inputPassword = newValue;
    inputPasswordError = null;
  });

  bool get canNext {
    return inputName != "" && inputEmail != "" && inputPassword != "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Disableable(
            isEnabled: !isLoading,
            child: HeaderConnection(
              title: "회원가입",
              child: ListView(
                padding: EdgeInsets.all(Dimens.outerPadding),
                children: [
                  InputField(
                    hintText: "이름",
                    errorText: inputNameError,
                    onChanged: updateInputName,
                  ),
                  SizedBox(height: Dimens.innerPadding),
                  InputField(
                    hintText: "이메일",
                    errorText: inputEmailError,
                    onChanged: updateInputEmail,
                  ),
                  SizedBox(height: Dimens.innerPadding),
                  InputField(
                    hintText: "비밀번호",
                    errorText: inputPasswordError,
                    onChanged: updateInputPassword,
                    obscureText: !isVisiblePassword,
                    action: InputFieldAction(
                      iconPath: isVisiblePassword ? "eye_off".svg : "eye".svg,
                      onTap: () {
                        // 비밀번호 보기 여부 토글.
                        setState(() => isVisiblePassword = !isVisiblePassword);
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Dimens.outerPadding,
            right: Dimens.outerPadding,
            bottom: Dimens.outerPadding,
          ),
          child: Disableable(
            isEnabled: canNext,
            child: WideButton(
              label: "다음",
              isLoading: isLoading,
              onTap: () async {
                setState(() => isLoading = true);
                await Future.delayed(Duration(seconds: 1));
                setState(() => isLoading = false);
              }
            ),
          ),
        ),
      ],
    );
  }
}