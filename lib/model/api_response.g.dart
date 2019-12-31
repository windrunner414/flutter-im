// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ApiResponseCopyWithExtension<T> on ApiResponse<T> {
  ApiResponse copyWith({
    int code,
    String msg,
    T result,
  }) {
    return ApiResponse(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      result: result ?? this.result,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(Map<String, dynamic> json) {
  return ApiResponse<T>(
    code: json['code'] as int,
    result: ModelGenericJsonConverter<T>().fromJson(json['result']),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ApiResponseToJson<T>(ApiResponse<T> instance) =>
    <String, dynamic>{
      'code': instance.code,
      'result': ModelGenericJsonConverter<T>().toJson(instance.result),
      'msg': instance.msg,
    };
