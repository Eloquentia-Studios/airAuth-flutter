import 'package:airauth/service/otps.dart';

import 'storage.dart';

class Authentication {
  /// Get server address from storage.
  static Future<String> getServerAddress() async {
    return await Storage.get('serverAddress');
  }

  /// Sign out from the current user.
  static Future<void> signOut() async {
    // Clear otps from storage.
    await Otps.clear();

    // Clear token from storage.
    await Storage.delete('token');
  }
}
