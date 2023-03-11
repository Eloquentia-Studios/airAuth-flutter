import 'dart:convert';

import 'package:airauth/service/http.dart';
import 'package:airauth/service/key_pair.dart';
import 'package:airauth/service/local_authentication.dart';
import 'package:airauth/service/otps.dart';
import 'package:airauth/service/storage.dart';

class Authentication {
  /// Get server address from storage.
  static Future<String> getServerAddress() async {
    return await Storage.get('serverAddress');
  }

  /// Set server address to storage.
  static Future<void> _setServerAddress(String serverAddress) async {
    await Storage.set('serverAddress', serverAddress);
  }

  /// Get token from storage.
  static Future<String> getToken() async {
    return await Storage.get('token');
  }

  /// Set [token] to storage.
  static Future<void> _setToken(String token) async {
    await Storage.set('token', token);
  }

  /// Check if user is signed in.
  static Future<bool> isLoggedIn() async {
    try {
      await Storage.get('token');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Sign out from the current user.
  static Future<void> signOut() async {
    // Clear otps from storage.
    await Otps.clear();

    // Clear token from storage.
    await Storage.delete('token');

    // Disable local auth.
    await LocalAuthentication.disableLocalAuth();
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

    // Set server address to storage.
    await _setServerAddress(serverAddress);
  }

  /// Sign in at [serverAddress] with the given [identifier] and [password].
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<void> signIn(
      String serverAddress, String identifier, String password) async {
    // Send sign in request to server.
    final response = await Http.post(
      '$serverAddress/api/v1/user/login',
      {},
      {
        'identifier': identifier,
        'password': password,
      },
    );

    // Parse response.
    final body = json.decode(response.body);
    if (body['token'] != null &&
        body['iv'] != null &&
        body['keyPair'] != null &&
        body['keyPair']['privateKey'] != null &&
        body['keyPair']['publicKey'] != null) {
      // Save token to storage.
      await _setToken(body['token']);

      // Decrypt private key and store key pair in storage.
      await KeyPair.decryptAndSetKeyPair(body['keyPair']['publicKey'],
          body['keyPair']['privateKey'], password, body['iv']);

      // Update server address in storage.
      await _setServerAddress(serverAddress);
    }
  }

  /// Send a request to the server to refresh the token.
  static Future<void> refreshToken() async {
    // Send request to server.
    final serverAddress = await getServerAddress();
    final response =
        await Http.get('$serverAddress/api/v1/user/refresh-token', {
      'Authorization': 'Bearer ${await Authentication.getToken()}',
    });

    // Parse response and save token to storage.
    final body = json.decode(response.body);
    if (body['token'] != null) {
      await _setToken(body['token']);
    }
  }
}
