import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  /// 비밀번호 난독화 끄기 여부.
  bool isVisiblePassword = false;

  String inputEmail = "";
  String inputPassword = "";

  String? inputEmailError;
  String? inputPasswordError;

  void updateInputEmail(String newValue) => setState(() {
    inputEmail = newValue;
    inputEmailError = null;
  });

  void updateInputPassword(String newValue) => setState(() {
    inputPassword = newValue;
    inputPasswordError = null;
  });

  bool get canNext {
    return inputEmail != "" && inputPassword != "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Disableable(
            isEnabled: !isLoading,
            child: HeaderConnection(
              title: "로그인",
              child: ListView(
                padding: EdgeInsets.all(Dimens.outerPadding),
                children: [
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
                  SizedBox(height: Dimens.innerPadding),

                  // 왼쪽으로 정렬 및 자연스러움을 위한 안쪽 여백 추가.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
                      child: Button(
                        type: ButtonType.underLine,
                        label: "비밀번호를 잊으셨나요?",
                        onTap: () {},
                      ),
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
              label: "로그인",
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