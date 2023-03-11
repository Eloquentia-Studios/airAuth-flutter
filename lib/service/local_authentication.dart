import 'package:airauth/service/storage.dart';
import 'package:local_auth/local_auth.dart' as local_auth;

class LocalAuthentication {
  static local_auth.LocalAuthentication? _auth;

  /// Tries to authenticate the user using biometrics or pin.
  /// Throws an [error] if something goes wrong.
  static Future<bool> authenticate(String reason) async {
    _auth ??= local_auth.LocalAuthentication();
    return await _auth?.authenticate(localizedReason: reason) ?? false;
  }

  /// Enables biometrics for the app.
  static Future<void> enableLocalAuth() async {
    await Storage.set('local_auth', 'true');
  }

  /// Disables biometrics for the app.
  static Future<void> disableLocalAuth() async {
    await Storage.set('local_auth', 'false');
  }

  /// Checks if biometrics are enabled for the app.
  static Future<bool> isLocalAuthEnabled() async {
    return await Storage.get('local_auth') == 'true';
  }
}
