import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/base.dart';

part 'message.g.dart';

enum MessageType {
  @JsonValue(1)
  text,
  @JsonValue(2)
  image,
  @JsonValue(3)
  audio,
  @JsonValue(4)
  video,
  @JsonValue(5)
  system,
}

enum SendState { sending, success, failed }

@JsonSerializable()
@CopyWith()
class Message extends BaseModel {
  Message({
    this.fromUserId,
    this.groupId,
    this.toUserId,
    this.msgId,
    String msg,
    this.msgType,
    this.data,
    this.sendState,
  }) : msg = msg ?? '';

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  int get conversationId =>
      groupId ??
      ((toUserId != null && toUserId != ownUserInfo.value.userId)
          ? toUserId
          : fromUserId);

  final int fromUserId;
  final int groupId;
  @JsonKey(name: 'userId')
  final int toUserId;
  final int msgId;
  final MessageType msgType;
  String msg;

  @JsonKey(ignore: true)
  dynamic data;
  @JsonKey(ignore: true)
  BehaviorSubject<SendState> sendState;
}

@JsonSerializable()
class MessageList extends BaseModel {
  MessageList({this.list});

  factory MessageList.fromJson(Map<String, dynamic> json) =>
      _$MessageListFromJson(json);
  Map<String, dynamic> toJson() => _$MessageListToJson(this);

  final List<Message> list;
}
