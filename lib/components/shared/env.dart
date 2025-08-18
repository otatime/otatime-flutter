import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get(String key) {
    return dotenv.get(key);
  }

  static Future<void> initializeAll() async {
    await dotenv.load(fileName: ".env");
  }
}