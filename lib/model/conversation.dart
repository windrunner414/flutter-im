import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';
import 'package:wechat/model/message.dart';

part 'conversation.g.dart';

enum ConversationType {
  @JsonValue(1)
  friend,
  @JsonValue(2)
  group,
}

@JsonSerializable()
@CopyWith()
class Conversation extends BaseModel {
  const Conversation({
    this.fromId,
    this.type,
    this.msg,
    int updateAt,
    this.unreadMsgNum,
    this.msgType,
  }) : updateAt =
            (updateAt ?? 99999999999) < 9999999999 ? updateAt * 1000 : updateAt;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  final int fromId;
  @JsonKey(name: 'msgType')
  final ConversationType type;
  final String msg;
  @JsonKey(name: 'addTime')
  final int updateAt;
  @JsonKey(name: 'num')
  final int unreadMsgNum;
  @JsonKey(name: 'msgType2')
  final MessageType msgType;
}

@JsonSerializable()
class ConversationList extends BaseModel {
  ConversationList({this.list});

  factory ConversationList.fromJson(Map<String, dynamic> json) =>
      _$ConversationListFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationListToJson(this);

  final List<Conversation> list;
}
