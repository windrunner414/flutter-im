import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'conversation.g.dart';

enum ConversationType {
  @JsonValue(0)
  user,
  @JsonValue(1)
  group,
}

@JsonSerializable()
@CopyWith()
class Conversation extends BaseModel {
  const Conversation({
    this.fromId,
    this.type,
    this.desc,
    this.updateAt,
    this.unreadMsgCount,
    this.msgId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  final int fromId;
  final ConversationType type;
  final String desc;
  final int updateAt;
  final int unreadMsgCount;
  final int msgId;
}
