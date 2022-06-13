import 'dart:convert';

import 'package:airauth/service/otps.dart';
import 'http.dart';
import 'storage.dart';

class Authentication {
  /// Get server address from storage.
  static Future<String> getServerAddress() async {
    return await Storage.get('serverAddress');
  }

  /// Set server address to storage.
  static Future<void> setServerAddress(String serverAddress) async {
    await Storage.set('serverAddress', serverAddress);
  }

  /// Sign out from the current user.
  static Future<void> signOut() async {
    // Clear otps from storage.
    await Otps.clear();

    // Clear token from storage.
    await Storage.delete('token');
  }

  /// Sign up at [serverAddress] with the given [username], [email], [phoneNumber] and [password].
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<void> signUp(String serverAddress, String username,
      String email, String? phoneNumber, String password) async {
    // Send sign up request to server.
    final response = await Http.post(
      '$serverAddress/api/v1/user',
      {},
      {
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      },
    );

    // Check response status.
    if (response.statusCode != 200) {
      throw Exception({
        'status': response.statusCode,
        'body': response.body,
      });
    }

    // Set server address to storage.
    await setServerAddress(serverAddress);
  }
}
