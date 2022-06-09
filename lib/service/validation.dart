import 'package:airauth/models/Otp.dart';

class Validation {
  /// Check if the given value is a string.
  static bool isString(dynamic str) {
    return str is String;
  }

  /// Check if the given string is a valid OTP url.
  static bool validOTPUrl(String url) {
    try {
      // FIX: This is a bad hack, but it works. Couldn't figure out Dart regex.
      Otp otp = Otp('', url);
      return true;
    } catch (e) {
      print('Invalid OTP URL: $url');
      return false;
    }
  }
}
