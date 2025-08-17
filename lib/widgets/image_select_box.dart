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

class ImageSelectBox extends StatefulWidget {
  const ImageSelectBox({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<XFile> onChanged;

  @override
  State<ImageSelectBox> createState() => _ImageSelectBoxState();
}

class _ImageSelectBoxState extends State<ImageSelectBox> {
  bool isLoading = false;

  /// 현재 사용자가 선택한 이미지 파일을 정의합니다.
  XFile? pickedFile;

  /// 현재 사용자가 선택한 이미지의 바이트 수준을 정의합니다.
  Uint8List? pickedFileBytes;

  /// 사용자에게 이미지 선택을 요청합니다.
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
          isEnabled: !isLoading,
          child: AnimatedContainer(
            duration: Animes.transition.duration,
            curve: Animes.transition.curve,
            width: double.infinity,
            padding: pickedFile != null
              ? EdgeInsets.all(Dimens.innerPadding)
              : EdgeInsets.all(Dimens.innerPadding * 2),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Scheme.current.border),
              borderRadius: BorderRadius.circular(Dimens.borderRadius),
            ),
            child: pickedFile == null
              ? idleWidget()
              : viewWidget(),
          ),
        ),

        // 로딩 할 때마다 인디케이터 표시.
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

  Widget idleWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.columnSpacing,
          children: [
            Text("이미지 업로드", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("이미지 형식인 JPG, PNG 파일을 업로드하세요!", style: TextStyle(color: Scheme.current.foreground2)),
          ],
        ),
        Button(
          type: ButtonType.primary,
          label: "파일 선택",
          onTap: pickImageFile,
        ),
      ],
    );
  }

  Widget viewWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.innerPadding,
      children: [
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

        CircularButton(
          foregroundColor: Scheme.current.foreground2,
          iconPath: "write1".svg,
          onTap: pickImageFile,
        ),
      ],
    );
  }
}