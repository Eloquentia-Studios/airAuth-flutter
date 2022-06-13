import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  /// Send GET request to [url] with [headers].
  static Future<http.Response> get(
      String url, Map<String, String> headers) async {
    http.Response response = await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 10));
    return response;
  }

  /// Send POST request to [url] with [headers] and [body].
  static Future<http.Response> post(
      String url, Map<String, String> headers, Object body) async {
    final bodyJson = json.encode(body);
    headers['Content-Type'] = 'application/json';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: bodyJson);
    return response;
  }

  /// Send PUT request to [url] with [headers] and [body].
  static Future<http.Response> delete(
      String url, Map<String, String> headers, Object body) async {
    final bodyJson = json.encode(body);
    headers['Content-Type'] = 'application/json';
    http.Response response =
        await http.delete(Uri.parse(url), headers: headers, body: bodyJson);
    return response;
  }
}
