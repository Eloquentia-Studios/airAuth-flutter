import 'package:flutter/material.dart';
import '../service/popup.dart';

class EditOtp {
  late final Widget _form;
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  late final Function(String, String) _callback;

  /// Constructor.
  EditOtp._(String issuer, String label, Function(String, String) onClose) {
    // Set callback.
    _callback = onClose;

    // Set controllers.
    _issuerController.text = issuer;
    _labelController.text = label;

    // Create form widget.
    _form = Form(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
                decoration: const InputDecoration(
                  labelText: 'Issuer',
                  hintText: 'e.g. Google',
                ),
                controller: _issuerController,
                autofocus: true),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Account', hintText: 'name@example.com'),
              controller: _labelController,
            ),
          ],
        ),
      ),
    );
  }

  /// Show the form. OnClose function will use the values in this order: [_issuer], [_label].
  static void showForm(BuildContext context, String issuer, String label,
      Function(String, String) onClose) {
    final eo = EditOtp._(issuer, label, onClose);
    Popup.simpleDialog('Edit OTP', eo._form, context,
        onClose: eo._formCallback);
  }

  /// Callback for the form.
  void _formCallback() {
    final issuer = _issuerController.text;
    final label = _labelController.text;
    _callback(issuer, label);
  }
}
