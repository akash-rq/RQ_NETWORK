import 'package:dio/dio.dart';

import '../../helpers/preferences.dart';
import '../../models/access_token.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor() : super();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra.containsKey('requiresAuthToken')) {
      final AccessToken? token = await Preference.getUserAccessToken();

      if (options.extra['requiresAuthToken'] == true && token != null) {
        options.headers.addAll(
          <String, Object?>{'Authorization': 'Bearer ${token.accessToken}'},
        );
      }

      options.extra.remove('requiresAuthToken');
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data as Map<String, dynamic>;
    final headers = data['headers'] as Map<String, dynamic>;

    final bool success = headers['error'] == 0;

    if (success) {
      return handler.next(response);
    }

    return handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
      ),
    );
  }
}
