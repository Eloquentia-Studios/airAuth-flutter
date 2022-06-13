class Validation {
  // Define regex for validation.
  static final _alphanumeric = RegExp(r'^\w+$');
  static final _email = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final _phoneNumber = RegExp(
      r'(((\+)\b[1-9]{1,2}[-.]?)|(([^1-9]{2})[1-9]{1,2}[-.]?))?\d{3}[-.]?\d{3}[-.]?\d{4}(\s(#|x|ext|extension|e)?[-.:](\d{0,5}))?');
  static final _password = RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)');
  static final _otpUrl =
      RegExp(r'^otpauth:\/\/(totp)(\/(([^:?]+)(:([^:?]*))?))?\?(.+)$');

  /// Check if the given value is a string.
  static bool isString(dynamic str) {
    return str is String;
  }

  /// Check if two strings are equal.
  static bool isEqual(String? str1, String? str2) {
    if (str1 == null && str2 == null) return true;
    if (str1 == null || str2 == null) return false;
    return str1 == str2;
  }

  /// Check if the given string is a valid OTP url.
  static bool validOTPUrl(String url) {
    if (_otpUrl.hasMatch(url)) {
      return true;
    } else {
      return false;
    }
  }

  /// Check if the given string is a valid username.
  static String? isValidUsername(String? username) {
    if (username == null) return 'Username is required';

    if (username.length < 3) {
      return 'Username must be at least 3 characters long.';
    }

    if (username.length > 40) {
      return 'Username must be less than 40 characters long.';
    }

    if (!_alphanumeric.hasMatch(username)) {
      return 'Username must be alphanumeric.';
    }

    return null;
  }

  /// Check if the given string is a valid email.
  static String? isValidEmail(String? email) {
    if (email == null) return 'Email is required';
    if (!_email.hasMatch(email)) return 'Email is not valid.';
    return null;
  }

  /// Check if the given string is a valid phone number.
  static String? isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) return null;
    if (!_phoneNumber.hasMatch(phoneNumber)) {
      return 'Phone number is not valid.';
    }

    return null;
  }

  /// Check if the given string is a valid password.
  static String? isValidPassword(String? password) {
    if (password == null) return 'Password is required';
    if (password.length < 10) {
      return 'Password must be at least 10 characters long.';
    }
    if (!_password.hasMatch(password)) {
      return 'At least one uppercase, lowercase, number & special character.';
    }

    return null;
  }

  /// Check if the given string is a valid server url.
  static String? isValidServerUrl(String? url) {
    if (url == null) return 'Server url is not valid.';
    if (url.isEmpty) return 'Server URL is required.';
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'Server URL must start with http:// or https://.';
    }

    // Try parsing the url.
    try {
      Uri uri = Uri.parse(url);
      if (uri.host.isEmpty) return 'Server URL must contain a host.';
    } catch (e) {
      return 'Server URL is not valid.';
    }

    return null;
  }
}
