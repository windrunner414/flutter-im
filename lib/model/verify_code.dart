import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'verify_code.g.dart';

@JsonSerializable()
class VerifyCode extends BaseModel {
  String verifyCode;
  int verifyCodeTime;
  String verifyCodeHash;

  VerifyCode({this.verifyCode, this.verifyCodeTime, this.verifyCodeHash});

  factory VerifyCode.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyCodeToJson(this);
}
