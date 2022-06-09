class Otp {
  late final String id;
  late final String url;
  Otp(this.id, this.url);

  /// Create an Otp from json.
  static Otp fromJson(dynamic otpData) {
    return Otp(otpData['id'], otpData['url']);
  }
}
