import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'verify_code.dart';

class GenericConverter<T> implements JsonConverter<T, Object> {
  const GenericConverter();

  @override
  T fromJson(Object json) {
    switch (T) {
      case VerifyCode:
        return VerifyCode.fromJson(json as Map<String, dynamic>) as T;
      default:
        return json as T;
    }
  }

  @override
  toJson(T value) => json.decode(json.encode(value));
}
