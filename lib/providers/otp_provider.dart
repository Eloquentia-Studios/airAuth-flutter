import 'dart:collection';
import 'package:airauth/models/Otp.dart';
import 'package:flutter/material.dart';
import '../components/OtpItem.dart';

class OtpProvider extends ChangeNotifier {
  /// Internal storage of otp items.
  final List<OtpItem> _otpItems = [];

  UnmodifiableListView<OtpItem> get otpItems => UnmodifiableListView(_otpItems);

  /// Add an otp to the list.
  /// [otp] is the otp to add.
  void add(Otp otp) {
    _add(otp);
    notifyListeners();
  }

  /// Add an otp to the list.
  /// [otp] The otp to add.
  void _add(Otp otp) {
    _otpItems.add(OtpItem(otp));
  }

  /// Add multiple otps to the list.
  /// [otps] The otps to add.
  void addAll(List<Otp> otps) {
    otps.forEach(add);
    notifyListeners();
  }

  /// Remove all otps from the list.
  void clear() {
    _otpItems.clear();
    notifyListeners();
  }

  /// Get a copy of the otp items.
  List<OtpItem> getOtpItems() {
    print(_otpItems.length);
    return [..._otpItems];
  }
}
