import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  static Future<http.Response> get(
      String url, Map<String, String> headers) async {
    http.Response response = await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 10));
    return response;
  }

  static Future<http.Response> post(
      String url, Map<String, String> headers, Object body) async {
    final bodyJson = json.encode(body);
    headers['Content-Type'] = 'application/json';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: bodyJson);
    return response;
  }
}
