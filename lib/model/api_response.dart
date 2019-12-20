import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse<T extends Object> {
  int code;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  T result;
  String msg;

  ApiResponse({this.code, this.result, this.msg});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

T _fromJson<T extends Object>(Map<String, dynamic> json) {
  return json as T;
}

T _toJson<T extends Object>(T value) => value;
