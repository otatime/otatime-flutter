import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/api/interface/api_error.dart';
import 'package:otatime_flutter/components/shared/test.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/auth/my_user.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/pages/sign_in/sign_in_service.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/header_connection.dart';
import 'package:otatime_flutter/widgets/input_field.dart';
import 'package:otatime_flutter/widgets/wide_button.dart';

/// 사용자 로그인 페이지 위젯.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

/// [SignInPage]의 상태를 관리하는 클래스.
class _SignInPageState extends State<SignInPage> {
  /// API 요청 처리 중 로딩 상태 여부.
  bool isLoading = false;

  /// 비밀번호 난독화 끄기 여부.
  bool isVisiblePassword = false;

  /// 사용자가 입력한 이메일.
  String inputEmail = "";

  /// 사용자가 입력한 비밀번호.
  String inputPassword = "";

  /// 이메일 입력 필드에 표시될 오류 메시지.
  String? inputEmailError;

  /// 비밀번호 입력 필드에 표시될 오류 메시지.
  String? inputPasswordError;

  /// 사용자가 입력한 이메일 값으로 상태를 업데이트합니다.
  void updateInputEmail(String newValue) => setState(() {
    inputEmail = newValue;
    inputEmailError = null;
  });

  /// 사용자가 입력한 비밀번호 값으로 상태를 업데이트합니다.
  void updateInputPassword(String newValue) => setState(() {
    inputPassword = newValue;
    inputPasswordError = null;
  });

  /// 로그인 버튼을 눌렀을 때 실행되는 최종 로직.
  void done() async {
    // 이메일 형식 유효성 검사.
    if (!Test.isEmail(inputEmail)) {
      setState(() => inputEmailError = "유효하지 않은 이메일 형식입니다.");
      return;
    }

    // 로딩 상태를 활성화하여 UI 상호작용을 막음.
    setState(() => isLoading = true);

    try {
      // 로그인 서비스 API 호출.
      final SignInService signIn = SignInService(
        email: inputEmail,
        password: inputPassword,
      );

      await signIn.load();
      // API 호출 성공 시, 받은 토큰으로 사용자 로그인 처리.
      await MyUser.signIn(
        accessToken: signIn.data.accessToken,
        refreshToken: signIn.data.refreshToken,
      );

      // 해당 사용자 정보 불러오기.
      MyUser.load();

      // 로그인 성공 시, 현재 페이지를 닫습니다.
      if (mounted) Navigator.pop(context);
    } on APIError catch (error) {

      // 서버 측 에러 메세지 그대로 표시.
      setState(() => inputEmailError = error.detail);
    }

    // 모든 처리가 끝나면 로딩 상태를 비활성화합니다.
    setState(() => isLoading = false);
  }

  /// 로그인 버튼 활성화 여부.
  bool get canNext {
    return inputEmail != "" && inputPassword != "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Disableable(
              // 로딩 중에는 입력 필드를 비활성화.
              isEnabled: !isLoading,
              child: HeaderConnection(
                title: "로그인",
                child: ListView(
                  padding: EdgeInsets.all(Dimens.outerPadding),
                  children: [
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

                      // 비밀번호 가시성 토글 액션 버튼.
                      action: InputFieldAction(
                        iconPath: isVisiblePassword ? "eye_off".svg : "eye".svg,
                        onTap: () {
                          // 비밀번호 보기 여부 토글.
                          setState(() => isVisiblePassword = !isVisiblePassword);
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.innerPadding),

                    // "비밀번호를 잊으셨나요?" 버튼.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        // 왼쪽으로 정렬 및 자연스러움을 위한 안쪽 여백 추가.
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

          // 하단 로그인 버튼 영역.
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
                onTap: done,
              ),
            ),
          ),
        ],
      ),
    );
  }
}