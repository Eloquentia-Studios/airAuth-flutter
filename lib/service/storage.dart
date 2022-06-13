import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final storage = FlutterSecureStorage();

  static Future<String> get(String key) async {
    final value = await storage.read(key: key);
    if (value == null) throw Exception('Key $key not found');
    return value;
  }

  static Future<void> set(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  /// Delete the value for the given [key].
  static Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
}
