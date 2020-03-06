import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'group_user.g.dart';

@JsonSerializable()
@CopyWith()
class GroupUser extends BaseModel {
  GroupUser();

  factory GroupUser.fromJson(Map<String, dynamic> json) =>
      _$GroupUserFromJson(json);
  Map<String, dynamic> toJson() => _$GroupUserToJson(this);
}
