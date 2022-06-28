import 'dart:convert';
import 'package:airauth/service/authentication.dart';
import 'package:airauth/service/storage.dart';
import '../models/otp.dart';
import 'http.dart';

class Otps {
  /// Get otp items from storage.
  static Future<List<Otp>> getOtps() async {
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
  static Future<void> updateOtps() async {
    final otps = await _fetchRemoteOtps();
    await _saveOtps(otps);
  }

  /// Saves the [otps] to secure storage.
  static Future<void> _saveOtps(dynamic otps) async {
    await Storage.set('otps', json.encode(otps));
  }

  /// Clear all otps from storage.
  static Future<void> clear() async {
    await Storage.delete('otps');
  }

  /// Fetches the otps from the remote server.
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<dynamic> _fetchRemoteOtps() async {
    // Get server address and and token from storage.
    final serverAddress = await Storage.get('serverAddress');

    // Request otps from server.
    final response = await Http.get(
      '$serverAddress/api/v1/otp',
      {
        'Authorization': 'Bearer ${await Authentication.getToken()}',
      },
    );

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

  /// Add an otp to the server.
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<void> addOtp(String otpUrl) async {
    // Get server address and and token from storage.
    final serverAddress = await Storage.get('serverAddress');

    // Request otps from server.
    final response = await Http.post(
      '$serverAddress/api/v1/otp',
      {
        'Authorization': 'Bearer ${await Authentication.getToken()}',
      },
      {"otpurl": otpUrl},
    );

    // Check response status.
    if (response.statusCode != 200) {
      throw Exception({
        'status': response.statusCode,
        'body': response.body,
      });
    }
  }

  /// Update an otp on the server.
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<void> updateOtp(
      String otpId, String? customIssuer, String? customLabel) async {
    // Get server address and and token from storage.
    final serverAddress = await Storage.get('serverAddress');

    // Update otp on the server.
    final response = await Http.post('$serverAddress/api/v1/otp/$otpId', {
      'Authorization': 'Bearer ${await Authentication.getToken()}',
    }, {
      "issuer": customIssuer,
      "label": customLabel,
    });

    if (response.statusCode != 200) {
      throw Exception({
        'status': response.statusCode,
        'body': response.body,
      });
    }
  }

  /// Delete an otp from the server.
  /// Throws an [error] if the request returns a status code other than 200.
  static Future<void> deleteOtp(String id) async {
    // Get server address.
    final serverAddress = await Authentication.getServerAddress();

    // Request otps from server.
    final response = await Http.delete('$serverAddress/api/v1/otp/$id', {
      'Authorization': 'Bearer ${await Authentication.getToken()}',
    }, {});

    // Check response status.
    if (response.statusCode != 200) {
      throw Exception({
        'status': response.statusCode,
        'body': response.body,
      });
    }
  }

  /// Format an OTP code for display.
  /// [code] is the OTP code.
  static String formatOtp(String code) {
    final codeLength = code.length;
    switch (codeLength) {
      case 6:
      case 9:
        return code.replaceAllMapped(
            RegExp(r'(.{3})'), (match) => '${match[0]} ');
      case 8:
        return code.replaceAllMapped(
            RegExp(r'(.{4})'), (match) => '${match[0]} ');
      case 10:
        return code.replaceAllMapped(
            RegExp(r'(.{5})'), (match) => '${match[0]} ');
      default:
        return code;
    }
  }

  /// Generate an OTP url from [issuer], [label] and [secret].
  static String generateOtpUrl(String issuer, String label, String secret) {
    issuer = Uri.encodeComponent(issuer);
    label = Uri.encodeComponent(label);
    secret = Uri.encodeComponent(secret);
    return 'otpauth://totp/$label?secret=$secret&issuer=$issuer';
  }
}
