import 'package:dio/dio.dart';
import '../../utils/logger.dart';

/// Interceptor to log HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.debug(
      'REQUEST[${options.method}] => PATH: ${options.path}',
      tag: 'HTTP',
    );
    Logger.debug('Headers: ${_redactHeaders(options.headers)}', tag: 'HTTP');
    Logger.debug('Query Parameters: ${options.queryParameters}', tag: 'HTTP');
    if (options.data != null) {
      Logger.debug('Body: ${options.data}', tag: 'HTTP');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.debug(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      tag: 'HTTP',
    );
    Logger.debug('Data: ${response.data}', tag: 'HTTP');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      tag: 'HTTP',
      error: err,
    );
    Logger.error('Message: ${err.message}', tag: 'HTTP');
    if (err.response != null) {
      Logger.error('Response: ${err.response?.data}', tag: 'HTTP');
    }

    handler.next(err);
  }

  /// Mask sensitive headers (e.g. the Bearer token) before logging so tokens
  /// never leak into device logs.
  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    const sensitive = {'authorization', 'cookie', 'set-cookie'};
    return headers.map((key, value) {
      if (sensitive.contains(key.toLowerCase())) {
        return MapEntry(key, '***REDACTED***');
      }
      return MapEntry(key, value);
    });
  }
}
