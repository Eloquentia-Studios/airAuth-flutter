import 'package:airauth/service/local_authentication.dart';
import 'package:flutter/material.dart';

class SwitchSetting extends StatefulWidget {
  const SwitchSetting({Key? key}) : super(key: key);

  @override
  State<SwitchSetting> createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  bool _biometricsEnabled = false;

  /// Toggles biometrics on or off.
  Future<void> toggleBiometrics(bool newState) async {
    final reason =
        'Authenticate to ${newState ? 'enable' : 'disable'} biometrics.';
    bool authenticated = await LocalAuthentication.authenticate(reason);
    if (!mounted) return;

    if (authenticated) {
      if (newState) {
        await LocalAuthentication.enableLocalAuth();
      } else {
        await LocalAuthentication.disableLocalAuth();
      }

      setState(() {
        _biometricsEnabled = newState;
      });
    }
  }

  /// Loads the current status of biometrics.
  Future<void> loadStatus() async {
    bool enabled = await LocalAuthentication.isLocalAuthEnabled();
    if (!mounted) return;

    setState(() {
      _biometricsEnabled = enabled;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: SwitchListTile(
        title: const Text('Enable Biometrics'),
        subtitle: const Text('Use biometric authentication to unlock app.'),
        value: _biometricsEnabled,
        onChanged: (bool value) {
          toggleBiometrics(value);
        },
      ),
    );
  }
}
