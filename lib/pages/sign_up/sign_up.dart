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

/// 회원가입 화면을 표시하는 페이지 위젯.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// API 통신 중 로딩 상태 여부.
  bool isLoading = false;

  /// 비밀번호를 화면에 표시할지 여부.
  bool isVisiblePassword = false;

  /// 사용자가 입력한 이름.
  String inputName = "";

  /// 사용자가 입력한 이메일.
  String inputEmail = "";

  /// 사용자가 입력한 비밀번호.
  String inputPassword = "";

  /// 이름 입력 필드의 에러 메세지.
  String? inputNameError;

  /// 이메일 입력 필드의 에러 메세지.
  String? inputEmailError;

  /// 비밀번호 입력 필드의 에러 메세지.
  String? inputPasswordError;

  /// 사용자가 입력한 이름 값을 상태에 업데이트합니다.
  void updateInputName(String newValue) => setState(() {
    inputName = newValue;
    inputNameError = null;
  });

  /// 사용자가 입력한 이메일 값을 상태에 업데이트합니다.
  void updateInputEmail(String newValue) => setState(() {
    inputEmail = newValue;
    inputEmailError = null;
  });

  /// 사용자가 입력한 비밀번호 값을 상태에 업데이트합니다.
  void updateInputPassword(String newValue) => setState(() {
    inputPassword = newValue;
    inputPasswordError = null;
  });

  /// 약관 동의 단계로 진행하고, 동의 완료 시 회원가입을 처리합니다.
  void next() async {
    // 이메일 형식이 유효하지 않을 경우 에러 메세지를 표시.
    if (!Test.isEmail(inputEmail)) {
      setState(() => inputEmailError = "유효하지 않은 이메일 형식입니다.");
      return;
    }

    // 약관 동의 바텀 시트를 표시.
    BottomSheet.open(context, _Terms(onDone: () async {
      Navigator.pop(context);

      setState(() => isLoading = true);

      try {
        // 회원가입 API 호출.
        final SignUpService signUp = SignUpService(
          username: inputName,
          email: inputEmail,
          password: inputPassword,
        )..load();

        await signUp.load();

        // 회원가입 성공 후 즉시 로그인 처리.
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

        // 로그인 완료 시, 회원가입 페이지를 닫음.
        if (mounted) Navigator.pop(context);
      } on APIError catch (error) {
        // API 에러 발생 시, 서버에서 받은 에러 메세지를 화면에 표시.
        setState(() => inputNameError = error.detail);
      }

      setState(() => isLoading = false);
    }));
  }

  /// 모든 입력 필드가 채워져 '다음' 버튼을 활성화할 수 있는지 여부.
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
                    // 이름 입력 필드.
                    InputField(
                      hintText: "이름",
                      errorText: inputNameError,
                      onChanged: updateInputName,
                    ),

                    SizedBox(height: Dimens.innerPadding),

                    // 이메일 입력 필드.
                    InputField(
                      hintText: "이메일",
                      errorText: inputEmailError,
                      onChanged: updateInputEmail,
                    ),

                    SizedBox(height: Dimens.innerPadding),

                    // 비밀번호 입력 필드.
                    InputField(
                      hintText: "비밀번호",
                      errorText: inputPasswordError,
                      onChanged: updateInputPassword,
                      obscureText: !isVisiblePassword,

                      // 비밀번호 보이기/숨기기 아이콘 버튼.
                      action: InputFieldAction(
                        iconPath: isVisiblePassword ? "eye_off".svg : "eye".svg,
                        onTap: () {
                          // 비밀번호 보이기 여부를 토글.
                          setState(() => isVisiblePassword = !isVisiblePassword);
                        },
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

              // '다음' 버튼. 약관 동의 단계로 넘어갑니다.
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

/// 약관 동의 내용을 표시하는 바텀 시트 위젯.
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
  /// 화면에 표시될 약관 목록.
  final List<TermsItem> termsItmes = [
    TermsItem(
      label: "개인 정보 처리 방침",
      link: "https://www.notion.so/257f8070678280e8975cd4c18a2f095a",
      required: true,
    ),
    TermsItem(
      label: "서비스 이용 약관",
      link: "https://www.notion.so/257f8070678280e8975cd4c18a2f095a",
      required: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // 약관 목록을 표시하고, 동의 여부를 선택할 수 있는 위젯.
        TermsList(
          onChanged: () => setState(() {}),
          items: termsItmes,
        ),
        Padding(
          padding: EdgeInsets.all(Dimens.outerPadding),
          child: Disableable(
            // 모든 필수 약관에 동의했는지 여부에 따라 버튼을 활성화.
            isEnabled: TermsItem.isRequiredItemsChecked(termsItmes),

            // '확인' 버튼. 모든 필수 약관에 동의해야 활성화됩니다.
            child: WideButton(label: "확인", onTap: widget.onDone),
          ),
        ),
      ],
    );
  }
}