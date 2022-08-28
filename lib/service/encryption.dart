import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';
import 'package:airauth/service/key_pair.dart' as _;
import 'package:ninja/asymmetric/rsa/rsa.dart';

class Encryption {
  /// Decrypt a [cipherText] using [key] & [iv] and authenticate it using [auth].
  static Future<String> decryptSymmetrical(
      String cipherText, String key, String auth, String iv) async {
    final algorithm = AesGcm.with256bits(nonceLength: 16);
    final secretBox = _createSecretBox(cipherText, iv, auth);
    final secretKey = SecretKey(await _formatKey(key));
    final plainBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return utf8.decode(plainBytes);
  }

  /// Create a [SecretBox] from [cipherText] & [iv] and authenticate it using [auth].
  /// [cipherText] and [auth] is assummed to be hex encoded.
  static SecretBox _createSecretBox(String cipherText, String iv, String auth) {
    final cipherBytes = HEX.decode(cipherText);
    final nonce = utf8.encode(iv);
    final mac = Mac(HEX.decode(auth));
    return SecretBox(cipherBytes, nonce: nonce, mac: mac);
  }

  /// Sha256 a [string] into [List<int>].
  static Future<List<int>> _sha256(String text) async {
    final data = utf8.encode(text);
    final algo = Sha256();
    final hash = await algo.hash(data);
    return hash.bytes;
  }

  /// Format a [key] to be used in [SecretKey].
  static Future<List<int>> _formatKey(String key) async {
    final keyHash = await _sha256(key);
    final base64KeyHash = base64Encode(keyHash);
    return utf8.encode(base64KeyHash.substring(0, 32));
  }

  /// Assymetric encrypt a [plainText] using [publicKey].
  static Future<String> encryptAsymmetrical(String plainText) async {
    final publicKeyPem = await _.KeyPair.getPublicKey();
    final publicKey = RSAPublicKey.fromPEM(publicKeyPem);
    return publicKey.encryptPkcs1v15ToBase64(plainText);
  }

  /// Assymetric decrypt a [cipherText] using [privateKey].
  static Future<String> decryptAsymmetrical(String cipherText) async {
    final privateKeyPem = await _.KeyPair.getPrivateKey();
    final privateKey = RSAPrivateKey.fromPEM(privateKeyPem);
    return privateKey.decryptPkcs1v15ToUtf8(cipherText);
  }
}
