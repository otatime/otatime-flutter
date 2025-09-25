import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otatime_flutter/components/ui/animes.dart';
import 'package:otatime_flutter/components/ui/dimens.dart';
import 'package:otatime_flutter/components/ui/scheme.dart';
import 'package:otatime_flutter/extensions/string.dart';
import 'package:otatime_flutter/extensions/uint_8_list.dart';
import 'package:otatime_flutter/widgets/button.dart';
import 'package:otatime_flutter/widgets/circular_button.dart';
import 'package:otatime_flutter/widgets/disableable.dart';
import 'package:otatime_flutter/widgets/loading_indicator.dart';
import 'package:otatime_flutter/widgets/transition.dart';

/// 해당 위젯은 사용자가 이미지를 선택하고 미리볼 수 있는 상자형 컴포넌트입니다.
class ImageSelectBox extends StatefulWidget {
  const ImageSelectBox({
    super.key,
    required this.onChanged,
  });

  /// 사용자가 이미지를 선택했을 때 호출되는 콜백.
  final ValueChanged<XFile> onChanged;

  @override
  State<ImageSelectBox> createState() => _ImageSelectBoxState();
}

class _ImageSelectBoxState extends State<ImageSelectBox> {
  /// 이미지 선택 과정의 로딩 상태.
  bool isLoading = false;

  /// 사용자가 선택한 이미지 파일.
  XFile? pickedFile;

  /// 사용자가 선택한 이미지의 바이트 데이터.
  Uint8List? pickedFileBytes;

  /// 사용자에게 갤러리를 열어 이미지 선택을 요청합니다.
  void pickImageFile() async {
    final ImagePicker picker = ImagePicker();

    setState(() => isLoading = true);
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      widget.onChanged.call(pickedFile = file);
      pickedFileBytes = await file.readAsBytes();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Disableable(
          // 로딩 중에는 상호작용을 비활성화합니다.
          isEnabled: !isLoading,
          child: AnimatedContainer(
            duration: Animes.transition.duration,
            curve: Animes.transition.curve,
            width: double.infinity,

            // 이미지 선택 여부에 따라 내부 패딩을 조절합니다.
            padding: pickedFile != null
              ? EdgeInsets.all(Dimens.innerPadding)
              : EdgeInsets.all(Dimens.innerPadding * 2),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Scheme.current.border),
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
            ),

            // 이미지 선택 여부에 따라 다른 위젯(초기 상태/미리보기)을 표시합니다.
            child: pickedFile == null
              ? idleWidget()
              : viewWidget(),
          ),
        ),

        // 로딩 중일 때 화면 중앙에 인디케이터를 표시합니다.
        Positioned.fill(
          child: Center(
            child: Transition(
              child: KeyedSubtree(
                key: ValueKey(isLoading),
                child: isLoading ? LoadingIndicator() : SizedBox(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 사용자가 이미지를 선택하기 전, 초기 상태의 위젯을 구성합니다.
  Widget idleWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.columnSpacing,
          children: [
            // 이미지 업로드를 유도하는 제목.
            Text("이미지 업로드", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // 허용되는 이미지 형식에 대한 안내 문구.
            Text("이미지 형식인 JPG, PNG 파일을 업로드하세요!", style: TextStyle(color: Scheme.current.foreground2)),
          ],
        ),

        // 이미지 선택기를 여는 버튼.
        Button(
          type: ButtonType.primary,
          label: "파일 선택",
          onTap: pickImageFile,
        ),
      ],
    );
  }

  /// 사용자가 이미지를 선택한 후, 선택된 이미지 정보를 표시하는 위젯을 구성합니다.
  Widget viewWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
        // 선택된 이미지의 썸네일.
        ClipRRect(
          borderRadius: BorderRadius.circular(1e10),
          child: Image.memory(
            pickedFileBytes!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              // 파일 이름 표시.
              Text(pickedFile!.name, style: TextStyle(fontWeight: FontWeight.bold)),

              // 파일 크기 표시.
              Text(
                pickedFileBytes!.formatAsFileSize(),
                style: TextStyle(color: Scheme.current.foreground2),
              ),
            ],
          ),
        ),

        // 이미지를 다시 선택할 수 있는 수정 버튼.
        CircularButton(
          foregroundColor: Scheme.current.foreground2,
          iconPath: "write1".svg,
          onTap: pickImageFile,
        ),
      ],
    );
  }
}