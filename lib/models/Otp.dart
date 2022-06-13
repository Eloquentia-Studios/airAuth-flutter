import 'package:base32/base32.dart';
import 'package:base32/encodings.dart';
import 'package:base32/encodings.dart';
import 'package:otp/otp.dart';
import '../service/time.dart';

class Otp {
  late final String id;
  late final String url;
  late String type;
  late String label;
  late String secret;
  late String issuer;
  late int digits;
  late int period;
  late Algorithm algorithm;

  Otp(this.id, this.url) {
    parseUrl();
  }

  /// Parse OTP data from url.
  void parseUrl() {
    final uri = Uri.parse(url);
    final query = uri.queryParameters;

    type = uri.host;
    label = Uri.decodeComponent(uri.path.substring(1)).trim();
    secret = query['secret'] ?? '';
    issuer = (query['issuer'] ?? '').trim();
    digits = int.parse(query['digits'] ?? '6');
    period = int.parse(query['period'] ?? '30');
    algorithm = _stringToAlgorithm(query['algorithm'] ?? 'SHA1');

    // Remove slash after label.
    if (label.endsWith('/')) {
      label = label.substring(0, label.length - 1).trim();
    }

    // No issuer, but label has colon.
    if (issuer.isEmpty && label.contains(':')) {
      issuer = label.substring(0, label.indexOf(':')).trim();
      label = label.substring(label.indexOf(':') + 1).trim();
    }

    // No issuer, but label doesn't have colon.
    if (issuer.isEmpty && !label.contains(':')) {
      issuer = label;
    }

    // Label has colon.
    if (label.contains(':')) {
      label = label.substring(label.indexOf(':') + 1).trim();
    }
  }

  String getCode() {
    try {
      String code = OTP.generateTOTPCodeString(
        _padBase32String(secret),
        Time.getLastPeriod(period),
        interval: period,
        length: digits,
        algorithm: algorithm,
        isGoogle: true,
      );

      return code;
    } catch (e) {
      return '';
    }
  }

  /// Create an Otp from json.
  static Otp fromJson(dynamic otpData) {
    return Otp(otpData['id'], otpData['url']);
  }

  /// Convert algorithm string to enum.
  static Algorithm _stringToAlgorithm(String algorithm) {
    switch (algorithm.trim().toUpperCase()) {
      case 'SHA256':
        return Algorithm.SHA256;
      case 'SHA512':
        return Algorithm.SHA512;
      default:
        return Algorithm.SHA1;
    }
  }

  /// Pad a base32 string to a multiple of 8 characters.
  static String _padBase32String(String base32String) {
    final base32StringLength = base32String.length;
    switch (base32StringLength % 8) {
      case 2:
        return base32String + '======';
      case 4:
        return base32String + '====';
      case 5:
        return base32String + '===';
      case 7:
        return base32String + '==';
      default:
        return base32String;
    }
  }
}
