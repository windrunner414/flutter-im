// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_generic_json_converter.dart';

// **************************************************************************
// GenericJsonConverterGenerator
// **************************************************************************

abstract class _$ModelGenericJsonConverterMixin<T extends Object> {
  T fromJson(Object json) {
    switch (T) {
      case VerifyCode:
        return VerifyCode.fromJson(json as Map<String, dynamic>) as T;
      case User:
        return User.fromJson(json as Map<String, dynamic>) as T;
      default:
        return json as T;
    }
  }

  toJson(T value) {
    switch (T) {
      case VerifyCode:
        return (value as VerifyCode).toJson();
      case User:
        return (value as User).toJson();
      default:
        return value;
    }
  }
}
