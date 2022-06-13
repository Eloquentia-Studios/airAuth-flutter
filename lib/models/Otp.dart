import 'package:otp/otp.dart';
import 'package:airauth/service/time.dart';

class Otp {
  // Define OTP values.
  late final String _id;
  late final String _url;
  late String _type;
  late String _label;
  late String _secret;
  late String _issuer;
  late int _digits;
  late int _period;
  late Algorithm _algorithm;

  Otp(this._id, this._url) {
    parseUrl();
  }

  /// Getters for OTP values.
  String getId() => _id;
  String getLabel() => _label;
  String getIssuer() => _issuer;
  int getPeriod() => _period;

  /// Parse OTP data from url.
  void parseUrl() {
    // Parse url and get query parameters.
    final uri = Uri.parse(_url);
    final query = uri.queryParameters;

    // Set OTP values from url.
    _type = uri.host;
    _label = Uri.decodeComponent(uri.path.substring(1)).trim();
    _secret = query['secret'] ?? '';
    _issuer = (query['issuer'] ?? '').trim();
    _digits = int.parse(query['digits'] ?? '6');
    _period = int.parse(query['period'] ?? '30');
    _algorithm = _stringToAlgorithm(query['algorithm'] ?? 'SHA1');

    _fixIssuerLabel();
  }

  /// Handle wrongly formatted issuer & label.
  void _fixIssuerLabel() {
    // Remove slash after label.
    if (_label.endsWith('/')) {
      _label = _label.substring(0, _label.length - 1).trim();
    }

    // No issuer, but label has colon.
    if (_issuer.isEmpty && _label.contains(':')) {
      _issuer = _label.substring(0, _label.indexOf(':')).trim();
      _label = _label.substring(_label.indexOf(':') + 1).trim();
    }

    // No issuer, but label doesn't have colon.
    if (_issuer.isEmpty && !_label.contains(':')) {
      _issuer = _label;
    }

    // Label has colon.
    if (_label.contains(':')) {
      _label = _label.substring(_label.indexOf(':') + 1).trim();
    }
  }

  /// Generate the OTP code.
  String getCode() {
    try {
      String code = OTP.generateTOTPCodeString(
        _padBase32String(_secret),
        Time.getLastPeriod(_period),
        interval: _period,
        length: _digits,
        algorithm: _algorithm,
        isGoogle: true,
      );

      return code;
    } catch (_) {
      return 'Error';
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
        return '$base32String======';
      case 4:
        return '$base32String====';
      case 5:
        return '$base32String===';
      case 7:
        return '$base32String==';
      default:
        return base32String;
    }
  }
}
