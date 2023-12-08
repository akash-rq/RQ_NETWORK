// Helpers
import '../../helpers/typedefs.dart';

class ResponseModel<T> {

  const ResponseModel({
    required this.headers,
    required this.body,
  });

  factory ResponseModel.fromJson(JSON json) {
    return ResponseModel(
      headers: ResponseHeadersModel.fromJson(
        json['headers'] as JSON,
      ),
      body: json['body'] as T,
    );
  }
  final ResponseHeadersModel headers;
  final T body;
}

class ResponseHeadersModel {

  const ResponseHeadersModel({
    required this.error,
    required this.message,
    this.code,
  });

  factory ResponseHeadersModel.fromJson(JSON json) {
    return ResponseHeadersModel(
      error: boolFromInt(json['error'] as int),
      message: json['message'] as String,
      code: json['code'] as String?,
    );
  }
  final bool error;
  final String message;
  final String? code;
  static bool boolFromInt(int i) => i == 1;
}
