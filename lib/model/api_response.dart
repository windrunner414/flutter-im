import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';
import 'package:wechat/model/model_generic_json_converter.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse<T extends Object> extends BaseModel {
  int code;
  @ModelGenericJsonConverter()
  T result;
  String msg;

  ApiResponse({this.code, this.result, this.msg});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
