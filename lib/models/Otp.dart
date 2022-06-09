class Otp {
  late final String id;
  late final String url;
  late String type;
  late String label;
  late String secret;
  late String issuer;
  late int digits;
  late int period;
  late String algorithm;

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
    algorithm = query['algorithm'] ?? 'SHA1';

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

  /// Create an Otp from json.
  static Otp fromJson(dynamic otpData) {
    return Otp(otpData['id'], otpData['url']);
  }
}
