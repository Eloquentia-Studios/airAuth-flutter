import 'package:airauth/service/encryption.dart';
import 'package:airauth/service/storage.dart';

class KeyPair {
  /// Set key pair to storage.
  static Future<void> setKeyPair(String publicKey, String privateKey) async {
    await Storage.set('publicKey', publicKey);
    await Storage.set('privateKey', privateKey);
  }

  /// Decrypt private key and store key pair in storage.
  static Future<void> decryptAndSetKeyPair(
      String publicKey, String cipherPrivateKey, String key, String iv) async {
    final cipherText = cipherPrivateKey.toString().split(' auth ')[0];
    final auth = cipherPrivateKey.toString().split(' auth ')[1];
    final privateKey =
        await Encryption.decryptSymmetrical(cipherText, key, auth, iv);
    await KeyPair.setKeyPair(publicKey, privateKey);
  }

  /// Get public key from storage.
  static Future<String> getPublicKey() async {
    return await Storage.get('publicKey');
  }

  /// Get private key from storage.
  static Future<String> getPrivateKey() async {
    return await Storage.get('privateKey');
  }
}
