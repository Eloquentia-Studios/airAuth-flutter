import 'dart:async';

import 'package:airauth/service/http.dart';

class ErrorData {
  final String _title;
  final String _message;

  ErrorData(this._title, this._message);

  String get title => _title;
  String get message => _message;

  static ErrorData handleException(Object e) {
    switch (e.runtimeType) {
      case TimeoutException:
        return ErrorData('Timeout',
            'The request timed out. Please check your internet connection and try again. If the problem persists, the server may be down or the server address may be incorrect.');
      case HttpException:
        return _handleHttpException(e as HttpException);
      case KnownErrorException:
        return ErrorData((e as KnownErrorException).title, e.message);
      default:
        return ErrorData('Unknown error',
            'An unknown error occurred. Please try again later.');
    }
  }

  // Handle HttpExceptions.
  static ErrorData _handleHttpException(HttpException e) {
    String title = '${e.statusCode}: ${e.getHttpMessage()}';

    // Single error.
    if (e.errors.length == 1) {
      return ErrorData(title, e.errors[0]);
    }

    return ErrorData(title, '- ${e.errors.join('\n- ')}');
  }
}

class KnownErrorException implements Exception {
  final String title;
  final String message;

  KnownErrorException(this.title, this.message);
}
