import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureBinding {
  static late final FlutterSecureStorage storage;

  static Future<void> initializeAll() async {
    storage = FlutterSecureStorage();
  }
}