import 'package:airauth/models/otp.dart';
import 'package:flutter/material.dart';
import '../components/otp_item.dart';
import '../service/otps.dart';
import '../service/validation.dart';

class OtpProvider extends ChangeNotifier {
  /// Internal storage of otp items.
  final List<OtpItem> _otpItems = [];

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
    return [..._otpItems];
  }

  // Gets the OTPs from local storage and adds them to the list.
  Future<void> getLocalOtpItems() async {
    final otps = await Otps.getOtps();
    addAll(otps);
  }

  /// Update the otp items from the server.
  /// Throws an error if the otps could not be fetched from the server.
  Future<void> updateFromServer() async {
    await Otps.updateOtps();
    final updatedOtps = await Otps.getOtps();
    clear();
    addAll(updatedOtps);
  }

  /// Add a new otp to the server.
  /// Throws an error if the otp could not be added to the server.
  Future<void> addToServer(String issuer, String label, String secret) async {
    String otpUrl = Otps.generateOtpUrl(issuer, label, secret);
    await addUrlToServer(otpUrl);
  }

  /// Add a new otp url to the server.
  /// Throws an error if the otp could not be added to the server, or if the otp is invalid.
  Future<void> addUrlToServer(String otpUrl) async {
    if (!Validation.validOTPUrl(otpUrl)) throw Exception('Invalid OTP URL.');
    await Otps.addOtp(otpUrl);
    await updateFromServer();
  }

  /// Update the [customIssuer] and/or [customLabel] of an otp with the given [otpId].
  /// Throws an error if the otp could not be updated on the server.
  Future<void> updateOnServer(String otpId,
      {String? customIssuer, String? customLabel}) async {
    await Otps.updateOtp(otpId, customIssuer, customLabel);
    await updateFromServer();
  }

  /// Delete an otp from the server.
  /// Throws an error if the otp could not be deleted from the server.
  Future<void> deleteFromServer(String otp) async {
    await Otps.deleteOtp(otp);
    await updateFromServer();
  }
}
