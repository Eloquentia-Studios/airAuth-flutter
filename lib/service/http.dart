import 'dart:convert';

import 'package:http/http.dart' as http;

class Http {
  /// Send GET request to [url] with [headers].
  static Future<http.Response> get(
      String url, Map<String, String> headers) async {
    http.Response response = await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 10));

    _handleBadResponse(response);
    return response;
  }

  /// Send POST request to [url] with [headers] and [body].
  static Future<http.Response> post(
      String url, Map<String, String> headers, Object body) async {
    final bodyJson = json.encode(body);
    headers['Content-Type'] = 'application/json';
    http.Response response = await http
        .post(Uri.parse(url), headers: headers, body: bodyJson)
        .timeout(const Duration(seconds: 10));

    _handleBadResponse(response);
    return response;
  }

  /// Send PUT request to [url] with [headers] and [body].
  static Future<http.Response> delete(
      String url, Map<String, String> headers, Object body) async {
    final bodyJson = json.encode(body);
    headers['Content-Type'] = 'application/json';
    http.Response response = await http
        .delete(Uri.parse(url), headers: headers, body: bodyJson)
        .timeout(const Duration(seconds: 10));

    _handleBadResponse(response);
    return response;
  }

  /// Throw an [HttpException] if the [response] status code is not 200, 201 or 202.
  static _handleBadResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode > 202) {
      throw HttpException(response);
    }
  }
}

class HttpException implements Exception {
  late int _statusCode;
  late List<String> _errors;

  HttpException(http.Response response) {
    // Set status code.
    _statusCode = response.statusCode;

    // Get errors from response.
    _errors = _getErrorMessagesFromResponse(response);
  }

  int get statusCode => _statusCode;
  List<String> get errors => _errors;

  // Get error message from response.
  static List<String> _getErrorMessagesFromResponse(http.Response response) {
    try {
      final body = json.decode(response.body);
      if (body['errors'] != null) {
        List<String> errors = [];
        for (var error in body['errors']) {
          errors.add(error);
        }
        return errors;
      }
      return ["Unknown error occurred"];
    } catch (_) {
      return ["Unknown error occurred"];
    }
  }

  // Get HTTP message from status code.
  String getHttpMessage() {
    switch (_statusCode) {
      case 400:
        return "Bad request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Forbidden";
      case 404:
        return "Not found";
      case 405:
        return "Method not allowed";
      case 408:
        return "Request timeout";
      case 409:
        return "Conflict";
      case 500:
        return "Internal server error";
      case 501:
        return "Not implemented";
      case 502:
        return "Bad gateway";
      case 503:
        return "Service unavailable";
      case 504:
        return "Gateway timeout";
      default:
        return "Unknown error occurred";
    }
  }
}
