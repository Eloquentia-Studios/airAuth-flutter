import 'package:airauth/service/encryption.dart';
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

  Otp(this._id, this._url, {String? customIssuer, String? customLabel}) {
    parseUrl();
    _setCustomIssuerLabel(customIssuer, customLabel);
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
        _secret.toUpperCase(),
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
  static Future<Otp> fromJson(dynamic otpData) async {
    final url = await Encryption.decryptAsymmetrical(otpData['url']);
    final customIssuer = otpData['customIssuer'] != null
        ? await Encryption.decryptAsymmetrical(otpData['customIssuer'])
        : null;
    final customLabel = otpData['customLabel'] != null
        ? await Encryption.decryptAsymmetrical(otpData['customLabel'])
        : null;

    return Otp(otpData['id'], url,
        customIssuer: customIssuer, customLabel: customLabel);
  }

  /// Sets custom issuer and label based on the given [issuer] and [label].
  void _setCustomIssuerLabel(String? customIssuer, String? customLabel) {
    if (customIssuer != null) {
      _issuer = customIssuer;
    }

    if (customLabel != null) {
      print('Adding custom label: $customLabel');
      _label = customLabel;
    }
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
}
