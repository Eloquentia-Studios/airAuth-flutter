import 'dart:convert';
import 'package:airauth/models/protobufs/google_auth.pb.dart' as $pb;
import 'package:airauth/models/protobufs/google_auth.pbenum.dart' as $pbenum;

class GoogleAuthMigration {
  void ParseData(String url) {
    // Parse google auth url.
    /*final buffer = base64Decode(url);
    final payload = $pb.MigrationPayload.fromBuffer(buffer);
    for ($pb.MigrationPayload_OtpParameters otp in payload.otpParameters) {
      print(otp.name);
    }*/
  }
}
