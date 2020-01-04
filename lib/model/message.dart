import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'message.g.dart';

@JsonSerializable()
@CopyWith()
class Message extends BaseModel {
  const Message({this.fromUserId, this.msgId, this.msg});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  final int fromUserId;
  final int msgId;
  final String msg;
}
