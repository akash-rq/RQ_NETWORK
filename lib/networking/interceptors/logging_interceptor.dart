import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../helpers/typedefs.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final String httpMethod = options.method.toUpperCase();
    final String url = options.baseUrl + options.path;

    debugPrint('--> $httpMethod $url');

    debugPrint('\tHeaders:');
    options.headers.forEach((String k, Object? v) => debugPrint('\t\t$k: $v'));

    if (options.queryParameters.isNotEmpty) {
      debugPrint('\tqueryParams:');
      options.queryParameters
          .forEach((String k, Object? v) => debugPrint('\t\t$k: $v'));
    }

    if (options.data != null) {
      debugPrint('\tBody: ${options.data}');
    }

    debugPrint('--> END $httpMethod');

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint('<-- RESPONSE');

    debugPrint('\tStatus code: ${response.statusCode}');

    if (response.statusCode == 304) {
      debugPrint('\tSource: Cache');
    } else {
      debugPrint('\tSource: Network');
    }

    debugPrint('\tResponse: ${response.data}');

    debugPrint('<-- END HTTP');

    return super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    debugPrint('--> ERROR');
    final String httpMethod = err.requestOptions.method.toUpperCase();
    final String url = err.requestOptions.baseUrl + err.requestOptions.path;

    debugPrint('\tMETHOD: $httpMethod');
    debugPrint('\tURL: $url');
    if (err.response != null) {
      debugPrint('\tStatus code: ${err.response!.statusCode}');
      if (err.response!.data != null) {
        final JSON headers = (err.response?.data as JSON?)?['headers'] as JSON;
        final String message = headers['message'] as String;
        final String code = headers['code'] as String;
        debugPrint('\tException: $code');
        debugPrint('\tMessage: $message');
        if (headers.containsKey('data')) {
          final List<Object?> data = headers['data'] as List<Object?>;
          if (data.isNotEmpty) {
            debugPrint('\tData: $data');
          }
        }
      } else {
        debugPrint('${err.response!.data}');
      }
    } else if (err.error is SocketException) {
      const String message = 'No internet connectivity';
      debugPrint('\tException: FetchDataException');
      debugPrint('\tMessage: $message');
    } else {
      debugPrint('\tUnknown Error');
    }

    debugPrint('<-- END ERROR');

    return super.onError(err, handler);
  }
}
