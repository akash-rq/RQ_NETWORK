import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/preferences.dart';
import '../../helpers/typedefs.dart';
import '../../models/access_token.dart';
import '../api_endpoint.dart';

class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required Dio dioClient,
  }) : _dio = dioClient;
  final Dio _dio;

  String get tokenExpiredException => 'TokenExpiredException';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      if (err.response != null) {
        if (err.response!.data != null) {
          final tokenDio = Dio()..options = _dio.options;

          final AccessToken? token = await Preference.getUserAccessToken();
          final AccessToken? newAccessToken;

          if (err.requestOptions.headers.containsKey('Authorization') == true) {
            if (err.response?.statusCode == 401) {
              final Map<String, dynamic> refreshTokenBody = <String, dynamic>{
                'customer': <String, String>{
                  'grant_type': 'refresh_token',
                  'refresh_token': token?.refreshToken ?? '',
                }
              };

              final newToken = await _refreshTokenRequest(
                dioError: err,
                handler: handler,
                tokenDio: tokenDio,
                data: refreshTokenBody,
              );

              if (newToken != null && newToken.isNotEmpty) {
                newAccessToken = json.decode(newToken) as AccessToken;

                final response = await _dio.request<JSON>(
                  err.requestOptions.path,
                  data: err.requestOptions.data,
                  cancelToken: err.requestOptions.cancelToken,
                  options: Options(
                    headers: <String, Object?>{
                      'Authorization': 'Bearer ${newAccessToken.accessToken}'
                    },
                  ),
                );

                return handler.resolve(response);
              } else {
                return super.onError(err, handler);
              }
            }
          }
        }
      }
    } catch (e) {
      return super.onError(err, handler);
    }

    return super.onError(err, handler);
  }

  Future<String?> _refreshTokenRequest({
    required DioException dioError,
    required ErrorInterceptorHandler handler,
    required Dio tokenDio,
    required JSON data,
  }) async {
    debugPrint('--> REFRESHING TOKEN');
    try {
      debugPrint('\tBody: $data');

      final Response<JSON> response = await tokenDio.post<JSON>(
        ApiEndpoint.refreshTokenUrl,
        data: data,
      );

      debugPrint('\tStatus code:${response.statusCode}');
      debugPrint('\tResponse: ${response.data}');
      final headers = response.data?['headers'] as Map<String, dynamic>?;

      final bool success = headers?['error'] == 0;
      final body = response.data?['body'] as Map<String, dynamic>?;

      if (success) {
        debugPrint('<-- END REFRESH');

        return body?['token'] as String;
      } else {
        throw Exception(headers?['message']);
      }
    } on Exception catch (ex) {
      debugPrint('\t--> ERROR');
      if (ex is DioException) {
        final DioException de = ex;
        debugPrint('\t\t--> Exception: ${de.error}');
        debugPrint('\t\t--> Message: ${de.message}');
        debugPrint('\t\t--> Response: ${de.response}');
      } else {
        debugPrint('\t\t--> Exception: $ex');
      }
      debugPrint('\t<-- END ERROR');
      debugPrint('<-- END REFRESH');

      return null;
    }
  }
}
