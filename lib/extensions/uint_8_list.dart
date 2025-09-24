import 'dart:typed_data';

/// [Uint8List] 클래스에 대한 확장 메서드를 정의합니다.
extension Uint8ListExtension on Uint8List {
  /// 해당 바이트 형식에 대한 파일 크기로 포맷팅하여 이를 반환합니다.
  String formatAsFileSize() {
    double bytes = length.toDouble();

    if (bytes < 1024) {
       return '${bytes.toInt()} B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}