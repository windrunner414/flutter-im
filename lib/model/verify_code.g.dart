// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_code.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension VerifyCodeCopyWithExtension on VerifyCode {
  VerifyCode copyWith({
    String verifyCode,
    String verifyCodeHash,
    int verifyCodeTime,
  }) {
    return VerifyCode(
      verifyCode: verifyCode ?? this.verifyCode,
      verifyCodeHash: verifyCodeHash ?? this.verifyCodeHash,
      verifyCodeTime: verifyCodeTime ?? this.verifyCodeTime,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyCode _$VerifyCodeFromJson(Map<String, dynamic> json) {
  return VerifyCode(
    verifyCode: json['verifyCode'] as String,
    verifyCodeTime: json['verifyCodeTime'] as int,
    verifyCodeHash: json['verifyCodeHash'] as String,
  );
}

Map<String, dynamic> _$VerifyCodeToJson(VerifyCode instance) =>
    <String, dynamic>{
      'verifyCode': instance.verifyCode,
      'verifyCodeTime': instance.verifyCodeTime,
      'verifyCodeHash': instance.verifyCodeHash,
    };
