// ignore_for_file: depend_on_referenced_packages, use_function_type_syntax_for_parameters

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'access_token.g.dart';

abstract class AccessToken implements Built<AccessToken, AccessTokenBuilder> {
  factory AccessToken(
      [AccessTokenBuilder updates(AccessTokenBuilder builder)]) = _$AccessToken;

  AccessToken._();

  @BuiltValueField(wireName: 'access_token')
  String? get accessToken;

  @BuiltValueField(wireName: 'refresh_token')
  String? get refreshToken;

  @BuiltValueField(wireName: 'expires_in')
  int? get expiresIn;

  @BuiltValueField(wireName: 'created_at')
  String? get createdAt;

  static Serializer<AccessToken> get serializer => _$accessTokenSerializer;
}
