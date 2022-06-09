import 'dart:convert';
import 'package:airauth/service/storage.dart';
import '../models/Otp.dart';
import 'http.dart';

class Otps {
  static Future<dynamic> loadOtps() async {}

  /// Get otp items from storage.
  static Future<List<Otp>> getOpts() async {
    final otpJson = await Storage.get('otps');
    final otps = json.decode(otpJson) ?? {'otps': []};

    // Convert otp items to list.
    List<Otp> otpItems = [];
    otps['otps'].forEach((otp) {
      otpItems.add(Otp.fromJson(otp));
    });

    return otpItems;
  }

  /// Update the otps for the user.
  static Future<void> updateOpts() async {
    try {
      final otps = await _fetchRemoteOtps();
      await _saveOtps(otps);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Saves the [otps] to secure storage.
  static Future<void> _saveOtps(dynamic otps) async {
    await Storage.set('otps', json.encode(otps));
  }

  /// Fetches the otps from the remote server.
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<dynamic> _fetchRemoteOtps() async {
    // Get server address and and token from storage.
    final serverAddress = await Storage.get('serverAddress');

    // Request otps from server.
    final response = await Http.get('$serverAddress/api/v1/otp', {
      'Authorization': 'Bearer ${await Storage.get('token')}',
    });

    // Check response status.
    if (response.statusCode != 200) {
      throw Exception({
        'status': response.statusCode,
        'body': json.decode(response.body),
      });
    }

    // Parse response.
    return json.decode(response.body);
  }
}
