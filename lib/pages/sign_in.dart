import 'package:flutter/widgets.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
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
                  InputField(hintText: "이메일"),
                  SizedBox(height: Dimens.innerPadding),
                  InputField(hintText: "비밀번호"),
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
      ],
    );
  }
}