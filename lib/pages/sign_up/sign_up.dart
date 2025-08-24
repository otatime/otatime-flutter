import 'package:flutter/widgets.dart';
import 'package:flutter_scroll_bottom_sheet/flutter_bottom_sheet.dart';
import 'package:otatime_flutter/components/api/interface/api_error.dart';
import 'package:otatime_flutter/components/auth/my_user.dart';
import 'package:otatime_flutter/components/shared/test.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in_service.dart';
import 'package:otatime_flutter/pages/sign_up/sign_up_service.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/terms_list.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  void next() async {
    if (!Test.isEmail(inputEmail)) {
      setState(() => inputEmailError = "유효하지 않은 이메일 형식입니다.");
      return;
    }

    BottomSheet.open(context, _Terms(onDone: () async {
      Navigator.pop(context);

      setState(() => isLoading = true);

      try {
        final SignUpService signUp = SignUpService(
          username: inputName,
          email: inputEmail,
          password: inputPassword,
        )..load();

        await signUp.load();

        final SignInService signIn = SignInService(
          email: inputEmail,
          password: inputPassword,
        );

        await signIn.load();
        await MyUser.signIn(
          accessToken: signIn.data.accessToken,
          refreshToken: signIn.data.refreshToken,
        );

        MyUser.load();

        // 로그인 완료 시, 페이지 나가기.
        if (mounted) Navigator.pop(context);
      } on APIError catch (error) {

        // 서버 측 에러 메세지 그대로 표시.
        setState(() => inputNameError = error.detail);
      }

      setState(() => isLoading = false);
    }));
  }

  bool get canNext {
    return inputName != "" && inputEmail != "" && inputPassword != "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
                onTap: next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Terms extends StatefulWidget {
  const _Terms({
    super.key,
    required this.onDone,
  });

  /// 필수 약관을 모두 선택하고 확인 버튼을 눌렀을 때 호출됩니다.
  final VoidCallback onDone;

  @override
  State<_Terms> createState() => __TermsState();
}

class __TermsState extends State<_Terms> {
  final List<TermsItem> termsItmes = [
    TermsItem(
      label: "개인 정보 처리 방침",
      link: "https://www.notion.so/257f8070678280e8975cd4c18a2f095a",
      required: true
    ),
    TermsItem(
      label: "서비스 이용 약관",
      link: "https://www.notion.so/257f8070678280e8975cd4c18a2f095a",
      required: true
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        TermsList(
          onChanged: () => setState(() {}),
          items: termsItmes,
        ),
        Padding(
          padding: EdgeInsets.all(Dimens.outerPadding),
          child: Disableable(
            isEnabled: TermsItem.isRequiredItemsChecked(termsItmes),
            child: WideButton(label: "확인", onTap: widget.onDone),
          ),
        ),
      ],
    );
  }
}