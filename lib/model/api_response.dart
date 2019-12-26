import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';
import 'package:wechat/model/model_generic_json_converter.dart';

part 'api_response.g.dart';

@JsonSerializable()
@CopyWith()
class ApiResponse<T extends Object> extends BaseModel {
  final int code;
  @ModelGenericJsonConverter()
  final T result;
  final String msg;

  ApiResponse({this.code, this.result, this.msg});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
