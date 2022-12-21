import 'dart:convert';
import 'dart:typed_data';

import 'package:airauth/models/protobufs/google_auth.pb.dart';
import 'package:airauth/service/error_data.dart';
import 'package:airauth/service/otps.dart';
import 'package:base32/base32.dart';

class GoogleAuthMigration {
  /// Parse the Google Authenticator migration [url]
  /// and return the OTP urls.
  /// Throws an error if the url is not a valid Google Authenticator migration url.
  static List<String> parseMigrationUrl(String url) {
    final payload = _getPayloadFromUrl(url);
    return _getOtpsUrlsFromPayload(payload);
  }

  /// Get the payload from the migration url.
  /// [url] The migration url.
  /// Throws an error if the url is invalid.
  static MigrationPayload _getPayloadFromUrl(String url) {
    // Parse google auth migration data.
    final data = _getDataParam(url);
    final buffer = base64Decode(data);
    return MigrationPayload.fromBuffer(buffer);
  }

  /// Get the data param from the migration [url].
  /// Throws an error if there is no data param.
  static String _getDataParam(String url) {
    // Parse the url.
    final uri = Uri.parse(url);

    // Get & check the query parameters.
    final queryParameters = uri.queryParameters;
    final dataParam = queryParameters['data'];
    if (dataParam == null) {
      throw KnownErrorException('Invalid migration data',
          'The scanned GAuth QR code was malformed. Please try again.');
    }

    return dataParam;
  }

  /// Get the otps urls from the [payload].
  /// Throws an error if any of the otps are invalid.
  static List<String> _getOtpsUrlsFromPayload(MigrationPayload payload) {
    final List<String> otps = [];
    for (MigrationPayload_OtpParameters migrationOtp in payload.otpParameters) {
      final secret = base32.encode(Uint8List.fromList(migrationOtp.secret));
      final url = Otps.generateOtpUrl(
        migrationOtp.issuer,
        migrationOtp.name,
        secret,
      );

      otps.add(url);
    }

    return otps;
  }
}
