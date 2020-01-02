import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'verify_code.g.dart';

@JsonSerializable()
@CopyWith()
class VerifyCode extends BaseModel {
  const VerifyCode({this.verifyCode, this.verifyCodeTime, this.verifyCodeHash});

  factory VerifyCode.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyCodeToJson(this);

  final String verifyCode;
  final int verifyCodeTime;
  final String verifyCodeHash;
}
