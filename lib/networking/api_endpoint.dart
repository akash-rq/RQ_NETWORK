import 'package:flutter/material.dart';

import '../../config/config.dart';

@immutable
class ApiEndpoint {
  const ApiEndpoint._();
  static const String baseUrl = Config.baseUrl;
  static const String refreshTokenUrl = Config.baseUrl + Config.refreshTokenUrl;
}
